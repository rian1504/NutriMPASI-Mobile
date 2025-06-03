
//   import 'package:flutter/material.dart';

// void _showForumCardPreviewAndOptionsDialog(BuildContext context) {
//     showGeneralDialog(
//       context: context,
//       barrierColor: Colors.black87,
//       barrierDismissible: true,
//       barrierLabel: '_ForumCardOptions',
//       transitionDuration: const Duration(milliseconds: 300),
//       pageBuilder: (dialogContext, animation, secondaryAnimation) {
//         return Align(
//           alignment: Alignment.center,
//           child: Material(
//             color: Colors.transparent, // Untuk transparansi latar belakang
//             child: Column(
//               // Menggunakan Column untuk menumpuk card dan opsi
//               mainAxisSize: MainAxisSize.min, // Agar Column sekecil mungkin
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 // === Bagian _ForumCard (Gaya Sama, Tapi Non-Interaktif) ===
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.92,
//                   child: IgnorePointer(
//                     // Kunci utama: Ini membuat _ForumCard tidak interaktif
//                     ignoring: true, // Selalu mengabaikan semua event pointer
//                     child: _ForumCard(
//                       // <<< Menggunakan instance _ForumCard yang sama
//                       key: ValueKey(
//                         '${widget.thread.id}_dialog_preview',
//                       ), // Beri key unik jika perlu
//                       thread: widget.thread,
//                       showMenu: widget.showMenu, // Teruskan properti showMenu untuk tampilan
//                       showReport: widget.showReport, // Teruskan properti showReport untuk tampilan
//                       currentUserId: widget.currentUserId, // Teruskan currentUserId
//                     ),
//                   ),
//                 ),
//                 // === Bagian Opsi "Report", "Block Account" ===
//                 const SizedBox(height: 8), // Jarak antara card dan opsi
//                 Padding(
//                   padding: const EdgeInsets.only(right: 4.0),
//                   child: SizedBox(
//                     width: MediaQuery.of(context).size.width * (1 / 2.5),

//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         // Tombol Edit Postingan
//                         Material(
//                           elevation: 4,
//                           borderRadius: BorderRadius.circular(4),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: AppColors.accentHighTransparent,
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             child: ListTile(
//                               leading: Icon(AppIcons.edit, size: 20, color: AppColors.accent),
//                               title: Text(
//                                 "Edit Postingan",
//                                 style: TextStyle(fontSize: 16, color: AppColors.accent),
//                               ),
//                               onTap: () {
//                                 _hideMenu();
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => EditPostScreen(thread: widget.thread),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 4),

//                         // Tombol Hapus Postingan
//                         if (widget.showMenu)
//                           // const SizedBox(height: 8)
//                           Material(
//                             elevation: 4,
//                             borderRadius: BorderRadius.circular(4),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: AppColors.errorHighTranparent,
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                               child: ListTile(
//                                 leading: Icon(
//                                   AppIcons.deleteFill,
//                                   size: 20,
//                                   color: AppColors.error,
//                                 ),
//                                 title: Text(
//                                   "Hapus Postingan",
//                                   style: TextStyle(fontSize: 16, color: AppColors.error),
//                                 ),
//                                 onTap: _confirmDelete,
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         return ScaleTransition(
//           scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
//           child: child,
//         );
//       },
//     );
//   }







