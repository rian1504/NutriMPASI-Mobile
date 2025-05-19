// Nama File: forum.dart
// Deskripsi: File ini adalah halaman forum yang digunakan untuk menampilkan forum diskusi pengguna aplikasi Nutrimpasi.
// Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// Tanggal: 12 Mei 2025

import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart' show AppIcons;
import 'package:nutrimpasi/screens/forum/post_screen.dart' show PostScreen;
import 'package:nutrimpasi/utils/navigation_animation.dart'
    show pushWithSlideTransition;
import 'package:nutrimpasi/widgets/forum_report_button.dart'
    show ButtonWithReport;

// // Widget untuk menampilkan app bar forum diskusi
import '../../widgets/forum_app_bar.dart' show AppBarForum;

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
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), // hanya lengkung kanan bawah
              ),
            ),
            child: TabBarView(
              children: [
                // Tab "Semua"
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ForumCard(
                          username: "Mama Karina (Saya)",
                          postedAt: "2 jam yang lalu",
                          title: "Gizi Seimbang",
                          content:
                              "Gizi seimbang adalah susunan makanan sehari-hari yang mengandung zat-zat gizi dalam jenis dan jumlah yang sesuai dengan kebutuhan tubuh, dengan memperhatikan prinsip keanekaragaman pangan, aktivitas fisik, perilaku hidup bersih, serta mempertahankan berat badan ideal.",
                        ),
                        ForumCard(
                          username: "Mama Asa",
                          postedAt: "10 jam yang lalu",
                          title: "Resep Makanan Sehat",
                          content: "Pentingnya sarapan pagi.",
                        ),
                        ForumCard(
                          username: "Mama Rora",
                          postedAt: "18 Mei 2025",
                          title: "Gizi Seimbang",
                          content:
                              "Gizi seimbang adalah susunan makanan sehari-hari yang mengandung zat-zat gizi dalam jenis dan jumlah yang sesuai dengan kebutuhan tubuh, dengan memperhatikan prinsip keanekaragaman pangan, aktivitas fisik, perilaku hidup bersih, serta mempertahankan berat badan ideal.",
                        ),
                        ForumCard(
                          username: "Mama Yaxian",
                          postedAt: "10 Mei 2025",
                          title: "Gizi Seimbang",
                          content:
                              "Gizi seimbang adalah susunan makanan sehari-hari yang mengandung zat-zat gizi dalam jenis dan jumlah yang sesuai dengan kebutuhan tubuh, dengan memperhatikan prinsip keanekaragaman pangan, aktivitas fisik, perilaku hidup bersih, serta mempertahankan berat badan ideal.",
                        ),
                      ],
                    ),
                  ),
                ),

                // Tab "Postingan Saya"
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ForumCard(
                                username: "Mama Karina (Saya)",
                                postedAt: "2 jam yang lalu",
                                title: "Resep Makanan Sehat Anak Saya",
                                content: "Tips makanan sehat harian.",
                              ),
                              ForumCard(
                                username: "Mama Karina (Saya)",
                                postedAt: "10 jam yang lalu",
                                title: "Anak saya susah makan sayur",
                                content: "Pengalaman diet seimbang.",
                              ),
                              ForumCard(
                                username: "Mama Karina (Saya)",
                                postedAt: "18 Mei 2025",
                                title: "Anak saya susah makan sayur",
                                content: "Pengalaman diet seimbang.",
                              ),
                              ForumCard(
                                username: "Mama Karina (Saya)",
                                postedAt: "10 Mei 2025",
                                title: "Anak saya susah makan sayur",
                                content: "Pengalaman diet seimbang.",
                              ),
                              ForumCard(
                                username: "Mama Karina (Saya)",
                                postedAt: "10 Mei 2025",
                                title: "Anak saya susah makan sayur",
                                content: "Pengalaman diet seimbang.",
                              ),
                              ForumCard(
                                username: "Mama Karina (Saya)",
                                postedAt: "8 Mei 2025",
                                title: "Anak saya susah makan sayur",
                                content: "Pengalaman diet seimbang.",
                              ),
                              // Jarak antara card terakhir dan tombol tambah
                              SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 48,
                      right: 16,
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: FloatingActionButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          onPressed: () {
                            // Aksi ketika tombol ditekan
                          },
                          child: const Icon(Icons.add),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget untuk menampilkan card forum
class ForumCard extends StatefulWidget {
  final String username;
  final String postedAt;
  final String title;
  final String content;
  final bool isLiked;

  const ForumCard({
    super.key,
    required this.username,
    required this.postedAt,
    required this.title,
    required this.content,
    this.isLiked = false,
  });

  @override
  _ForumCardState createState() => _ForumCardState();
}

class _ForumCardState extends State<ForumCard> {
  late bool isLiked = widget.isLiked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushWithSlideTransition(context, PostScreen());
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
              // menampilkan nama pengguna dan waktu posting
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: AppColors.textGrey,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              widget.postedAt,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(widget.content, textAlign: TextAlign.justify),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.grey),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Icon(AppIcons.like, size: 20, color: AppColors.error),
                          GestureDetector(
                            child: Icon(
                              isLiked ? AppIcons.likeFill : AppIcons.like,
                              color: isLiked ? AppColors.error : Colors.black,
                              size: 20,
                            ),
                            onTap: () {
                              setState(() {
                                isLiked = !isLiked;
                              });
                            },
                          ),
                          SizedBox(width: 4),
                          Text("4", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      SizedBox(width: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(AppIcons.comment, size: 20),
                          SizedBox(width: 4),
                          Text("2", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                  ButtonWithReport(content: "postingan"),
                  // Icon(AppIcons.info, size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
