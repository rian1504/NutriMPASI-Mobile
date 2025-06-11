// Nama File: post.dart
// Deskripsi: File ini adalah halaman postingan yang digunakan untuk menampilkan detail dari postingan pada forum diskusi pengguna aplikasi Nutrimpasi.
// Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// Tanggal: 13 Mei 2025

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/blocs/authentication/authentication_bloc.dart';
import 'package:nutrimpasi/blocs/comment/comment_bloc.dart';
import 'package:nutrimpasi/blocs/thread/thread_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart' show AppIcons;
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/comment.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:nutrimpasi/widgets/custom_dialog.dart' show ReportButton;

// Widget untuk menampilkan app bar forum diskusi
import '../../widgets/custom_app_bar.dart' show AppBarForum;

class PostScreen extends StatefulWidget {
  final int threadId;

  const PostScreen({super.key, required this.threadId});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  ThreadDetail? thread;

  @override
  void initState() {
    super.initState();
    context.read<CommentBloc>().add(FetchComments(threadId: widget.threadId));
  }

  @override
  Widget build(BuildContext context) {
    // Dapatkan data user dari authentication bloc
    final authState = context.watch<AuthenticationBloc>().state;
    final loggedInUser = authState is LoginSuccess ? authState.user : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarForum(
        title: "Postingan",
        showBackButton: true,
        category: 'forum',
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
              }

              if (thread == null) {
                return Center(
                  child: Text(
                    "Tidak ada data thread.",
                    style: TextStyle(color: AppColors.textBlack),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                      child: Column(
                        children: [
                          _PostSection(
                            thread: thread!,
                            showReport:
                                loggedInUser != null &&
                                loggedInUser.id != thread!.user.id,
                          ),
                          // Komentar
                          if (thread!.comments.isEmpty)
                            _buildEmptyComments(context)
                          else
                            Card(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              elevation: 2,
                              child: Column(
                                children: [
                                  ...thread!.comments.map((comment) {
                                    return _CommentSection(
                                      comment: comment,
                                      showMenu:
                                          loggedInUser != null &&
                                          loggedInUser.id == comment.user.id,
                                      showReport:
                                          loggedInUser != null &&
                                          loggedInUser.id != comment.user.id,
                                    );
                                  }),
                                  Divider(color: AppColors.grey),
                                ],
                              ),
                            ),
                        ],
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
        child: _CommentInputBar(threadId: widget.threadId),
      ),
    );
  }
}

class _PostSection extends StatefulWidget {
  final ThreadDetail thread;
  final bool showReport;

  const _PostSection({required this.thread, this.showReport = false});

  @override
  State<_PostSection> createState() => _PostSectionState();
}

class _PostSectionState extends State<_PostSection> {
  late bool isLiked;
  late int likeCount;

  @override
  void initState() {
    super.initState();
    isLiked = widget.thread.isLike;
    likeCount = widget.thread.likesCount;
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
        // Postingan
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
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color:
                                      AppColors
                                          .primaryHighTransparent, // abu-abu muda
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
                                          size:
                                              20, // opsional, atur agar pas di lingkaran
                                        ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                widget.thread.user.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppColors.textBlack,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          timeago.format(widget.thread.createdAt),
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: AppColors.textGrey,
                          ),
                          overflow: TextOverflow.ellipsis,
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
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.thread.content,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isLiked
                                        ? AppIcons.favoriteFill
                                        : AppIcons.favorite,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                  onPressed: _toggleLike,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  likeCount.toString(),
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (widget.showReport)
                          // Tombol untuk melaporkan postingan
                          ReportButton(
                            category: "thread",
                            refersId: widget.thread.id,
                          ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                color: AppColors.primaryHighTransparent,
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

class _CommentSection extends StatefulWidget {
  final Comment comment;
  final bool showMenu;
  final bool showReport;

  const _CommentSection({
    required this.comment,
    this.showMenu = false,
    this.showReport = false,
  });
  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<_CommentSection> {
  final GlobalKey _menuKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  void _showMenu() {
    final renderBox = _menuKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              GestureDetector(
                onTap: _hideMenu,
                behavior: HitTestBehavior.opaque,
                child: Container(color: Colors.black45),
              ),
              Positioned(
                left: offset.dx + size.width - 150,
                top: offset.dy + size.height,
                width: 150,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Tombol Edit Komentar
                    Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.accentHighTransparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ListTile(
                          leading: Icon(
                            AppIcons.edit,
                            size: 20,
                            color: AppColors.accent,
                          ),
                          title: Text(
                            "Edit Komentar",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.accent,
                            ),
                          ),
                          onTap: _hideMenu,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Tombol Hapus Komentar
                    if (widget.showMenu)
                      // const SizedBox(height: 8),
                      Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.errorHighTranparent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: ListTile(
                            leading: Icon(
                              AppIcons.deleteFill,
                              size: 20,
                              color: AppColors.error,
                            ),
                            title: Text(
                              "Hapus Komentar",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.error,
                              ),
                            ),
                            onTap: _confirmDelete,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  Future<void> _confirmDelete() async {
    _hideMenu();
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Konfirmasi Hapus"),
            content: const Text(
              "Apakah Anda yakin ingin menghapus komentar ini?",
            ),
            actions: [
              TextButton(
                child: const Text("Batal"),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: const Text("Hapus", style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      context.read<CommentBloc>().add(
        DeleteComments(commentId: widget.comment.id),
      );
    }
  }

  void _hideMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        SizedBox(width: 8),
                        // Tanggal posting
                        Text(
                          timeago.format(widget.comment.createdAt),
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    // Isi komentar
                    Text(widget.comment.content, textAlign: TextAlign.justify),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Tombol untuk menu
        if (widget.showMenu)
          Padding(
            padding: const EdgeInsets.fromLTRB(44, 0, 4, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  key: _menuKey,
                  icon: Icon(AppIcons.menu, size: 20),
                  onPressed: _showMenu,
                ),
              ],
            ),
          ),
        // Tombol untuk like, comment, dan report
        if (widget.showReport)
          Padding(
            padding: const EdgeInsets.fromLTRB(44, 0, 4, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Tombol untuk melaporkan komentar
                ReportButton(category: "comment", refersId: widget.comment.id),
              ],
            ),
          ),
      ],
    );
  }
}

// Widget untuk menampilkan input komentar
class _CommentInputBar extends StatefulWidget {
  final int threadId;
  const _CommentInputBar({required this.threadId});

  @override
  State<_CommentInputBar> createState() => _CommentInputBarState();
}

class _CommentInputBarState extends State<_CommentInputBar> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentBloc, CommentState>(
      listener: (context, state) {
        if (state is CommentStored) {
          // _showDialogReportSuccess(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Berhasil Komen"),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is CommentDeleted) {
          // _showDialogReportSuccess(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Komentar dihapus"),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is CommentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    controller: _controller,
                    maxLines: null, // Membuatnya bisa auto-expand vertikal
                    // minLines: 1, // Jumlah minimum baris
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
              CircleAvatar(
                backgroundColor: AppColors.primary,
                child: IconButton(
                  icon:
                      state is CommentActionInProgress
                          ? CircularProgressIndicator(color: Colors.white)
                          : const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 18,
                          ),
                  onPressed:
                      state is CommentActionInProgress
                          ? null
                          : () async {
                            if (formKey.currentState!.validate()) {
                              context.read<CommentBloc>().add(
                                StoreComments(
                                  threadId: widget.threadId,
                                  content: _controller.text.trim(),
                                ),
                              );
                              _controller.clear();
                            }
                          },
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
