// Nama File: post.dart
// Deskripsi: File ini adalah halaman postingan yang digunakan untuk menampilkan detail dari postingan pada forum diskusi pengguna aplikasi Nutrimpasi.
// Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// Tanggal: 13 Mei 2025

import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart' show AppIcons;

// Widget untuk menampilkan app bar forum diskusi
import '../../widgets/forum_app_bar.dart' show AppBarForum;

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarForum(screenTitle: "Post", showBackButton: true),
      body: Container(
        decoration: BoxDecoration(color: AppColors.primary),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), // hanya lengkung kanan bawah
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ForumCard(
              username: "Mama Karina (Saya)",
              title: "Gizi Seimbang",
              content:
                  "Gizi seimbang adalah susunan makanan sehari-hari yang mengandung zat-zat gizi dalam jenis dan jumlah yang sesuai dengan kebutuhan tubuh, dengan memperhatikan prinsip keanekaragaman pangan, aktivitas fisik, perilaku hidup bersih, serta mempertahankan berat badan ideal.",
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CommentInputBar(),
    );
  }
}

class ForumCard extends StatelessWidget {
  final String username;
  final String title;
  final String content;

  const ForumCard({
    super.key,
    required this.username,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const PostScreen(), // Ganti sesuai kebutuhan
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // abu-abu muda
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      AppIcons.userFill,
                      color: AppColors.textBlack,
                      size: 20, // opsional, atur agar pas di lingkaran
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: AppColors.textGrey,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(content, textAlign: TextAlign.justify),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.grey),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(AppIcons.like, size: 20),
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
                  Icon(AppIcons.info, size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget untuk menampilkan input komentar
class CommentInputBar extends StatelessWidget {
  const CommentInputBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tulis komentar...',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppColors.primary,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 18),
              onPressed: () {
                // TODO: Tambahkan logika kirim komentar
              },
            ),
          ),
        ],
      ),
    );
  }
}
