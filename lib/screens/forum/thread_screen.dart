// Nama File: post.dart
// Deskripsi: File ini adalah halaman postingan yang digunakan untuk menampilkan detail dari postingan pada forum diskusi pengguna aplikasi Nutrimpasi.
// Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// Tanggal: 13 Mei 2025

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/blocs/authentication/authentication_bloc.dart';
import 'package:nutrimpasi/blocs/comment/comment_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart' show AppIcons;
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/comment.dart';
import 'package:nutrimpasi/utils/menu_dialog.dart' show showCommentPreviewAndMenu;
import 'package:nutrimpasi/utils/report_dialog.dart';
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
      appBar: AppBarForum(title: "Thread", showBackButton: true, category: 'forum'),
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
                return Center(child: CircularProgressIndicator(color: AppColors.primary));
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
                            showReport: loggedInUser != null && loggedInUser.id != thread!.user.id,
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
                                  ...List.generate(thread!.comments.length, (index) {
                                    final comment = thread!.comments[index];
                                    return Column(
                                      // Membungkus _CommentSection dan Divider
                                      children: [
                                        CommentSection(
                                          comment: comment,
                                          showMenu:
                                              loggedInUser != null &&
                                              loggedInUser.id == comment.user.id,
                                          showReport:
                                              loggedInUser != null &&
                                              loggedInUser.id != comment.user.id,
                                          currentUserId: loggedInUser != null ? loggedInUser.id : 0,
                                          threadId: thread!.id.toString(),
                                        ),
                                        // Tampilkan Divider HANYA JIKA BUKAN KOMENTAR TERAKHIR
                                        if (index < thread!.comments.length - 1)
                                          const Divider(
                                            color: AppColors.grey,
                                            height: 1,
                                          ), // Garis tipis
                                      ],
                                    );
                                  }),
                                  // ...thread!.comments.map((comment) {
                                  //   return _CommentSection(
                                  //     comment: comment,
                                  //     showMenu:
                                  //         loggedInUser != null &&
                                  //         loggedInUser.id == comment.user.id,
                                  //     showReport:
                                  //         loggedInUser != null &&
                                  //         loggedInUser.id != comment.user.id,
                                  //   );
                                  // }),
                                  // Divider(color: AppColors.grey),
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
  final bool showMenu;

  const _PostSection({required this.thread, this.showReport = false, this.showMenu = false});

  @override
  State<_PostSection> createState() => _PostSectionState();
}

class _PostSectionState extends State<_PostSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Thread
        Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                                  color: AppColors.primaryHighTransparent, // abu-abu muda
                                  shape: BoxShape.circle,
                                ),
                                child:
                                    widget.thread.user.avatar != null
                                        ? ClipOval(
                                          child: Image.network(
                                            storageUrl + widget.thread.user.avatar!,
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
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                            Icon(
                              widget.thread.isLike ? AppIcons.favoriteFill : AppIcons.favorite,
                              color: Colors.red,
                              size: 24,
                            ),
                            SizedBox(width: 4),
                            Text(
                              widget.thread.likesCount.toString(),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),

                        if (widget.showReport)
                          // Tombol untuk melaporkan postingan
                          // ReportButton(category: "thread", refersId: widget.thread.id),
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

class CommentSection extends StatefulWidget {
  final Comment comment;
  final bool showMenu; // showMenu untuk opsi edit/delete
  final bool showReport; // showReport untuk opsi report
  final int currentUserId; // ID user yang sedang login
  final String threadId; // ID thread yang relevan untuk DeleteComment

  const CommentSection({
    super.key,
    required this.comment,
    required this.showMenu,
    required this.showReport,
    required this.currentUserId,
    required this.threadId, // Pastikan threadId diterima
  });

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final GlobalKey _menuKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isExpanded = false;
  final int _maxChars = 200; // Batas karakter untuk memotong teks
  final int _maxLinesInitial = 5; // Batas baris awal jika ingin menggunakan maxLines

  // >>> FUNGSI UNTUK MENAMPILKAN DIALOG PREVIEW DAN OPSI <<<
  void _showCommentPreviewAndOptionsDialog(BuildContext parentContext) {
    showGeneralDialog(
      context: parentContext,
      barrierColor: Colors.black87, // Latar belakang gelap transparan
      barrierDismissible: true, // Bisa ditutup dengan tap di luar
      barrierLabel: 'Comment Options',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.center,
          child: ScaleTransition(
            // Animasi pop-up diterapkan di sini
            scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            child: Material(
              color: Colors.transparent, // Untuk transparansi latar belakang
              child: Column(
                mainAxisSize: MainAxisSize.min, // Agar Column sekecil mungkin
                crossAxisAlignment: CrossAxisAlignment.end, // Agar menu opsi berada di kanan
                children: [
                  // === Bagian Preview Komentar (Non-Interaktif) ===
                  SizedBox(
                    width: MediaQuery.of(parentContext).size.width * 0.9,
                    child: IgnorePointer(
                      // Kunci utama: Ini membuat preview komentar tidak interaktif
                      ignoring: true, // Selalu mengabaikan semua event pointer
                      child: Card(
                        // Membungkus _CommentSection dalam Card agar memiliki gaya serupa
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: EdgeInsets.zero, // Hapus margin default Card
                        elevation: 4, // Beri sedikit elevasi
                        child: CommentSection(
                          // Menggunakan instance _CommentSection yang sama
                          // Untuk preview, kita tidak perlu showMenu/showReport aktif di dalam _CommentSection itu sendiri
                          // karena opsi akan ditampilkan di bagian terpisah di bawahnya.
                          key: ValueKey('${widget.comment.id}_dialog_preview'), // Beri key unik
                          comment: widget.comment,
                          showMenu: false,
                          showReport: false,
                          currentUserId: widget.currentUserId,
                          threadId: widget.threadId, // Teruskan threadId
                        ),
                      ),
                    ),
                  ),
                  // === Bagian Opsi "Report", "Block Account", dll. ===
                  const SizedBox(height: 8), // Jarak antara preview komentar dan opsi
                  // Padding ini agar opsi rata kanan seperti pada contoh gambar
                  // Lebar 1/2.5 * width adalah sekitar 40% dari lebar layar
                  SizedBox(
                    width: MediaQuery.of(parentContext).size.width * (1 / 2.5),
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8), // Sudut membulat
                      color: Colors.black87, // Latar belakang opsi gelap
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Opsi Edit dan Delete (jika showMenu true)
                          if (widget.showMenu) // Jika komentar milik user yang login
                            Column(
                              // Menggunakan Column karena ada lebih dari 1 ListTile
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Icon(AppIcons.edit, size: 20, color: AppColors.accent),
                                  title: const Text(
                                    "Edit Komentar",
                                    style: TextStyle(fontSize: 16, color: AppColors.accent),
                                  ),
                                  onTap: () {
                                    Navigator.pop(dialogContext); // Tutup dialog ini
                                    // Navigasi ke EditCommentScreen
                                    // Navigator.push(
                                    //   parentContext, // Gunakan context asli untuk navigasi layar
                                    //   MaterialPageRoute(
                                    //     builder: (ctx) => EditCommentScreen(comment: widget.comment, threadId: widget.threadId),
                                    //   ),
                                    // );
                                  },
                                ),
                                const Divider(height: 1, color: Colors.white12), // Pemisah
                                ListTile(
                                  leading: Icon(
                                    AppIcons.deleteFill,
                                    size: 20,
                                    color: AppColors.error,
                                  ),
                                  title: const Text(
                                    "Hapus Komentar",
                                    style: TextStyle(fontSize: 16, color: AppColors.error),
                                  ),
                                  onTap: () {
                                    Navigator.pop(dialogContext); // Tutup dialog ini
                                    _confirmDelete(); // Panggil fungsi hapus
                                  },
                                ),
                              ],
                            ),
                          // Opsi Report (jika showReport true)
                          if (widget.showReport) // Jika komentar bukan milik user yang login
                            ListTile(
                              leading: const Icon(Icons.report, color: Colors.red),
                              title: const Text(
                                'Report',
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                Navigator.pop(dialogContext); // Tutup dialog ini
                                ScaffoldMessenger.of(parentContext).showSnackBar(
                                  SnackBar(
                                    content: Text('Melaporkan komentar ${widget.comment.id}'),
                                  ),
                                );
                                // TODO: Logika untuk mengirim laporan komentar
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // void _showMenu() {
  //   final renderBox = _menuKey.currentContext!.findRenderObject() as RenderBox;
  //   final offset = renderBox.localToGlobal(Offset.zero);
  //   final size = renderBox.size;

  //   _overlayEntry = OverlayEntry(
  //     builder:
  //         (context) => Stack(
  //           children: [
  //             GestureDetector(
  //               onTap: _hideMenu,
  //               behavior: HitTestBehavior.opaque,
  //               child: Container(color: Colors.black45),
  //             ),
  //             Positioned(
  //               left: offset.dx + size.width - 150,
  //               top: offset.dy + size.height,
  //               width: 150,
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   // Tombol Edit Komentar
  //                   Material(
  //                     elevation: 4,
  //                     borderRadius: BorderRadius.circular(4),
  //                     child: Container(
  //                       decoration: BoxDecoration(
  //                         color: AppColors.accentHighTransparent,
  //                         borderRadius: BorderRadius.circular(4),
  //                       ),
  //                       child: ListTile(
  //                         leading: Icon(AppIcons.edit, size: 20, color: AppColors.accent),
  //                         title: Text(
  //                           "Edit Komentar",
  //                           style: TextStyle(fontSize: 16, color: AppColors.accent),
  //                         ),
  //                         onTap: _hideMenu,
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 8),

  //                   // Tombol Hapus Komentar
  //                   if (widget.showMenu)
  //                     // const SizedBox(height: 8),
  //                     Material(
  //                       elevation: 4,
  //                       borderRadius: BorderRadius.circular(4),
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                           color: AppColors.errorHighTranparent,
  //                           borderRadius: BorderRadius.circular(4),
  //                         ),
  //                         child: ListTile(
  //                           leading: Icon(AppIcons.deleteFill, size: 20, color: AppColors.error),
  //                           title: Text(
  //                             "Hapus Komentar",
  //                             style: TextStyle(fontSize: 16, color: AppColors.error),
  //                           ),
  //                           onTap: _confirmDelete,
  //                         ),
  //                       ),
  //                     ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //   );

  //   Overlay.of(context).insert(_overlayEntry!);
  // }

  Future<void> _confirmDelete() async {
    _hideMenu();
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Konfirmasi Hapus"),
            content: const Text("Apakah Anda yakin ingin menghapus komentar ini?"),
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
      context.read<CommentBloc>().add(DeleteComments(commentId: widget.comment.id));
    }
  }

  void _hideMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    VoidCallback? longPressAction;
    GlobalKey? gestureDetectorKey; // GlobalKey opsional untuk GestureDetector ini

    if (widget.showMenu) {
      longPressAction =
          () => showCommentPreviewAndMenu(
            context: context,
            comment: widget.comment,
            threadId: widget.threadId,
            currentUserId: widget.currentUserId,
            showMenu: widget.showMenu,
            showReport: widget.showReport,
          );
      // Jika Anda perlu GlobalKey spesifik untuk menu (misal untuk posisi), letakkan di sini
      // gestureDetectorKey = _menuKey;
    } else if (widget.showReport) {
      longPressAction =
          () =>
              showReportDialog(context: context, category: "comment", refersId: widget.comment.id);
      // Jika Anda perlu GlobalKey spesifik untuk report, letakkan di sini
      // gestureDetectorKey = _reportKey;
    }

    // Tentukan apakah teks perlu dipotong
    final bool shouldShowReadMore = widget.comment.content.length > _maxChars && !_isExpanded;
    final bool shouldShowCollapse = widget.comment.content.length > _maxChars && _isExpanded;

    return GestureDetector(
      key: gestureDetectorKey, // Bisa null jika tidak ada key spesifik yang dibutuhkan
      // Hanya satu onPressed callback
      onLongPress: longPressAction,
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
                                  ),
                              child: Icon(AppIcons.menu, size: 20),
                            ),
                          // report comment
                          if (widget.showReport)
                            GestureDetector(
                              onTap:
                                  () => showReportDialog(
                                    context: context,
                                    category: "comment",
                                    refersId: widget.comment.id,
                                  ),
                              child: Icon(AppIcons.report, size: 20),
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
                                            ? '${widget.comment.content.substring(0, _maxChars)}' // Potong teks
                                            : widget
                                                .comment
                                                .content), // Atau tampilkan seluruhnya jika tidak melebihi batas
                                style: const TextStyle(fontSize: 14, color: AppColors.textBlack),
                              ),
                              // Tampilkan "Selengkapnya" hanya jika teks terpotong DAN belum diperluas
                              if (shouldShowReadMore)
                                TextSpan(
                                  text: '  Selengkapnya', // Tambahkan ellipsis di sini
                                  style: const TextStyle(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          setState(() {
                                            _isExpanded = true; // Perluas teks saat diklik
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
                      // // Tombol untuk menu
                      // if (widget.showMenu)
                      //   IconButton(
                      //     key: _menuKey,
                      //     icon: Icon(AppIcons.menu, size: 20),
                      //     onPressed: _showMenu,
                      //   ),
                      // // Tombol untuk like, comment, dan report
                      // if (widget.showReport) ReportButton(category: "comment", refersId: widget.comment.id),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Berhasil Komen"), backgroundColor: Colors.green));
        } else if (state is CommentDeleted) {
          // _showDialogReportSuccess(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Komentar dihapus"), backgroundColor: Colors.red));
        } else if (state is CommentError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error), backgroundColor: Colors.red));
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                      if (value.trim().length < 4) {
                        return 'Komentar minimal 4 karakter';
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
                          : const Icon(Icons.send, color: Colors.white, size: 18),
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
          Icon(Icons.forum_outlined, size: 64, color: AppColors.primaryLowTransparent),
          const SizedBox(height: 16),
          Text(
            "Belum Ada Diskusi",
            style: TextStyle(fontSize: 18, color: AppColors.textBlack, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Jadilah yang pertama berkomentar dan mulai diskusi menarik",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textGrey, height: 1.5),
            ),
          ),
        ],
      ),
    ),
  );
}
