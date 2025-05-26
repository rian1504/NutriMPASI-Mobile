// Nama File: create_post_screen.dart
// Deskripsi: File ini adalah halaman untuk membuat postingan baru di forum.
// Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// Tanggal: 18 Mei 2025

import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/widgets/button.dart';
import 'package:nutrimpasi/widgets/forum_app_bar.dart' show AppBarForum;

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

// class _CreatePostScreenState extends State<CreatePostScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBarForum(screenTitle: "Buat Postingan", showExitButton: true),
//       body: Container(
//         decoration: BoxDecoration(color: AppColors.primary),
//         child: Container(
//           decoration: BoxDecoration(
//             color: AppColors.background,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(40), // hanya lengkung kanan bawah
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
//             child: Center(
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   // Pembungkus Card
//                   Container(
//                     padding: const EdgeInsets.only(bottom: 32), // beri ruang untuk tombol
//                     constraints: BoxConstraints(
//                       minHeight: 400, // tinggi minimum pembungkus
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.transparent, // transparan agar tidak ganggu desain
//                     ),
//                     child: Card(
//                       child: SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//                               child: TextFormField(
//                                 maxLines: 1,
//                                 decoration: InputDecoration(
//                                   hintText: 'Judul Postingan',
//                                   border: InputBorder.none,
//                                 ),
//                               ),
//                             ),
//                             // Text('Judul Postingan'),
//                             Divider(color: AppColors.greyLight),
//                             Padding(
//                               padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
//                               child: TextFormField(
//                                 maxLines: 30,
//                                 decoration: InputDecoration(
//                                   hintText: 'Tanyakan sesuatu atau bagikan pengalamanmu di sini...',
//                                   border: InputBorder.none,
//                                 ),
//                               ),
//                             ),
//                             // Text('Tanyakan sesuatu atau bagikan pengalamanmu di sini...'),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   // Tombol Unggah di atas form
//                   Positioned(
//                     bottom: 12, // posisikan relatif terhadap container card
//                     child: MediumButton(
//                       text: "Unggah",
//                       onPressed: () {
//                         // aksi unggah
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarForum(title: "Buat Postingan", showExitButton: true),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Lapisan utama konten
          Container(
            decoration: BoxDecoration(color: AppColors.primary),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 60), // beri ruang bawah untuk tombol
                child: Center(
                  child: Card(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: 'Judul Postingan',
                              border: InputBorder.none,
                            ),
                          ),
                          Divider(color: AppColors.greyLight),
                          TextFormField(
                            maxLines: 30,
                            decoration: InputDecoration(
                              hintText: 'Tanyakan sesuatu atau bagikan pengalamanmu di sini...',
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Tombol tetap di bawah
          Positioned(
            bottom: 40,
            // left: 0,
            // right: 0,
            child: MediumButton(
              text: "Unggah",
              onPressed: () {
                // aksi unggah
              },
            ),
          ),
        ],
      ),
    );
  }
}
