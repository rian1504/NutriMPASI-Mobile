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
import 'package:nutrimpasi/screens/forum/create_thread_screen.dart';
import 'package:nutrimpasi/screens/forum/thread_screen.dart';
import 'package:nutrimpasi/utils/flushbar.dart';
import 'package:nutrimpasi/utils/menu_dialog.dart';
import 'package:nutrimpasi/utils/navigation_animation.dart'
    show pushWithSlideTransition;
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
        appBar: AppBarForum(
          title: "Forum Diskusi",
          showTabs: true,
          category: '',
        ),
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
                    AppFlushbar.showSuccess(
                      context,
                      title: 'Berhasil',
                      message: 'Berhasil menghapus thread',
                    );

                    context.read<ThreadBloc>().add(FetchThreads());
                  } else if (state is ThreadError) {
                    AppFlushbar.showError(
                      context,
                      title: 'Error',
                      message: state.error,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ThreadLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
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
                      _ForumTab(
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
      ),
    );
  }
}

class _ForumTab extends StatefulWidget {
  final List<Thread>? threads;
  final bool isMyPosts;
  final int currentUserId;

  const _ForumTab({
    required this.threads,
    required this.isMyPosts,
    required this.currentUserId,
  });

  @override
  State<_ForumTab> createState() => _ForumTabState();
}

class _ForumTabState extends State<_ForumTab> {
  // Variabel state untuk opsi pengurutan di dalam tab ini
  String _sortOption = 'Terpopuler'; // Default untuk tab "Semua"
  final List<String> _sortOptions = ['Terpopuler', 'Terbaru', 'Terlama'];

  // Kunci global untuk mendapatkan posisi tombol filter
  final GlobalKey _dropdownButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Untuk tab "Usulan Saya", set default sort menjadi "Terbaru"
    if (widget.isMyPosts) {
      _sortOption = 'Terbaru';
    }
  }

  // Fungsi untuk mengurutkan thread berdasarkan opsi yang dipilih
  List<Thread> _sortThreads(List<Thread> items) {
    // Ambil daftar thread yang sudah difilter oleh widget.isMyPosts
    final List<Thread> filteredItems =
        items.where((thread) {
          return !widget.isMyPosts || thread.userId == widget.currentUserId;
        }).toList();

    // Untuk tab "Usulan Saya", selalu urutkan dari yang terbaru
    if (widget.isMyPosts) {
      return filteredItems..sort((a, b) {
        return b.createdAt.compareTo(a.createdAt); // Descending (Terbaru)
      });
    }

    // Untuk tab "Semua", urutkan berdasarkan pilihan pengguna (_sortOption)
    switch (_sortOption) {
      case 'Terpopuler':
        // Asumsi ada properti `likesCount` pada Thread model
        return filteredItems
          ..sort((a, b) => b.likesCount.compareTo(a.likesCount)); // Descending
      case 'Terbaru':
        return filteredItems..sort((a, b) {
          return b.createdAt.compareTo(a.createdAt); // Descending
        });
      case 'Terlama':
        return filteredItems..sort((a, b) {
          return a.createdAt.compareTo(b.createdAt); // Ascending
        });
      default:
        return filteredItems; // Should not happen if _sortOption is always valid
    }
  }

  void _showDropdownOptions(BuildContext context, GlobalKey dropdownButtonKey) {
    // Hanya tampilkan dialog jika ini bukan tab "Usulan Saya"
    if (widget.isMyPosts) return;

    // Mendapatkan RenderBox dari GlobalKey untuk mendapatkan posisi tombol
    final RenderBox renderBox =
        dropdownButtonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(
      Offset.zero,
    ); // Posisi global tombol

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
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
                alignment: Alignment.topCenter,
                child: Material(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  elevation: 8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:
                        _sortOptions.map((option) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _sortOption = option;
                              });

                              Navigator.of(dialogContext).pop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 16.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    option,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          _sortOption == option
                                              ? AppColors.primary
                                              : AppColors
                                                  .black, // Warna teks berdasarkan pilihan
                                    ),
                                  ),
                                  if (_sortOption ==
                                      option) // Tampilkan ikon cek
                                    const Icon(
                                      Icons.check,
                                      size: 20,
                                      color: AppColors.primary,
                                    ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var filteredThreads =
        widget.threads?.where((thread) {
          return !widget.isMyPosts || thread.userId == widget.currentUserId;
        }).toList();

    // Terapkan sorting
    filteredThreads =
        filteredThreads != null ? _sortThreads(filteredThreads) : null;

    return Stack(
      children: [
        SingleChildScrollView(
          // padding: const EdgeInsets.fromLTRB(18, 0, 18, 100),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!widget.isMyPosts)
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _sortOption,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                            Icon(
                              AppIcons.arrowDown,
                              size: 20,
                              color: AppColors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              if (filteredThreads == null)
                const Center(child: CircularProgressIndicator())
              else if (filteredThreads.isEmpty)
                _EmptyStateWidget(isMyPosts: widget.isMyPosts)
              else
                ...filteredThreads.map(
                  (thread) => ForumCard(
                    thread: thread,
                    // showMenu: isMyPosts,
                    showMenu: thread.userId == widget.currentUserId,
                    showReport:
                        !widget.isMyPosts &&
                        !(thread.userId == widget.currentUserId),
                    currentUserId: widget.currentUserId,
                  ),
                ),
            ],
          ),
        ),
        if (widget.isMyPosts)
          Positioned(
            bottom: 40,
            right: 16,
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              onPressed:
                  () => pushWithSlideTransition(
                    context,
                    const CreateThreadScreen(),
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
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: EmptyMessage(
        iconName: AppIcons.forum,
        title: isMyPosts ? 'Anda belum membuat thread' : 'Belum ada thread',
        // title: 'Belum Ada Thread',
        subtitle:
            'Tambahkan thread atau postingan Anda agar dapat berinteraksi dan menyampaikan pendapat Anda.',
        buttonText: 'Tambah Thread',
        onPressed:
            isMyPosts
                ? () =>
                    pushWithSlideTransition(context, const CreateThreadScreen())
                : null, // Jika isMyPosts false, set onPressed ke null
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
  }

  void _toggleLike() {
    context.read<ThreadBloc>().add(ToggleLike(threadId: widget.thread.id));
  }

  void hideMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final bool currentIsLiked = widget.thread.isLike;
    final int currentLikeCount = widget.thread.likesCount;
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
          showMenu:
              widget
                  .showMenu, // True untuk mengaktifkan opsi Edit/Delete di dialog
          showReport: widget.showReport, // False untuk Report di dialog
          currentUserId: widget.currentUserId ?? 0,
          isFromDetailPage: false,
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
      onTap:
          () => pushWithSlideTransition(
            context,
            ThreadScreen(threadId: widget.thread.id, screenCategory: 'forum'),
          ),
      onLongPress: longPressAction,
      child: Card(
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
                        style: TextStyle(
                          color: AppColors.greyDark,
                          fontSize: 12,
                        ),
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
                                    MainAxisSize
                                        .min, // Agar Row hanya mengambil ruang minimal
                                children: [
                                  Icon(
                                    currentIsLiked
                                        ? AppIcons.favoriteFill
                                        : AppIcons.favorite, // Ikon berubah
                                    color:
                                        currentIsLiked
                                            ? Colors.red
                                            : AppColors
                                                .black, // Warna ikon berubah jika liked
                                    size: 24,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ), // Jarak antara ikon dan teks
                                  Text(
                                    currentLikeCount.toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color:
                                          currentIsLiked
                                              ? Colors.red
                                              : AppColors
                                                  .black, // Warna teks juga berubah
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
                                MainAxisSize
                                    .min, // Penting agar Row tidak memakan ruang lebih
                            children: [
                              Icon(
                                AppIcons.comment,
                                size: 24,
                                color: AppColors.black,
                              ),
                              const SizedBox(
                                width: 4,
                              ), // Sedikit jarak antara ikon dan teks
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
                                ThreadScreen(
                                  threadId: widget.thread.id,
                                  screenCategory: 'forum',
                                ),
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
                              isFromDetailPage: false,
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
