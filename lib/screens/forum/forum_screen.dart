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
import 'package:nutrimpasi/screens/forum/thread_screen.dart';
import 'package:nutrimpasi/utils/menu_dialog.dart';
import 'package:nutrimpasi/utils/navigation_animation.dart' show pushWithSlideTransition;
import 'package:nutrimpasi/utils/report_dialog.dart';
import 'package:nutrimpasi/widgets/custom_app_bar.dart' show AppBarForum;
import 'package:nutrimpasi/widgets/custom_message_dialog.dart';
import 'package:nutrimpasi/widgets/custom_scroll.dart';
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
                    physics: SlowPageScrollPhysics(),
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

  _ForumTab({
    super.key,
    required this.threads,
    required this.isMyPosts,
    required this.currentUserId,
  });

  final GlobalKey _dropdownButtonKey = GlobalKey();

  void _showDropdownOptions(BuildContext context, GlobalKey dropdownButtonKey) {
    // Mendapatkan RenderBox dari GlobalKey untuk mendapatkan posisi tombol
    final RenderBox renderBox = dropdownButtonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero); // Posisi global tombol
    // final Size size = renderBox.size; // Ukuran tombol

    // Opsi-opsi yang akan ditampilkan di dropdown
    final List<String> options = ['Terpopuler', 'Terbaru', 'Terlama'];

    showGeneralDialog(
      context: context,
      // KUNCI: Membuat barrier transparan agar kita bisa mengontrol overlay gelap sendiri.
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      barrierLabel: 'Filter Options',
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(dialogContext).pop(),
                behavior: HitTestBehavior.translucent,
                child: Container(color: Colors.black38),
              ),
            ),

            // --- Konten Utama Dialog (Tombol yang terlihat & Modal Dropdown) ---
            Positioned(
              left: offset.dx + 4,
              top: offset.dy + 4,
              width: 0.4 * MediaQuery.of(context).size.width - 8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- "Duplikat" Tombol Filter (Non-Interaktif) ---
                  IgnorePointer(
                    ignoring: true,
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      margin: EdgeInsets.zero, // Penting: hapus margin default Card
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Terpopuler",
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

                  // --- Jarak Antara Tombol dan Modal ---
                  const SizedBox(height: 8),

                  // --- Modal Dropdown Itu Sendiri ---
                  ScaleTransition(
                    scale: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
                    alignment: Alignment.topCenter,
                    child: Material(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                      elevation: 8,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            options.map((option) {
                              return ListTile(
                                title: Text(
                                  option,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                  ),
                                ),
                                onTap: () {
                                  // TODO: Implementasi logika filter di sini (misal: panggil Bloc Thread)
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Filter: $option dipilih!')),
                                  );
                                  Navigator.of(
                                    dialogContext,
                                  ).pop(); // Tutup dialog setelah memilih opsi
                                },
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

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
              // filter
              SizedBox(
                width: 0.4 * MediaQuery.of(context).size.width,
                child: GestureDetector(
                  key: _dropdownButtonKey,
                  onTap: () {
                    _showDropdownOptions(context, _dropdownButtonKey);
                  },
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Terpopuler",
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
              ),

              if (filteredThreads == null)
                const Center(child: CircularProgressIndicator())
              else if (filteredThreads.isEmpty)
                _EmptyStateWidget(isMyPosts: isMyPosts)
              else
                ...filteredThreads.map(
                  (thread) => ForumCard(
                    thread: thread,
                    // showMenu: isMyPosts,
                    showMenu: thread.userId == currentUserId,
                    showReport: !isMyPosts && !(thread.userId == currentUserId),
                    currentUserId: currentUserId,
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
      // title: 'Belum Ada Thread',
      subtitle: 'Tambahkan postingan Anda agar dapat berinteraksi dan menyampaikan pendapat Anda.',
      buttonText: 'Tambah Thread',
      onPressed:
          isMyPosts
              ? () => pushWithSlideTransition(context, const CreatePostScreen())
              : null, // Jika isMyPosts false, set onPressed ke null
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
  final int? currentUserId;

  const ForumCard({
    super.key,
    required this.thread,
    this.showMenu = false,
    this.showReport = false,
    this.currentUserId,
  });

  @override
  State<ForumCard> createState() => ForumCardState();
}

class ForumCardState extends State<ForumCard> {
  late bool isLiked;
  late int likeCount;
  // final GlobalKey _menuKey = GlobalKey();
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

  void hideMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    VoidCallback? longPressAction;

    // Logika untuk menentukan aksi longPress
    if (widget.showMenu) {
      // Jika postingan ini milik user yang login
      longPressAction = () {
        showThreadPreviewAndMenu(
          // Panggil dialog menu Edit/Delete
          context: context,
          thread: widget.thread,
          threadId: widget.thread.id.toString(), // Pastikan String
          showMenu: widget.showMenu, // True untuk mengaktifkan opsi Edit/Delete di dialog
          showReport: widget.showReport, // False untuk Report di dialog
          currentUserId: widget.currentUserId ?? 0,
        );
      };
    } else if (widget.showReport) {
      // Jika postingan ini milik orang lain (dan bisa direport)
      longPressAction = () {
        showReportDialog(
          // Panggil dialog Report
          context: context,
          category: "thread",
          refersId: int.parse(widget.thread.id.toString()),
        );
      };
    }

    return GestureDetector(
      onTap: () => pushWithSlideTransition(context, PostScreen(threadId: widget.thread.id)),
      onLongPress: longPressAction,
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
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
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
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      // child: ReportButton(category: "thread", refersId: widget.thread.id),
                      child: GestureDetector(
                        onTap:
                            () => showThreadPreviewAndMenu(
                              context: context,
                              thread: widget.thread,
                              threadId: widget.thread.id.toString(),
                              showMenu: widget.showMenu,
                              showReport: widget.showReport,
                              currentUserId: widget.currentUserId ?? 0,
                            ),
                        child: Icon(AppIcons.menu, size: 20),
                      ),
                    ),
                  if (widget.showReport)
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      // child: ReportButton(category: "thread", refersId: widget.thread.id),
                      child: GestureDetector(
                        onTap:
                            () => showReportDialog(
                              context: context,
                              category: "thread",
                              refersId: widget.thread.id,
                            ),
                        child: Icon(AppIcons.report, size: 20),
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
