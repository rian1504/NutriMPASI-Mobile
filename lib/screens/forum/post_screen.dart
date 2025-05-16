// Nama File: post.dart
// Deskripsi: File ini adalah halaman postingan yang digunakan untuk menampilkan detail dari postingan pada forum diskusi pengguna aplikasi Nutrimpasi.
// Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// Tanggal: 13 Mei 2025

import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart' show AppIcons;
import 'package:nutrimpasi/widgets/forum_info_report_button.dart'
    show InfoButtonWithReport;

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
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      PostSection(
                        username: "Mama Karina (Saya)",
                        title: "Gizi Seimbang",
                        content:
                            "Gizi seimbang adalah susunan makanan sehari-hari yang mengandung zat-zat gizi dalam jenis dan jumlah yang sesuai dengan kebutuhan tubuh, dengan memperhatikan prinsip keanekaragaman pangan, aktivitas fisik, perilaku hidup bersih, serta mempertahankan berat badan ideal.",
                        likeCount: 2,
                        commentCount: 4,
                      ), // Komentar
                      Container(
                        width: double.infinity,
                        color: AppColors.primaryTransparent,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Text(
                            "4 Komentar",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textBlack,
                            ),
                          ),
                        ),
                      ),
                      CommentSection(
                        username: "Dr. Abdullah - Ahli Gizi",
                        content:
                            "Halo, moms! GTM pada bayi itu wajar dan sering terjadi, apalagi di usia 6-12 bulan. Bisa disebabkan oleh banyak faktor seperti bosan dengan rasa/tekstur, sedang tumbuh gigi, atau bahkan sedang sakit. Coba beri variasi makanan dan biarkan anak makan sendiri jika memungkinkan. Pastikan juga tidak terlalu banyak camilan sebelum makan utama ya!",
                        likeCount: 5,
                        commentCount: 0,
                      ),
                      Divider(color: AppColors.grey),
                      CommentSection(
                        username: "Mama Mia",
                        content:
                            "Coba cek apa dia sedang tumbuh gigi, mom. Biasanya kalau lagi teething, anak jadi rewel dan susah makan. Bisa coba kasih makanan yang lebih lembut ya",
                        likeCount: 2,
                        commentCount: 0,
                      ),
                      Divider(color: AppColors.grey),
                      CommentSection(
                        username: "Mama Aboy",
                        content:
                            "Wah, aku juga pernah ngalamin ini waktu anakku 8 bulan, mom! Aku coba variasi tekstur dan cara penyajiannya, misalnya kasih finger food atau biarkan dia eksplor sendiri. Kadang mereka cuma bosan dengan cara makannya yang itu-itu aja.",
                        likeCount: 3,
                        commentCount: 0,
                      ),
                      Divider(color: AppColors.grey),
                      CommentSection(
                        username: "Mama Rora",
                        content:
                            "Wah, aku juga pernah ngalamin ini waktu anakku 8 bulan, mom! Aku coba variasi tekstur dan cara penyajiannya, misalnya kasih finger food atau biarkan dia eksplor sendiri. Kadang mereka cuma bosan dengan cara makannya yang itu-itu aja.",
                        likeCount: 0,
                        commentCount: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: const CommentInputBar(),
      ),
    );
  }
}

class PostSection extends StatelessWidget {
  final String username;
  final String title;
  final String content;
  final int likeCount;
  final int commentCount;

  const PostSection({
    super.key,
    required this.username,
    required this.title,
    required this.content,
    required this.likeCount,
    required this.commentCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Postingan
        Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primaryTransparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  AppIcons.userFill,
                  color: AppColors.primary,
                  size: 20,
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
        // Tombol untuk like, comment, dan info
        Padding(
          padding: EdgeInsets.fromLTRB(16, 4, 0, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(AppIcons.like, size: 20, color: Colors.black),
                      SizedBox(width: 4),
                      Text(
                        likeCount.toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(AppIcons.comment, size: 20),
                      SizedBox(width: 4),
                      Text(
                        commentCount.toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              InfoButtonWithReport(),
            ],
          ),
        ),
      ],
    );
  }
}

class CommentSection extends StatelessWidget {
  final String username;
  final String content;
  final int likeCount;
  final int commentCount;

  const CommentSection({
    super.key,
    required this.username,
    required this.content,
    required this.likeCount,
    required this.commentCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
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
                    Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: AppColors.textGrey,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(content, textAlign: TextAlign.justify),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Tombol untuk like, comment, dan info
        Padding(
          padding: const EdgeInsets.fromLTRB(56, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(AppIcons.like, size: 20, color: Colors.black),
                      SizedBox(width: 4),
                      Text(
                        likeCount.toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(AppIcons.comment, size: 20),
                      SizedBox(width: 4),
                      Text(
                        commentCount.toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              InfoButtonWithReport(),
            ],
          ),
        ),
      ],
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
              maxLines: null, // Membuatnya bisa auto-expand vertikal
              // minLines: 1, // Jumlah minimum baris
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: 'Tulis komentar...',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
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
