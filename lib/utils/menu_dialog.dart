// Nama File: dialog.dart
// Deskripsi: File ini adalah
// Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// Tanggal: 07 Juni 2025

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/blocs/comment/comment_bloc.dart'; // Impor CommentBloc, DeleteComment
import 'package:nutrimpasi/blocs/thread/thread_bloc.dart'
    show DeleteThreads, ThreadBloc;
import 'package:nutrimpasi/constants/colors.dart'; // Impor AppColors
import 'package:nutrimpasi/constants/icons.dart'; // Impor AppIcons
import 'package:nutrimpasi/models/comment.dart'; // Impor Comment (dan User)
import 'package:nutrimpasi/screens/forum/edit_thread_screen.dart'
    show EditThreadScreen;
import 'package:nutrimpasi/screens/forum/forum_screen.dart' show ForumCard;
import 'package:nutrimpasi/screens/forum/thread_screen.dart'
    show CommentSection;
import 'package:nutrimpasi/widgets/custom_dialog.dart'; // Sesuaikan path jika berbeda

// --- FUNGSI HELPER UNTUK KONFIRMASI HAPUS THREAD ---
Future<void> confirmDeleteThread({
  required BuildContext context, // Context dari tempat fungsi ini dipanggil
  required String threadId, // threadId harus int, sesuai ThreadScreen
  required bool isFromDetailPage,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder:
        (ctx) => AlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content: const Text(
            "Apakah Anda yakin ingin menghapus postingan ini?",
          ),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.pop(ctx, false),
            ),
            TextButton(
              child: const Text("Hapus", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pop(ctx, true);
                if (isFromDetailPage) {
                  Navigator.pop(ctx, true);
                }
              },
            ),
          ],
        ),
  );

  if (confirmed == true) {
    if (context.mounted) {
      // context.read<ThreadBloc>().add(DeleteThreads(threadId: threadId));
      context.read<ThreadBloc>().add(
        DeleteThreads(threadId: int.parse(threadId)),
      );
    }
  }
}

// >>> FUNGSI UNTUK MENAMPILKAN DIALOG PREVIEW DAN OPSI <<<
void showThreadPreviewAndMenu({
  required BuildContext context, // Context dari tempat fungsi ini dipanggil
  required dynamic thread,
  required String threadId, // threadId harus int
  required bool showMenu,
  required bool showReport,
  required int currentUserId,
  required bool isFromDetailPage,
}) {
  showGeneralDialog(
    context: context,
    barrierColor: Colors.black87,
    barrierDismissible: true,
    barrierLabel: 'ForumCardOptions',
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
              // === Bagian ForumCard (Gaya Sama, Tapi Non-Interaktif) ===
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.92,
                child: IgnorePointer(
                  // Kunci utama: Ini membuat ForumCard tidak interaktif
                  ignoring: true, // Selalu mengabaikan semua event pointer
                  child: ForumCard(
                    // <<< Menggunakan instance ForumCard yang sama
                    key: ValueKey(
                      '${threadId}_dialog_preview',
                    ), // Beri key unik jika perlu
                    thread: thread,
                    showMenu:
                        showMenu, // Teruskan properti showMenu untuk tampilan
                    showReport:
                        showReport, // Teruskan properti showReport untuk tampilan
                    currentUserId: currentUserId, // Teruskan currentUserId
                  ),
                ),
              ),
              // === Bagian Opsi "Report", "Block Account" ===
              const SizedBox(height: 4), // Jarak antara card dan opsi
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * (1 / 2.3),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tombol Edit Thread
                      Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.warningHighTranparent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(dialogContext);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          EditThreadScreen(thread: thread),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    AppIcons.edit,
                                    size: 20,
                                    color: AppColors.amber,
                                  ),
                                  SizedBox(width: 16),
                                  Text(
                                    "Edit \nPostingan",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.amber,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),

                      // Tombol Hapus Thread
                      if (showMenu)
                        // const SizedBox(height: 8)
                        Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.errorHighTranparent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                confirmDeleteThread(
                                  context: context,
                                  threadId: threadId,
                                  isFromDetailPage: isFromDetailPage,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      AppIcons.deleteFill,
                                      size: 20,
                                      color: AppColors.error,
                                    ),
                                    SizedBox(width: 16),
                                    Text(
                                      "Hapus \nPostingan",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.error,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
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

// --- FUNGSI HELPER UNTUK KONFIRMASI HAPUS KOMENTAR ---
Future<void> confirmDeleteComment({
  required BuildContext context, // Context dari tempat fungsi ini dipanggil
  required int commentId,
  required String threadId, // threadId harus int, sesuai ThreadScreen
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder:
        (ctx) => ConfirmDialog(
          titleText: "Konfirmasi Hapus",
          contentText: "Apakah Anda yakin ingin menghapus komentar ini?",
          confirmButtonColor: AppColors.error,
          onConfirm: () {
            // onConfirm sekarang tidak menerima parameter
            Navigator.pop(ctx, true);
          },
          onCancel: () => Navigator.pop(ctx, false),
          isConfirming: false,
        ),
  );

  if (confirmed == true) {
    if (context.mounted) {
      context.read<CommentBloc>().add(DeleteComments(commentId: commentId));
    }
  }
}

// --- FUNGSI UTAMA UNTUK MENAMPILKAN DIALOG PREVIEW DAN OPSI KOMENTAR ---
void showCommentPreviewAndMenu({
  required BuildContext context, // Context dari tempat fungsi ini dipanggil
  required Comment comment,
  required String threadId, // threadId harus int
  required bool showMenu,
  required bool showReport,
  required int currentUserId,
  required Function(Comment)? onEdit,
}) {
  showGeneralDialog(
    context: context,
    barrierColor: Colors.black87,
    barrierDismissible: true,
    barrierLabel: 'Comment Options',
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return Align(
        alignment: Alignment.center,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // === Bagian Preview Komentar (Non-Interaktif) ===
                SizedBox(
                  width:
                      MediaQuery.of(context).size.width *
                      0.9, // Lebar sekitar 90%
                  child: IgnorePointer(
                    ignoring: true,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: EdgeInsets.zero,
                      elevation: 4,
                      child: CommentSection(
                        // Menggunakan CommentSection (tanpa underscore)
                        key: ValueKey('${comment.id}_dialog_preview'),
                        comment: comment,
                        showMenu: false, // Tidak perlu menu di preview
                        showReport: false, // Tidak perlu report di preview
                        currentUserId: currentUserId,
                        threadId: threadId,
                      ),
                    ),
                  ),
                ),
                // === Bagian Opsi "Report", "Block Account", dll. ===
                const SizedBox(height: 4),

                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * (1 / 2.5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showMenu)
                          // Tombol Edit Thread
                          Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.warningHighTranparent,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(dialogContext);
                                  if (onEdit != null) {
                                    onEdit(comment);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        AppIcons.edit,
                                        size: 20,
                                        color: AppColors.amber,
                                      ),
                                      SizedBox(width: 16),
                                      Text(
                                        "Edit \nKomentar",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.amber,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 2),
                        Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(4),
                          color: AppColors.white,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.errorHighTranparent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(dialogContext);
                                confirmDeleteComment(
                                  // Panggil fungsi modular
                                  context: context,
                                  commentId: comment.id,
                                  threadId: threadId,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      AppIcons.deleteFill,
                                      size: 20,
                                      color: AppColors.error,
                                    ),
                                    SizedBox(width: 16),
                                    Text(
                                      "Hapus \nKomentar",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.error,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
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
        ),
      );
    },
  );
}
