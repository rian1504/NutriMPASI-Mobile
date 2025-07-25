// Nama File: post.dart
// Deskripsi: File ini adalah halaman postingan yang digunakan untuk menampilkan detail dari postingan pada forum diskusi pengguna aplikasi Nutrimpasi.
// Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// Tanggal: 13 Mei 2025

import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/blocs/authentication/authentication_bloc.dart';
import 'package:nutrimpasi/blocs/comment/comment_bloc.dart';
import 'package:nutrimpasi/blocs/thread/thread_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart' show AppIcons;
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/comment.dart';
import 'package:nutrimpasi/models/thread.dart' as thread_model;
import 'package:nutrimpasi/utils/flushbar.dart';
import 'package:nutrimpasi/utils/menu_dialog.dart'
    show showCommentPreviewAndMenu, showThreadPreviewAndMenu;
import 'package:nutrimpasi/utils/report_dialog.dart';
import 'package:timeago/timeago.dart' as timeago;

// Widget untuk menampilkan app bar forum diskusi
import '../../widgets/custom_app_bar.dart' show AppBarForum;

class ThreadScreen extends StatefulWidget {
  final int threadId;
  final int? highlightCommentId;
  final String? screenCategory;

  const ThreadScreen({
    super.key,
    required this.threadId,
    this.highlightCommentId,
    this.screenCategory,
  });

  @override
  State<ThreadScreen> createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen> {
  ThreadDetail? thread;
  Comment? _editingComment;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<CommentBloc>().add(FetchComments(threadId: widget.threadId));

    if (widget.highlightCommentId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToHighlightedComment();
      });
    }
  }

  // Fungsi untuk scroll ke komentar yang di-highlight
  void _scrollToHighlightedComment() {
    if (thread == null || widget.highlightCommentId == null) return;

    final commentIndex = thread!.comments.indexWhere(
      (comment) => comment.id == widget.highlightCommentId,
    );

    if (commentIndex != -1) {
      Future.delayed(const Duration(milliseconds: 300), () {
        final commentHeight = 120.0;
        final scrollPosition = commentHeight * commentIndex;

        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            scrollPosition,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dapatkan data user dari authentication bloc
    final authState = context.watch<AuthenticationBloc>().state;
    final loggedInUser = authState is LoginSuccess ? authState.user : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarForum(
        title: "Detail Postingan",
        showBackButton: true,
        category: widget.screenCategory ?? '',
      ),
      body: Container(
        decoration: BoxDecoration(color: AppColors.primary),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), // hanya lengkung kanan bawah
            ),
          ),
          child: BlocBuilder<CommentBloc, CommentState>(
            builder: (context, state) {
              if (state is CommentLoading) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (state is CommentLoaded) {
                thread = state.thread;

                // Jika ada highlightCommentId, scroll ke komentar tersebut
                if (widget.highlightCommentId != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToHighlightedComment();
                  });
                }
              }

              if (thread == null) {
                return Center(
                  child: Text(
                    "Tidak ada data postingan.",
                    style: TextStyle(color: AppColors.textBlack),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                        child: Column(
                          children: [
                            _ThreadSection(
                              thread: thread!,
                              showReport: loggedInUser!.id != thread!.user.id,
                              showMenu: loggedInUser.id == thread!.user.id,
                              currentUserId: loggedInUser.id,
                            ),
                            // Komentar
                            if (thread!.comments.isEmpty)
                              _buildEmptyComments(context)
                            else
                              Card(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                                child: Column(
                                  children: [
                                    ...List.generate(thread!.comments.length, (
                                      index,
                                    ) {
                                      final comment = thread!.comments[index];
                                      return Column(
                                        // Membungkus _CommentSection dan Divider
                                        children: [
                                          CommentSection(
                                            comment: comment,
                                            showMenu:
                                                loggedInUser.id ==
                                                comment.user.id,
                                            showReport:
                                                loggedInUser.id !=
                                                comment.user.id,
                                            currentUserId: loggedInUser.id,
                                            threadId: thread!.id.toString(),
                                            highlight:
                                                widget.highlightCommentId !=
                                                    null &&
                                                widget.highlightCommentId ==
                                                    comment.id,
                                            onEdit: (commentToEdit) {
                                              setState(() {
                                                _editingComment = commentToEdit;
                                              });
                                            },
                                          ),
                                          // Tampilkan Divider HANYA JIKA BUKAN KOMENTAR TERAKHIR
                                          if (index <
                                              thread!.comments.length - 1)
                                            const Divider(
                                              color: AppColors.grey,
                                              height: 1,
                                            ), // Garis tipis
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: _CommentInputBar(
          threadId: widget.threadId,
          commentToEdit: _editingComment,
          onCancelEdit: () => setState(() => _editingComment = null),
        ),
      ),
    );
  }
}

class _ThreadSection extends StatefulWidget {
  final ThreadDetail thread;
  final bool showReport;
  final bool showMenu;
  final int currentUserId;

  const _ThreadSection({
    required this.thread,
    this.showReport = false,
    this.showMenu = false,
    required this.currentUserId,
  });

  @override
  State<_ThreadSection> createState() => _ThreadSectionState();
}

class _ThreadSectionState extends State<_ThreadSection> {
  late bool isLiked;
  late int likeCount;

  @override
  void initState() {
    super.initState();
    isLiked = widget.thread.isLike;
    likeCount = widget.thread.likesCount;
  }

  void _showMenuDialog() {
    // Konversi inline ke Map/JSON sebagai perantara
    final convertedThread = thread_model.Thread(
      id: widget.thread.id,
      userId: widget.thread.user.id,
      title: widget.thread.title,
      content: widget.thread.content,
      createdAt: widget.thread.createdAt,
      likesCount: widget.thread.likesCount,
      commentsCount: widget.thread.commentsCount,
      isLike: true,
      user: thread_model.User(
        id: widget.thread.user.id,
        name: widget.thread.user.name,
        avatar: widget.thread.user.avatar,
      ),
    );

    showThreadPreviewAndMenu(
      context: context,
      thread: convertedThread,
      threadId: widget.thread.id.toString(),
      showMenu: widget.showMenu,
      showReport: widget.showReport,
      currentUserId: widget.currentUserId,
      isFromDetailPage: true,
    );
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount = isLiked ? likeCount + 1 : likeCount - 1;
    });
    context.read<ThreadBloc>().add(ToggleLike(threadId: widget.thread.id));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Thread
        Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryHighTransparent,
                                  shape: BoxShape.circle,
                                ),
                                child:
                                    widget.thread.user.avatar != null
                                        ? ClipOval(
                                          child: Image.network(
                                            storageUrl +
                                                widget.thread.user.avatar!,
                                            width: 32,
                                            height: 32,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                        : Icon(
                                          AppIcons.userFill,
                                          color: AppColors.primary,
                                          size: 20,
                                        ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.thread.user.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: AppColors.textBlack,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.showMenu)
                          GestureDetector(
                            onTap: _showMenuDialog,
                            child: Icon(AppIcons.menu, size: 20),
                          ),
                        if (widget.showReport)
                          GestureDetector(
                            onTap:
                                () => showReportDialog(
                                  context: context,
                                  category: "thread",
                                  refersId: widget.thread.id,
                                ),
                            child: Icon(AppIcons.report, size: 20),
                          ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.thread.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.thread.content,
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(48),
                              onTap: _toggleLike,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    isLiked
                                        ? AppIcons.favoriteFill
                                        : AppIcons.favorite,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    likeCount.toString(),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          timeago.format(widget.thread.createdAt),
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color:
                      AppColors
                          .primaryHighTransparent, // Pindahkan warna ke dalam BoxDecoration
                  borderRadius: const BorderRadius.only(
                    // Atur radius hanya pada bagian bawah
                    bottomLeft: Radius.circular(12), // Radius 12 di kiri bawah
                    bottomRight: Radius.circular(
                      12,
                    ), // Radius 12 di kanan bawah
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(
                    "${widget.thread.commentsCount} komentar",
                    style: TextStyle(fontSize: 14, color: AppColors.textBlack),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CommentSection extends StatefulWidget {
  final Comment comment;
  final bool showMenu; // showMenu untuk opsi edit/delete
  final bool showReport; // showReport untuk opsi report
  final int currentUserId; // ID user yang sedang login
  final String threadId; // ID thread yang relevan untuk DeleteComment
  final bool highlight;
  final Function(Comment)? onEdit;

  const CommentSection({
    super.key,
    required this.comment,
    required this.showMenu,
    required this.showReport,
    required this.currentUserId,
    required this.threadId, // Pastikan threadId diterima
    this.highlight = false,
    this.onEdit,
  });

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  bool _isExpanded = false;
  final int _maxChars = 200; // Batas karakter untuk memotong teks
  bool _isHighlighted = false;
  Timer? _highlightTimer;

  @override
  void initState() {
    super.initState();
    _isHighlighted = widget.highlight;

    // Fungsi untuk mengatur highlight
    if (_isHighlighted) {
      _highlightTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isHighlighted = false;
          });
        }
      });
    }
  }

  @override
  void didUpdateWidget(CommentSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.highlight && !_isHighlighted) {
      setState(() {
        _isHighlighted = true;
      });

      _highlightTimer?.cancel();
      _highlightTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isHighlighted = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _highlightTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    VoidCallback? longPressAction;

    if (widget.showMenu) {
      longPressAction =
          () => showCommentPreviewAndMenu(
            context: context,
            comment: widget.comment,
            threadId: widget.threadId,
            currentUserId: widget.currentUserId,
            showMenu: widget.showMenu,
            showReport: widget.showReport,
            onEdit: widget.onEdit,
          );
    } else if (widget.showReport) {
      longPressAction =
          () => showReportDialog(
            context: context,
            category: "comment",
            refersId: widget.comment.id,
          );
    }

    // Tentukan apakah teks perlu dipotong
    final bool shouldShowReadMore =
        widget.comment.content.length > _maxChars && !_isExpanded;
    final bool shouldShowCollapse =
        widget.comment.content.length > _maxChars && _isExpanded;

    return GestureDetector(
      onLongPress: longPressAction,
      child: Container(
        constraints: BoxConstraints(minHeight: 60),
        decoration: BoxDecoration(
          // Use _isHighlighted instead of widget.highlight
          color: _isHighlighted ? AppColors.buff.withAlpha(75) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 10, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // photo profile
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primaryHighTransparent, // abu-abu muda
                      shape: BoxShape.circle,
                    ),
                    child:
                        widget.comment.user.avatar != null
                            ? ClipOval(
                              child: Image.network(
                                storageUrl + widget.comment.user.avatar!,
                                width: 32,
                                height: 32,
                                fit: BoxFit.cover,
                              ),
                            )
                            : Icon(
                              AppIcons.userFill,
                              color: AppColors.primary,
                              size: 20, // opsional, atur agar pas di lingkaran
                            ),
                  ),
                  SizedBox(width: 8),
                  // Nama pengguna dan isi komentar
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Nama pengguna
                            Text(
                              widget.comment.user.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: AppColors.textBlack,
                              ),
                            ),
                            // menu edit delete
                            if (widget.showMenu)
                              GestureDetector(
                                onTap:
                                    () => showCommentPreviewAndMenu(
                                      context: context,
                                      comment: widget.comment,
                                      threadId: widget.threadId,
                                      currentUserId: widget.currentUserId,
                                      showMenu: widget.showMenu,
                                      showReport: widget.showReport,
                                      onEdit: widget.onEdit!,
                                    ),
                                child: Icon(AppIcons.menu, size: 20),
                              ),
                            // report comment
                            if (widget.showReport)
                              Padding(
                                padding: const EdgeInsets.only(right: 6.0),
                                child: GestureDetector(
                                  onTap:
                                      () => showReportDialog(
                                        context: context,
                                        category: "comment",
                                        refersId: widget.comment.id,
                                      ),
                                  child: Icon(AppIcons.report, size: 20),
                                ),
                              ),
                          ],
                        ),
                        // Tanggal posting
                        Text(
                          timeago.format(widget.comment.createdAt),
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 10,
                            color: AppColors.textGrey,
                          ),
                        ),
                        SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text.rich(
                            TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      _isExpanded // Jika diperluas
                                          ? widget
                                              .comment
                                              .content // Tampilkan seluruh konten
                                          : (widget.comment.content.length >
                                                  _maxChars // Jika tidak diperluas dan panjang melebihi batas
                                              ? widget.comment.content
                                                  .substring(
                                                    0,
                                                    _maxChars,
                                                  ) // Potong teks
                                              : widget
                                                  .comment
                                                  .content), // Atau tampilkan seluruhnya jika tidak melebihi batas
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textBlack,
                                  ),
                                ),
                                // Tampilkan "Selengkapnya" hanya jika teks terpotong DAN belum diperluas
                                if (shouldShowReadMore)
                                  TextSpan(
                                    text:
                                        '  Selengkapnya', // Tambahkan ellipsis di sini
                                    style: const TextStyle(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    recognizer:
                                        TapGestureRecognizer()
                                          ..onTap = () {
                                            setState(() {
                                              _isExpanded =
                                                  true; // Perluas teks saat diklik
                                            });
                                          },
                                  ),
                              ],
                            ),
                            textAlign: TextAlign.justify,
                            // Jika Anda ingin mengontrol maxLines secara eksplisit, gunakan ini:
                            // maxLines: _isExpanded ? null : _maxLinesInitial,
                            // overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                          ),
                        ),
                        // Tombol "Ciutkan" akan muncul di baris baru di bawah teks yang diperluas
                        if (shouldShowCollapse) // Hanya tampilkan "Ciutkan" jika teks sudah diperluas
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isExpanded = false; // Ciutkan teks saat diklik
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 4.0,
                              ), // Beri jarak dari teks di atasnya
                              child: Text(
                                'Sembunyikan',
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.normal,
                                  // fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget untuk menampilkan input komentar
class _CommentInputBar extends StatefulWidget {
  final int threadId;
  final Comment? commentToEdit;
  final VoidCallback? onCancelEdit;

  const _CommentInputBar({
    required this.threadId,
    this.commentToEdit,
    this.onCancelEdit,
  });

  @override
  State<_CommentInputBar> createState() => _CommentInputBarState();
}

class _CommentInputBarState extends State<_CommentInputBar> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _commentFocusNode.dispose(); // <<< DISPOSE FOCUSNODE
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.commentToEdit != null) {
      _controller.text = widget.commentToEdit!.content;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _commentFocusNode.requestFocus();
        }
      });
    }
  }

  @override
  void didUpdateWidget(_CommentInputBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.commentToEdit != oldWidget.commentToEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.text = widget.commentToEdit?.content ?? '';
          if (widget.commentToEdit != null) {
            _commentFocusNode.requestFocus();
          }
        }
      });
    }
  }

  void _handleCancelEdit() {
    _controller.clear(); // Membersihkan controller
    _commentFocusNode.unfocus(); // Menghilangkan focus dari input
    widget.onCancelEdit?.call(); // Memanggil callback cancel
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.commentToEdit != null;

    return BlocConsumer<CommentBloc, CommentState>(
      listener: (context, state) {
        _commentFocusNode.unfocus();
        if (state is CommentStored || state is CommentUpdated) {
          _controller.clear();
          if (isEditing && widget.onCancelEdit != null) {
            widget.onCancelEdit!();
          }

          AppFlushbar.showSuccess(
            context,
            message: "Komentar berhasil dikirim!",
            title: "Berhasil",
            position: FlushbarPosition.BOTTOM,
            marginVerticalValue: 8,
          );
        } else if (state is CommentDeleted) {
          AppFlushbar.showSuccess(
            context,
            message: "Komentar berhasil dihapus",
            title: "Berhasil",
            position: FlushbarPosition.BOTTOM,
            marginVerticalValue: 8,
          );
        } else if (state is CommentError) {
          AppFlushbar.showError(context, message: state.error, title: "Error");
        }
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
            // border: Border(top: BorderSide(color: AppColors.grey)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isEditing)
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: _handleCancelEdit,
                ),
              Expanded(
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    controller: _controller,
                    maxLines: null, // Membuatnya bisa auto-expand vertikal
                    // minLines: 1, // Jumlah minimum baris
                    focusNode: _commentFocusNode,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Tulis komentar...',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Komentar tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors
                          .primary, // <-- Ini yang mengatur warna background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      30,
                    ), // Atur border radius jika perlu
                  ),
                  padding: EdgeInsets.all(10), // Atur padding jika perlu
                ),
                onPressed:
                    state is CommentActionInProgress
                        ? null
                        : () async {
                          if (formKey.currentState!.validate()) {
                            if (isEditing) {
                              // Jika dalam mode edit, kirim event update
                              context.read<CommentBloc>().add(
                                UpdateComments(
                                  commentId: widget.commentToEdit!.id,
                                  content: _controller.text.trim(),
                                ),
                              );
                            } else {
                              // Jika tidak, kirim event store baru
                              context.read<CommentBloc>().add(
                                StoreComments(
                                  threadId: widget.threadId,
                                  content: _controller.text.trim(),
                                ),
                              );
                            }
                          }
                        },
                icon:
                    state is CommentActionInProgress
                        ? CircularProgressIndicator(color: Colors.white)
                        : Icon(
                          isEditing ? Icons.check : AppIcons.send,
                          color: Colors.white,
                          size: 20,
                        ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _buildEmptyComments(BuildContext context) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 2,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.forum_outlined,
            size: 64,
            color: AppColors.primaryLowTransparent,
          ),
          const SizedBox(height: 16),
          Text(
            "Belum Ada Diskusi",
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Jadilah yang pertama berkomentar dan mulai diskusi menarik",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textGrey,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
