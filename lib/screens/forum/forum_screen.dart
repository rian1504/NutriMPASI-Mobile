// Nama File: forum.dart
// Deskripsi: File ini adalah halaman forum yang digunakan untuk menampilkan forum diskusi pengguna aplikasi Nutrimpasi.
// Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// Tanggal: 12 Mei 2025

import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/screens/forum/post_screen.dart' show ForumCard;

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
        body: Expanded(
          child: Container(
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
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: const [
                      ForumCard(
                        username: "Mama Karina (Saya)",
                        title: "Gizi Seimbang",
                        content:
                            "Gizi seimbang adalah susunan makanan sehari-hari yang mengandung zat-zat gizi dalam jenis dan jumlah yang sesuai dengan kebutuhan tubuh, dengan memperhatikan prinsip keanekaragaman pangan, aktivitas fisik, perilaku hidup bersih, serta mempertahankan berat badan ideal.",
                      ),
                      ForumCard(
                        username: "Mama Asa",
                        title: "Resep Makanan Sehat",
                        content: "Pentingnya sarapan pagi.",
                      ),
                      ForumCard(
                        username: "Mama Rora",
                        title: "Gizi Seimbang",
                        content:
                            "Gizi seimbang adalah susunan makanan sehari-hari yang mengandung zat-zat gizi dalam jenis dan jumlah yang sesuai dengan kebutuhan tubuh, dengan memperhatikan prinsip keanekaragaman pangan, aktivitas fisik, perilaku hidup bersih, serta mempertahankan berat badan ideal.",
                      ),
                      ForumCard(
                        username: "Mama Yaxian",
                        title: "Gizi Seimbang",
                        content:
                            "Gizi seimbang adalah susunan makanan sehari-hari yang mengandung zat-zat gizi dalam jenis dan jumlah yang sesuai dengan kebutuhan tubuh, dengan memperhatikan prinsip keanekaragaman pangan, aktivitas fisik, perilaku hidup bersih, serta mempertahankan berat badan ideal.",
                      ),
                    ],
                  ),
          
                  // Tab "Postingan Saya"
                  Stack(
                    children: [
                      ListView(
                        padding: const EdgeInsets.all(16),
                        children: const [
                          ForumCard(
                            username: "Mama Karina (Saya)",
                            title: "Resep Makanan Sehat Anak Saya",
                            content: "Tips makanan sehat harian.",
                          ),
                          ForumCard(
                            username: "Mama Karina (Saya)",
                            title: "Anak saya susah makan sayur",
                            content: "Pengalaman diet seimbang.",
                          ),
                          ForumCard(
                            username: "Mama Karina (Saya)",
                            title: "Anak saya susah makan sayur",
                            content: "Pengalaman diet seimbang.",
                          ),
                          ForumCard(
                            username: "Mama Karina (Saya)",
                            title: "Anak saya susah makan sayur",
                            content: "Pengalaman diet seimbang.",
                          ),
                          ForumCard(
                            username: "Mama Karina (Saya)",
                            title: "Anak saya susah makan sayur",
                            content: "Pengalaman diet seimbang.",
                          ),
                          ForumCard(
                            username: "Mama Karina (Saya)",
                            title: "Anak saya susah makan sayur",
                            content: "Pengalaman diet seimbang.",
                          ),
                        ],
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
      ),
    );
  }
}
