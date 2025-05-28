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
import 'package:nutrimpasi/screens/forum/post_screen.dart';
import 'package:nutrimpasi/utils/navigation_animation.dart'
    show pushWithSlideTransition;
import 'package:nutrimpasi/widgets/forum_app_bar.dart' show AppBarForum;
import 'package:nutrimpasi/widgets/forum_report_button.dart';
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
        appBar: AppBarForum(title: "Forum Diskusi", showTabs: true),
        body: Container(
          decoration: BoxDecoration(color: AppColors.primary),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40)),
            ),
            child: BlocBuilder<ThreadBloc, ThreadState>(
              builder: (context, state) {
                if (state is ThreadLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (state is ThreadLoaded) {
                  threads = state.threads;
                }

                return TabBarView(
                  children: [
                    ForumTab(
                      threads: threads,
                      isMyPosts: false,
                      currentUserId: loggedInUser!.id,
                    ),
                    ForumTab(
                      threads: threads,
                      isMyPosts: true,
                      currentUserId: loggedInUser.id,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ForumTab extends StatelessWidget {
  final List<Thread>? threads;
  final bool isMyPosts;
  final int currentUserId;

  const ForumTab({
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
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 100),
          child: Column(
            children: [
              if (filteredThreads == null)
                const Center(child: CircularProgressIndicator())
              else if (filteredThreads.isEmpty)
                _EmptyStateWidget(isMyPosts: isMyPosts)
              else
                ...filteredThreads.map(
                  (thread) => ForumCard(
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              onPressed:
                  () => pushWithSlideTransition(
                    context,
                    const CreatePostScreen(),
                  ),
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
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Icon(Icons.forum, size: 64, color: AppColors.greyDark),
          const SizedBox(height: 16),
          Text(
            isMyPosts ? "Anda belum membuat postingan" : "Belum ada postingan",
            style: const TextStyle(fontSize: 16),
          ),
          if (isMyPosts) ...[
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed:
                  () => pushWithSlideTransition(
                    context,
                    const CreatePostScreen(),
                  ),
              child: const Text("Buat Postingan Pertama"),
            ),
          ],
        ],
      ),
    );
  }
}

// ==============================
// WIDGET: ForumCard
// ==============================
class ForumCard extends StatefulWidget {
  final Thread thread;
  final bool showMenu;
  final bool showReport;

  const ForumCard({
    super.key,
    required this.thread,
    this.showMenu = false,
    this.showReport = false,
  });

  @override
  State<ForumCard> createState() => _ForumCardState();
}

class _ForumCardState extends State<ForumCard> {
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
                    // Tombol Edit Postingan
                    Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.accentTransparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ListTile(
                          leading: Icon(
                            AppIcons.edit,
                            size: 20,
                            color: AppColors.accent,
                          ),
                          title: Text(
                            "Edit Postingan",
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

                    // Tombol Hapus Postingan
                    if (widget.showMenu)
                      // const SizedBox(height: 8),
                      Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.errorTranparent,
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
              "Apakah Anda yakin ingin menghapus postingan ini?",
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
      onTap:
          () => pushWithSlideTransition(
            context,
            PostScreen(threadId: widget.thread.id),
          ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
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
                                color:
                                    AppColors
                                        .primaryTransparent, // abu-abu muda
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        timeago.format(widget.thread.createdAt, locale: 'id'),
                        style: TextStyle(color: AppColors.greyDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Title
                  Text(
                    widget.thread.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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
            // const SizedBox(height: 8),
            // Bottom actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
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
                          Text(
                            likeCount.toString(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            AppIcons.comment,
                            size: 24,
                            color: AppColors.textBlack,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.thread.commentsCount.toString(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (widget.showMenu)
                  IconButton(
                    key: _menuKey,
                    icon: Icon(AppIcons.menu, size: 20),
                    onPressed: _showMenu,
                  ),
                if (widget.showReport)
                  ReportButton(category: "thread", refersId: widget.thread.id),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
