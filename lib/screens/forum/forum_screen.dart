// // Nama File: forum.dart
// // Deskripsi: File ini adalah halaman forum yang digunakan untuk menampilkan forum diskusi pengguna aplikasi Nutrimpasi.
// // Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// // Tanggal: 12 Mei 2025

import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart';
import 'package:nutrimpasi/screens/forum/create_post_screen.dart';
import 'package:nutrimpasi/screens/forum/post_screen.dart';
import 'package:nutrimpasi/utils/navigation_animation.dart' show pushWithSlideTransition;
import 'package:nutrimpasi/widgets/forum_app_bar.dart' show AppBarForum;
import 'package:nutrimpasi/widgets/forum_report_button.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBarForum(screenTitle: "Forum Diskusi", showTabs: true),
        body: Container(
          decoration: BoxDecoration(color: AppColors.primary),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40)),
            ),
            child: const TabBarView(children: [ForumTabAll(), ForumTabMyPosts()]),
          ),
        ),
      ),
    );
  }
}

// ==============================
// WIDGET: Tab Semua Postingan
// ==============================
class ForumTabAll extends StatelessWidget {
  const ForumTabAll({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: const [
            ForumCard(
              isLiked: false,
              username: "Mama Karina (Saya)",
              postedAt: "2 jam yang lalu",
              title: "Gizi Seimbang",
              content:
                  "Gizi seimbang adalah pola makan yang mengandung semua zat gizi sesuai kebutuhan tubuh. Ini mencakup karbohidrat, protein, lemak, vitamin, dan mineral dalam jumlah yang tepat. Penerapan gizi seimbang penting untuk menjaga kesehatan dan mencegah penyakit.",
            ),
            ForumCard(
              showReport: true,
              isLiked: false,
              username: "Mama Asa",
              postedAt: "10 jam yang lalu",
              title: "Resep Makanan Sehat",
              content:
                  "Pentingnya sarapan pagi tidak bisa diremehkan karena memberikan energi untuk memulai hari. Sarapan sehat bisa berupa roti gandum, telur rebus, dan buah segar. Dengan menu sederhana ini, kebutuhan gizi tetap terpenuhi tanpa harus repot.",
            ),
            ForumCard(
              isLiked: false,
              username: "Mama Rora",
              postedAt: "18 Mei 2025",
              title: "Gizi Seimbang",
              content:
                  "Gizi seimbang adalah pola makan yang mengandung semua zat gizi sesuai kebutuhan tubuh. Ini mencakup karbohidrat, protein, lemak, vitamin, dan mineral dalam jumlah yang tepat. Penerapan gizi seimbang penting untuk menjaga kesehatan dan mencegah penyakit.",
            ),
            ForumCard(
              isLiked: false,
              username: "Mama Yaxian",
              postedAt: "10 Mei 2025",
              title: "Gizi Seimbang",
              content:
                  "Gizi seimbang adalah pola makan yang mengandung semua zat gizi sesuai kebutuhan tubuh. Ini mencakup karbohidrat, protein, lemak, vitamin, dan mineral dalam jumlah yang tepat. Penerapan gizi seimbang penting untuk menjaga kesehatan dan mencegah penyakit.",
            ),
          ],
        ),
      ),
    );
  }
}

// ==============================
// WIDGET: Tab Postingan Saya
// ==============================
class ForumTabMyPosts extends StatelessWidget {
  const ForumTabMyPosts({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          child: Column(
            children: const [
              ForumCard(
                showMenu: true,
                isLiked: false,
                likeCount: "14",
                username: "Mama Karina (Saya)",
                postedAt: "2 jam yang lalu",
                title: "Resep Makanan Sehat Anak Saya",
                content:
                    "Pentingnya sarapan pagi tidak bisa diremehkan karena memberikan energi untuk memulai hari. Sarapan sehat bisa berupa roti gandum, telur rebus, dan buah segar. Dengan menu sederhana ini, kebutuhan gizi tetap terpenuhi tanpa harus repot.",
              ),
              ForumCard(
                showMenu: true,
                isLiked: false,
                username: "Mama Karina (Saya)",
                postedAt: "10 jam yang lalu",
                title: "Anak saya susah makan sayur",
                content:
                    "Anak saya susah sekali makan sayur sejak usia 2 tahun. Saya sudah mencoba berbagai cara, mulai dari menyelipkan sayur dalam makanan favoritnya hingga membuat tampilan makanan lebih menarik. Apakah ada tips lain agar anak mau makan sayur tanpa harus dipaksa?",
              ),
              ForumCard(
                showMenu: true,
                isLiked: false,
                username: "Mama Karina (Saya)",
                postedAt: "18 Mei 2025",
                title: "Anak saya susah makan sayur",
                content:
                    "Anak saya susah sekali makan sayur sejak usia 2 tahun. Saya sudah mencoba berbagai cara, mulai dari menyelipkan sayur dalam makanan favoritnya hingga membuat tampilan makanan lebih menarik. Apakah ada tips lain agar anak mau makan sayur tanpa harus dipaksa?",
              ),
              ForumCard(
                showMenu: true,
                isLiked: false,
                username: "Mama Karina (Saya)",
                postedAt: "10 Mei 2025",
                title: "Anak saya susah makan sayur",
                content:
                    "Anak saya susah sekali makan sayur sejak usia 2 tahun. Saya sudah mencoba berbagai cara, mulai dari menyelipkan sayur dalam makanan favoritnya hingga membuat tampilan makanan lebih menarik. Apakah ada tips lain agar anak mau makan sayur tanpa harus dipaksa?",
              ),
              ForumCard(
                showMenu: true,
                isLiked: false,
                username: "Mama Karina (Saya)",
                postedAt: "8 Mei 2025",
                title: "Anak saya susah makan sayur",
                content:
                    "Anak saya susah sekali makan sayur sejak usia 2 tahun. Saya sudah mencoba berbagai cara, mulai dari menyelipkan sayur dalam makanan favoritnya hingga membuat tampilan makanan lebih menarik. Apakah ada tips lain agar anak mau makan sayur tanpa harus dipaksa?",
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 48,
          right: 16,
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            onPressed: () {
              pushWithSlideTransition(context, const CreatePostScreen());
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

// ==============================
// WIDGET: ForumCard
// ==============================
class ForumCard extends StatefulWidget {
  final String username;
  final String postedAt;
  final String title;
  final String content;
  final bool isLiked;
  final bool showMenu;
  final bool showReport;
  final String likeCount;
  final String commentCount;

  const ForumCard({
    super.key,
    required this.username,
    required this.postedAt,
    required this.title,
    required this.content,
    required this.isLiked,
    this.showMenu = false,
    this.showReport = false,
    this.likeCount = "4",
    this.commentCount = "2",
  });

  @override
  State<ForumCard> createState() => _ForumCardState();
}

class _ForumCardState extends State<ForumCard> {
  late bool isLiked;
  final GlobalKey _menuKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;
  }

  void _toggleLike() => setState(() => isLiked = !isLiked);

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
                          leading: Icon(AppIcons.edit, size: 20, color: AppColors.accent),
                          title: Text(
                            "Edit Postingan",
                            style: TextStyle(fontSize: 16, color: AppColors.accent),
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
                            leading: Icon(AppIcons.delete, size: 20, color: AppColors.error),
                            title: Text(
                              "Hapus Postingan",
                              style: TextStyle(fontSize: 16, color: AppColors.error),
                            ),
                            onTap: () async {
                              _hideMenu(); // Sembunyikan menu terlebih dahulu
                              bool? confirm = await showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: Text("Konfirmasi Hapus"),
                                      content: Text(
                                        "Apakah Anda yakin ingin menghapus postingan ini?",
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text("Batal"),
                                          onPressed: () => Navigator.pop(context, false),
                                        ),
                                        TextButton(
                                          child: Text("Hapus", style: TextStyle(color: Colors.red)),
                                          onPressed: () => Navigator.pop(context, true),
                                        ),
                                      ],
                                    ),
                              );

                              if (confirm == true) {
                                // _deletePost(); // Fungsi untuk hapus postingan
                              }
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
    );

    Overlay.of(context)!.insert(_overlayEntry!);
  }

  void _hideMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => pushWithSlideTransition(context, const PostScreen()),
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
                                color: AppColors.primaryTransparent, // abu-abu muda
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                AppIcons.userFill,
                                color: AppColors.primary,
                                size: 20, // opsional, atur agar pas di lingkaran
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              widget.username,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Text(widget.postedAt, style: TextStyle(color: AppColors.greyDark)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Title
                  Text(
                    widget.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  // Content
                  Text(
                    widget.content,
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
                              isLiked ? AppIcons.favoriteFill : AppIcons.favorite,
                              color: Colors.red,
                              size: 24,
                            ),
                            onPressed: _toggleLike,
                          ),
                          Text(widget.likeCount, style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                      SizedBox(width: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(AppIcons.comment, size: 24, color: AppColors.textBlack),
                          const SizedBox(width: 8),
                          Text(widget.commentCount, style: const TextStyle(fontSize: 18)),
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
                if (widget.showReport) ReportButton(content: "postingan"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:nutrimpasi/constants/colors.dart';
// import 'package:nutrimpasi/constants/icons.dart';
// import 'package:nutrimpasi/screens/forum/create_post_screen.dart';
// import 'package:nutrimpasi/screens/forum/post_screen.dart';

// // Fungsi untuk menavigasi ke halaman lain
// import 'package:nutrimpasi/utils/navigation_animation.dart' show pushWithSlideTransition;

// // Widget untuk menampilkan tombol report
// import 'package:nutrimpasi/widgets/forum_report_button.dart' show ButtonWithReport;
// import 'package:nutrimpasi/widgets/slidable_card.dart';

// // // Widget untuk menampilkan app bar forum diskusi
// import '../../widgets/forum_app_bar.dart' show AppBarForum;

// class ForumScreen extends StatefulWidget {
//   const ForumScreen({super.key});

//   @override
//   State<ForumScreen> createState() => _ForumScreenState();
// }

// class _ForumScreenState extends State<ForumScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         backgroundColor: AppColors.background,
//         appBar: AppBarForum(screenTitle: "Forum Diskusi", showTabs: true),
//         body: Container(
//           decoration: BoxDecoration(color: AppColors.primary),
//           child: Container(
//             decoration: BoxDecoration(
//               color: AppColors.background,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(40), // hanya lengkung kanan bawah
//               ),
//             ),
//             child: TabBarView(
//               children: [
//                 // Tab "Semua"
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
//                       child: Column(
//                         children: [
//                           _ForumCard(
//                             isLiked: false,
//                             username: "Mama Karina (Saya)",
//                             postedAt: "2 jam yang lalu",
//                             title: "Gizi Seimbang",
//                             content:
//                                 "Gizi seimbang adalah susunan makanan sehari-hari yang mengandung zat-zat gizi dalam jenis dan jumlah yang sesuai dengan kebutuhan tubuh, dengan memperhatikan prinsip keanekaragaman pangan, aktivitas fisik, perilaku hidup bersih, serta mempertahankan berat badan ideal.",
//                           ),
//                           _ForumCard(
//                             isLiked: false,
//                             username: "Mama Asa",
//                             postedAt: "10 jam yang lalu",
//                             title: "Resep Makanan Sehat",
//                             content:
//                                 "Pentingnya sarapan pagi. Sarapan pagi adalah waktu makan yang paling penting dalam sehari. Sarapan pagi yang baik dapat memberikan energi dan nutrisi yang dibutuhkan tubuh untuk memulai aktivitas sehari-hari.",
//                           ),
//                           _ForumCard(
//                             isLiked: false,
//                             username: "Mama Rora",
//                             postedAt: "18 Mei 2025",
//                             title: "Gizi Seimbang",
//                             content:
//                                 "Gizi seimbang adalah susunan makanan sehari-hari yang mengandung zat-zat gizi dalam jenis dan jumlah yang sesuai dengan kebutuhan tubuh, dengan memperhatikan prinsip keanekaragaman pangan, aktivitas fisik, perilaku hidup bersih, serta mempertahankan berat badan ideal.",
//                           ),
//                           _ForumCard(
//                             isLiked: false,
//                             username: "Mama Yaxian",
//                             postedAt: "10 Mei 2025",
//                             title: "Gizi Seimbang",
//                             content:
//                                 "Gizi seimbang adalah susunan makanan sehari-hari yang mengandung zat-zat gizi dalam jenis dan jumlah yang sesuai dengan kebutuhan tubuh, dengan memperhatikan prinsip keanekaragaman pangan, aktivitas fisik, perilaku hidup bersih, serta mempertahankan berat badan ideal.",
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Tab "Postingan Saya"
//                 Stack(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
//                       child: SizedBox(
//                         height: MediaQuery.of(context).size.height,
//                         child: SingleChildScrollView(
//                           child: Padding(
//                             padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
//                             child: Column(
//                               children: [
//                                 _ForumCard(
//                                   showMenu: true,
//                                   isLiked: false,
//                                   username: "Mama Karina (Saya)",
//                                   postedAt: "2 jam yang lalu",
//                                   title: "Resep Makanan Sehat Anak Saya",
//                                   content:
//                                       "Resep makanan sehat untuk anak saya yang picky eater. Makanan sehat yang enak dan bergizi. Makanan sehat untuk anak yang susah makan.",
//                                 ),
//                                 _ForumCard(
//                                   showMenu: true,
//                                   isLiked: false,
//                                   username: "Mama Karina (Saya)",
//                                   postedAt: "10 jam yang lalu",
//                                   title: "Anak saya susah makan sayur",
//                                   content:
//                                       "Pengalaman diet seimbang. Saya sudah mencoba berbagai cara untuk membuat anak saya mau makan sayur, tetapi tidak berhasil. Apakah ada yang punya tips?",
//                                 ),
//                                 _ForumCard(
//                                   showMenu: true,
//                                   isLiked: false,
//                                   username: "Mama Karina (Saya)",
//                                   postedAt: "18 Mei 2025",
//                                   title: "Anak saya susah makan sayur",
//                                   content:
//                                       "Pengalaman diet seimbang. Saya sudah mencoba berbagai cara untuk membuat anak saya mau makan sayur, tetapi tidak berhasil. Apakah ada yang punya tips?",
//                                 ),
//                                 _ForumCard(
//                                   showMenu: true,
//                                   isLiked: false,
//                                   username: "Mama Karina (Saya)",
//                                   postedAt: "10 Mei 2025",
//                                   title: "Anak saya susah makan sayur",
//                                   content:
//                                       "Pengalaman diet seimbang. Saya sudah mencoba berbagai cara untuk membuat anak saya mau makan sayur, tetapi tidak berhasil. Apakah ada yang punya tips?",
//                                 ),
//                                 _ForumCard(
//                                   showMenu: true,
//                                   isLiked: false,
//                                   username: "Mama Karina (Saya)",
//                                   postedAt: "10 Mei 2025",
//                                   title: "Anak saya susah makan sayur",
//                                   content:
//                                       "Pengalaman diet seimbang. Saya sudah mencoba berbagai cara untuk membuat anak saya mau makan sayur, tetapi tidak berhasil. Apakah ada yang punya tips?",
//                                 ),
//                                 _ForumCard(
//                                   showMenu: true,
//                                   isLiked: false,
//                                   username: "Mama Karina (Saya)",
//                                   postedAt: "8 Mei 2025",
//                                   title: "Anak saya susah makan sayur",
//                                   content:
//                                       "Pengalaman diet seimbang. Saya sudah mencoba berbagai cara untuk membuat anak saya mau makan sayur, tetapi tidak berhasil. Apakah ada yang punya tips?",
//                                 ),
//                                 // Jarak antara card terakhir dan tombol tambah
//                                 SizedBox(height: 100),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 48,
//                       right: 16,
//                       child: SizedBox(
//                         width: 50,
//                         height: 50,
//                         child: FloatingActionButton(
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//                           onPressed: () {
//                             pushWithSlideTransition(context, CreatePostScreen());
//                           },
//                           child: const Icon(Icons.add),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Widget untuk menampilkan card forum
// class _ForumCard extends StatefulWidget {
//   final String username;
//   final String postedAt;
//   final String title;
//   final String content;
//   final bool isLiked;
//   final bool showMenu;

//   _ForumCard({
//     required this.username,
//     required this.postedAt,
//     required this.title,
//     required this.content,
//     required this.isLiked,
//     this.showMenu = false,
//     super.key,
//   });

//   @override
//   _ForumCardState createState() => _ForumCardState();
// }

// class _ForumCardState extends State<_ForumCard> {
//   late bool isLiked;
//   final GlobalKey _menuKey = GlobalKey();
//   OverlayEntry? _overlayEntry;

//   @override
//   void initState() {
//     super.initState();
//     isLiked = widget.isLiked; // ✅ sekarang aman
//   }

//   void toggleLike() {
//     setState(() {
//       isLiked = !isLiked;
//     });
//   }

//   void _showMenu() {
//     final RenderBox renderBox = _menuKey.currentContext!.findRenderObject() as RenderBox;
//     final size = renderBox.size;
//     final offset = renderBox.localToGlobal(Offset.zero);

//     _overlayEntry = OverlayEntry(
//       builder:
//           (context) => Stack(
//             children: [
//               // Latar belakang hitam transparan & mencegah klik di luar menu
//               GestureDetector(
//                 onTap: _hideMenu, // tap di luar = tutup menu
//                 behavior: HitTestBehavior.opaque,
//                 child: Container(
//                   color: Colors.black45, // warna transparan gelap
//                 ),
//               ),

//               // Menu pop-up
//               Positioned(
//                 left: offset.dx + size.width - 150,
//                 top: offset.dy + size.height,
//                 width: 150,
//                 child: Material(
//                   elevation: 4,
//                   borderRadius: BorderRadius.circular(4),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           // height: 4,
//                           width: double.infinity,
//                           margin: const EdgeInsets.symmetric(vertical: 8),
//                           child: Row(
//                             children: [
//                               Icon(AppIcons.edit, size: 20, color: AppColors.greyDark),
//                               SizedBox(width: 8),
//                               Text(
//                                 "Edit Postingan",
//                                 style: TextStyle(fontSize: 16, color: AppColors.greyDark),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//     );

//     Overlay.of(context)!.insert(_overlayEntry!);
//   }

//   void _hideMenu() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         pushWithSlideTransition(context, PostScreen());
//       },
//       child: Card(
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         elevation: 2,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           width: 32,
//                           height: 32,
//                           decoration: BoxDecoration(
//                             color: AppColors.primaryTransparent, // abu-abu muda
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             AppIcons.userFill,
//                             color: AppColors.primary,
//                             size: 20, // opsional, atur agar pas di lingkaran
//                           ),
//                         ),
//                         SizedBox(width: 8),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 widget.username,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 14,
//                                   color: AppColors.textBlack,
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               SizedBox(height: 4),
//                               Text(
//                                 widget.postedAt,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.normal,
//                                   fontSize: 12,
//                                   color: AppColors.textGrey,
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                               ),

//                               // SizedBox(height: 4),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   if (widget.showMenu)
//                     IconButton(
//                       key: _menuKey,
//                       onPressed: () {
//                         if (_overlayEntry == null) {
//                           _showMenu();
//                         } else {
//                           _hideMenu();
//                         }
//                       },
//                       icon: Icon(AppIcons.menu, size: 20, color: Colors.grey[800]),
//                     ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.title,
//                     style: const TextStyle(fontWeight: FontWeight.w600),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 1,
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     widget.content,
//                     textAlign: TextAlign.justify,
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 3,
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 // crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Row(
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           // Icon(AppIcons.like, size: 20, color: AppColors.error),
//                           GestureDetector(
//                             child: Icon(
//                               isLiked ? AppIcons.likeFill : AppIcons.like,
//                               color: isLiked ? AppColors.error : AppColors.greyDark,
//                               size: 20,
//                             ),
//                             onTap: () {
//                               setState(() {
//                                 isLiked = !isLiked;
//                               });
//                             },
//                           ),
//                           SizedBox(width: 4),
//                           Text("4", style: TextStyle(fontSize: 16)),
//                         ],
//                       ),
//                       SizedBox(width: 16),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Icon(AppIcons.comment, size: 20, color: AppColors.greyDark),
//                           SizedBox(width: 4),
//                           Text("2", style: TextStyle(fontSize: 16)),
//                         ],
//                       ),
//                     ],
//                   ),
//                   ButtonWithReport(content: "postingan"),
//                   // Icon(AppIcons.info, size: 20),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
