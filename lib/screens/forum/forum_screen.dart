// // Nama File: forum.dart
// // Deskripsi: File ini adalah halaman forum yang digunakan untuk menampilkan forum diskusi pengguna aplikasi Nutrimpasi.
// // Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// // Tanggal: 12 Mei 2025

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/blocs/authentication/authentication_bloc.dart';
import 'package:nutrimpasi/blocs/thread/thread_bloc.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/thread.dart';
import 'package:nutrimpasi/screens/forum/create_post_screen.dart';
import 'package:nutrimpasi/screens/forum/edit_post_screen.dart';
import 'package:nutrimpasi/screens/forum/post_screen.dart';
import 'package:nutrimpasi/utils/navigation_animation.dart' show pushWithSlideTransition;
import 'package:nutrimpasi/widgets/forum_app_bar.dart' show AppBarForum;
import 'package:nutrimpasi/widgets/forum_report_button.dart';
import 'package:nutrimpasi/widgets/message_dialog.dart';
import 'package:timeago/timeago.dart' as timeago;

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  List<Thread>? threads;

  @override
  void initState() {
    super.initState();
    context.read<ThreadBloc>().add(FetchThreads());
  }

  @override
  Widget build(BuildContext context) {
    // Dapatkan data user dari authentication bloc
    final authState = context.watch<AuthenticationBloc>().state;
    final loggedInUser = authState is LoginSuccess ? authState.user : null;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBarForum(title: "Forum Diskusi", showTabs: true, category: ''),
        body: Container(
          decoration: BoxDecoration(color: AppColors.primary),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: BlocConsumer<ThreadBloc, ThreadState>(
                listener: (context, state) {
                  if (state is ThreadDeleted) {
                    // _showDialogReportSuccess(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Berhasil menghapus thread"),
                        backgroundColor: Colors.red,
                      ),
                    );

                    context.read<ThreadBloc>().add(FetchThreads());
                  } else if (state is ThreadError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error), backgroundColor: Colors.red),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ThreadLoading) {
                    return Center(child: CircularProgressIndicator(color: AppColors.primary));
                  }

                  if (state is ThreadLoaded) {
                    threads = state.threads;
                  }

                  return TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      _ForumTab(
                        threads: threads,
                        isMyPosts: false,
                        currentUserId: loggedInUser!.id,
                      ),
                      _ForumTab(threads: threads, isMyPosts: true, currentUserId: loggedInUser.id),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ForumTab extends StatelessWidget {
  final List<Thread>? threads;
  final bool isMyPosts;
  final int currentUserId;

  const _ForumTab({
    super.key,
    required this.threads,
    required this.isMyPosts,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final filteredThreads =
        threads?.where((thread) {
          return !isMyPosts || thread.userId == currentUserId;
        }).toList();

    return Stack(
      children: [
        SingleChildScrollView(
          // padding: const EdgeInsets.fromLTRB(18, 0, 18, 100),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 1 / 1.8 * MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Postingan Terpopuler",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                        Icon(AppIcons.arrowDown, size: 20, color: AppColors.black),
                      ],
                    ),
                  ),
                ),
              ),
              if (filteredThreads == null)
                const Center(child: CircularProgressIndicator())
              else if (filteredThreads.isEmpty)
                _EmptyStateWidget(isMyPosts: isMyPosts)
              else
                ...filteredThreads.map(
                  (thread) => _ForumCard(
                    thread: thread,
                    showMenu: isMyPosts,
                    showReport: !isMyPosts && !(thread.userId == currentUserId),
                  ),
                ),
            ],
          ),
        ),
        if (isMyPosts)
          Positioned(
            bottom: 48,
            right: 16,
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              onPressed: () => pushWithSlideTransition(context, const CreatePostScreen()),
              child: const Icon(Icons.add),
            ),
          ),
      ],
    );
  }
}

class _EmptyStateWidget extends StatelessWidget {
  final bool isMyPosts;

  const _EmptyStateWidget({required this.isMyPosts});

  @override
  Widget build(BuildContext context) {
    return EmptyMessage(
      iconName: AppIcons.forum,
      title: isMyPosts ? 'Anda belum membuat postingan' : 'Belum ada postingan',
      // title: 'Belum Ada Postingan',
      subtitle: 'Tambahkan postingan Anda agar dapat berinteraksi dan menyampaikan pendapat Anda.',
      buttonText: 'Tambah Postingan',
      onPressed:
          isMyPosts
              ? () => pushWithSlideTransition(context, const CreatePostScreen())
              : null, // Jika isMyPosts false, set onPressed ke null
    );
  }
}

// ==============================
// WIDGET: _ForumCard
// ==============================
class _ForumCard extends StatefulWidget {
  final Thread thread;
  final bool showMenu;
  final bool showReport;
  final int? currentUserId;

  const _ForumCard({
    super.key,
    required this.thread,
    this.showMenu = false,
    this.showReport = false,
    this.currentUserId,
  });

  @override
  State<_ForumCard> createState() => _ForumCardState();
}

class _ForumCardState extends State<_ForumCard> {
  late bool isLiked;
  late int likeCount;
  final GlobalKey _menuKey = GlobalKey();
  OverlayEntry? _overlayEntry;

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
  //               top: offset.dy + size.height + 14,
  //               width: 150,
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   // Tombol Edit Postingan
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
  //                           "Edit Postingan",
  //                           style: TextStyle(fontSize: 16, color: AppColors.accent),
  //                         ),
  //                         onTap: () {
  //                           _hideMenu();
  //                           Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                               builder: (context) => EditPostScreen(thread: widget.thread),
  //                             ),
  //                           );
  //                         },
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 8),

  //                   // Tombol Hapus Postingan
  //                   if (widget.showMenu)
  //                     // const SizedBox(height: 8)
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
  //                             "Hapus Postingan",
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

  // >>> FUNGSI UNTUK MENAMPILKAN DIALOG PREVIEW DAN OPSI <<<
  void _showForumCardPreviewAndOptionsDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black87,
      barrierDismissible: true,
      barrierLabel: '_ForumCardOptions',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent, // Untuk transparansi latar belakang
            child: Column(
              // Menggunakan Column untuk menumpuk card dan opsi
              mainAxisSize: MainAxisSize.min, // Agar Column sekecil mungkin
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // === Bagian _ForumCard (Gaya Sama, Tapi Non-Interaktif) ===
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.92,
                  child: IgnorePointer(
                    // Kunci utama: Ini membuat _ForumCard tidak interaktif
                    ignoring: true, // Selalu mengabaikan semua event pointer
                    child: _ForumCard(
                      // <<< Menggunakan instance _ForumCard yang sama
                      key: ValueKey(
                        '${widget.thread.id}_dialog_preview',
                      ), // Beri key unik jika perlu
                      thread: widget.thread,
                      showMenu: widget.showMenu, // Teruskan properti showMenu untuk tampilan
                      showReport: widget.showReport, // Teruskan properti showReport untuk tampilan
                      currentUserId: widget.currentUserId, // Teruskan currentUserId
                    ),
                  ),
                ),
                // === Bagian Opsi "Report", "Block Account" ===
                const SizedBox(height: 8), // Jarak antara card dan opsi
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * (1 / 2.5),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Tombol Edit Postingan
                        Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.accentHighTransparent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: ListTile(
                              leading: Icon(AppIcons.edit, size: 20, color: AppColors.accent),
                              title: Text(
                                "Edit Postingan",
                                style: TextStyle(fontSize: 16, color: AppColors.accent),
                              ),
                              onTap: () {
                                _hideMenu();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditPostScreen(thread: widget.thread),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Tombol Hapus Postingan
                        if (widget.showMenu)
                          // const SizedBox(height: 8)
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
                                  "Hapus Postingan",
                                  style: TextStyle(fontSize: 16, color: AppColors.error),
                                ),
                                onTap: _confirmDelete,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );
  }

  Future<void> _confirmDelete() async {
    _hideMenu();
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Konfirmasi Hapus"),
            content: const Text("Apakah Anda yakin ingin menghapus postingan ini?"),
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
      context.read<ThreadBloc>().add(DeleteThreads(threadId: widget.thread.id));
    }
  }

  void _hideMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => pushWithSlideTransition(context, PostScreen(threadId: widget.thread.id)),
      child: Card(
        // margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
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
                                color: AppColors.primaryHighTransparent,
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
                                      : Icon(AppIcons.userFill, color: AppColors.primary, size: 20),
                            ),
                            SizedBox(width: 8),
                            Text(
                              widget.thread.user.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        timeago.format(widget.thread.createdAt),
                        style: TextStyle(color: AppColors.greyDark, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Title
                  Text(
                    widget.thread.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  // Content
                  Text(
                    widget.thread.content,
                    textAlign: TextAlign.justify,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Bottom actions
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 0, 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Row(
                                mainAxisSize:
                                    MainAxisSize.min, // Agar Row hanya mengambil ruang minimal
                                children: [
                                  Icon(
                                    isLiked
                                        ? AppIcons.favoriteFill
                                        : AppIcons.favorite, // Ikon berubah
                                    color:
                                        isLiked
                                            ? Colors.red
                                            : AppColors.black, // Warna ikon berubah jika liked
                                    size: 24,
                                  ),
                                  const SizedBox(width: 4), // Jarak antara ikon dan teks
                                  Text(
                                    likeCount.toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color:
                                          isLiked
                                              ? Colors.red
                                              : AppColors.black, // Warna teks juga berubah
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: _toggleLike,
                            ),
                          ],
                        ),
                        SizedBox(width: 4),
                        IconButton(
                          icon: Row(
                            mainAxisSize:
                                MainAxisSize.min, // Penting agar Row tidak memakan ruang lebih
                            children: [
                              Icon(AppIcons.comment, size: 24, color: AppColors.black),
                              const SizedBox(width: 4), // Sedikit jarak antara ikon dan teks
                              Text(
                                widget.thread.commentsCount.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.black,
                                ), // Sesuaikan warna teks
                              ),
                            ],
                          ),
                          onPressed:
                              () => pushWithSlideTransition(
                                context,
                                PostScreen(threadId: widget.thread.id),
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.showMenu)
                    IconButton(
                      key: _menuKey,
                      icon: Icon(AppIcons.menu, size: 20),
                      // onPressed: _showMenu,
                      onPressed: () => _showForumCardPreviewAndOptionsDialog(context),
                    ),
                  if (widget.showReport)
                    ReportButton(category: "thread", refersId: widget.thread.id),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
