import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/blocs/authentication/authentication_bloc.dart';
import 'package:nutrimpasi/blocs/like/like_bloc.dart';
import 'package:nutrimpasi/blocs/thread/thread_bloc.dart' as thread_bloc;
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/like.dart';
import 'package:nutrimpasi/models/thread.dart' as thread_model;
import 'package:nutrimpasi/screens/forum/thread_screen.dart';
import 'package:nutrimpasi/utils/flushbar.dart';
import 'package:nutrimpasi/utils/menu_dialog.dart';
import 'package:nutrimpasi/utils/navigation_animation.dart';
import 'package:nutrimpasi/utils/report_dialog.dart';
import 'package:nutrimpasi/widgets/custom_message_dialog.dart';
import 'package:timeago/timeago.dart' as timeago;

class FavoriteThreadScreen extends StatefulWidget {
  const FavoriteThreadScreen({super.key});

  @override
  State<FavoriteThreadScreen> createState() => _FavoriteThreadScreenState();
}

class _FavoriteThreadScreenState extends State<FavoriteThreadScreen> {
  List<Like> likes = [];

  @override
  void initState() {
    super.initState();
    context.read<LikeBloc>().add(FetchLikes());
  }

  @override
  Widget build(BuildContext context) {
    // Dapatkan data user dari authentication bloc
    final authState = context.watch<AuthenticationBloc>().state;
    final loggedInUser = authState is LoginSuccess ? authState.user : null;

    return BlocListener<thread_bloc.ThreadBloc, thread_bloc.ThreadState>(
      listener: (context, state) {
        if (state is thread_bloc.ThreadDeleted) {
          AppFlushbar.showSuccess(
            context,
            title: 'Berhasil',
            message: 'Berhasil menghapus postingan',
          );

          context.read<LikeBloc>().add(FetchLikes());
        } else if (state is thread_bloc.ThreadError) {
          AppFlushbar.showError(context, title: 'Error', message: state.error);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 5,
              shadowColor: Colors.black54,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textBlack,
                    size: 24,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
          title: const Text(
            'Postingan yang Disukai',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Lingkaran besar di belakang
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(50),
                              offset: const Offset(0, 8),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Lataran bawah dengan warna primer
                  Container(
                    width: double.infinity,
                    height: 125,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          offset: const Offset(0, 4),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),

                  // Lingkaran besar di depan (warna primer)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),

                  // Icon forum/like di tengah lingkaran
                  Positioned(
                    top: 25,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(25),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          AppIcons.likeFill,
                          size: 80,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 100),

              // Daftar thread yang disukai
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BlocBuilder<LikeBloc, LikeState>(
                  builder: (context, state) {
                    if (state is LikeLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    if (state is LikeLoaded) {
                      likes = state.likes;
                    }

                    if (likes.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: EmptyMessage(
                          title: 'Anda belum menyukai postingan',
                          subtitle:
                              'Belum ada postingan yang Anda sukai. Temukan berbagai diskusi menarik di forum dan tekan tombol suka pada postingan favorit Anda agar mudah ditemukan kembali di halaman ini.',
                          iconName: AppIcons.forum,
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(4),
                      itemCount: likes.length,
                      itemBuilder: (context, index) {
                        final thread = likes[index].thread;
                        final userId = loggedInUser!.id;
                        final checkUser = thread.userId == userId;
                        return ForumCard(
                          thread: thread,
                          showMenu: checkUser,
                          showReport: !checkUser,
                          currentUserId: userId,
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
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

  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
  }

  void _toggleLike() {
    context.read<LikeBloc>().add(ToggleLike(threadId: widget.thread.id));
  }

  void hideMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showMenuDialog() {
    // Konversi inline ke Map/JSON sebagai perantara
    final convertedThread = thread_model.Thread(
      id: widget.thread.id,
      userId: widget.thread.userId,
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
      currentUserId: widget.currentUserId ?? 0,
      isFromDetailPage: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final int currentLikeCount = widget.thread.likesCount;
    VoidCallback? longPressAction;

    // // Logika untuk menentukan aksi longPress
    if (widget.showMenu) {
      // Jika postingan ini milik user yang login
      longPressAction = _showMenuDialog;
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
            ThreadScreen(threadId: widget.thread.id, screenCategory: 'like'),
          ),
      onLongPress: longPressAction,
      // widget.showMenu || widget.showReport ? _showMenuDialog : null,
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
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    AppIcons.favoriteFill,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    currentLikeCount.toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.red,
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
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                AppIcons.comment,
                                size: 24,
                                color: AppColors.black,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.thread.commentsCount.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                          onPressed:
                              () => pushWithSlideTransition(
                                context,
                                ThreadScreen(
                                  threadId: widget.thread.id,
                                  screenCategory: 'like',
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.showMenu)
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: GestureDetector(
                        onTap: _showMenuDialog,
                        child: Icon(AppIcons.menu, size: 20),
                      ),
                    ),
                  if (widget.showReport)
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
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
