// Nama File: post.dart
// Deskripsi: File ini adalah halaman postingan yang digunakan untuk menampilkan detail dari postingan pada forum diskusi pengguna aplikasi Nutrimpasi.
// Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// Tanggal: 13 Mei 2025

import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart' show AppIcons;
import 'package:nutrimpasi/widgets/forum_report_button.dart' show ReportButton;

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
      appBar: AppBarForum(title: "Post", showBackButton: true),
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
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                  child: Column(
                    children: [
                      _PostSection(
                        isLiked: false,
                        username: "Mama Karina (Saya)",
                        postedAt: "1 jam yang lalu",
                        title: "Gizi Seimbang",
                        content:
                            "Gizi seimbang adalah susunan makanan sehari-hari yang mengandung zat-zat gizi dalam jenis dan jumlah yang sesuai dengan kebutuhan tubuh, dengan memperhatikan prinsip keanekaragaman pangan, aktivitas fisik, perilaku hidup bersih, serta mempertahankan berat badan ideal.",
                        likeCount: 2,
                        commentCount: 4,
                      ), // Komentar
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        elevation: 2,
                        child: Column(
                          children: [
                            _CommentSection(
                              username: "Dr. Abdullah - Ahli Gizi",
                              postedAt: "2 jam yang lalu",
                              content:
                                  "Halo, moms! GTM pada bayi itu wajar dan sering terjadi, apalagi di usia 6-12 bulan. Bisa disebabkan oleh banyak faktor seperti bosan dengan rasa/tekstur, sedang tumbuh gigi, atau bahkan sedang sakit. Coba beri variasi makanan dan biarkan anak makan sendiri jika memungkinkan. Pastikan juga tidak terlalu banyak camilan sebelum makan utama ya!",
                              likeCount: 5,
                              commentCount: 0,
                            ),
                            Divider(color: AppColors.grey),
                            _CommentSection(
                              username: "Mama Mia",
                              postedAt: "1 jam yang lalu",
                              content:
                                  "Coba cek apa dia sedang tumbuh gigi, mom. Biasanya kalau lagi teething, anak jadi rewel dan susah makan. Bisa coba kasih makanan yang lebih lembut ya",
                              likeCount: 2,
                              commentCount: 0,
                            ),
                            Divider(color: AppColors.grey),
                            _CommentSection(
                              username: "Mama Aboy",
                              postedAt: "30 menit yang lalu",
                              content:
                                  "Wah, aku juga pernah ngalamin ini waktu anakku 8 bulan, mom! Aku coba variasi tekstur dan cara penyajiannya, misalnya kasih finger food atau biarkan dia eksplor sendiri. Kadang mereka cuma bosan dengan cara makannya yang itu-itu aja.",
                              likeCount: 3,
                              commentCount: 0,
                            ),
                            Divider(color: AppColors.grey),
                            _CommentSection(
                              username: "Mama Rora",
                              postedAt: "20 menit yang lalu",
                              content:
                                  "Wah, aku juga pernah ngalamin ini waktu anakku 8 bulan, mom! Aku coba variasi tekstur dan cara penyajiannya, misalnya kasih finger food atau biarkan dia eksplor sendiri. Kadang mereka cuma bosan dengan cara makannya yang itu-itu aja.",
                              likeCount: 0,
                              commentCount: 0,
                            ),
                          ],
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
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: const _CommentInputBar(),
      ),
    );
  }
}

class _PostSection extends StatefulWidget {
  final String username;
  final String postedAt;
  final String title;
  final String content;
  final int likeCount;
  final int commentCount;
  final bool isLiked;

  _PostSection({
    required this.username,
    required this.postedAt,
    required this.title,
    required this.content,
    required this.likeCount,
    required this.commentCount,
    required this.isLiked,
    // super.key,
  });

  @override
  State<_PostSection> createState() => _PostSectionState();
}

class _PostSectionState extends State<_PostSection> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;
  }

  void _toggleLike() => setState(() => isLiked = !isLiked);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Postingan
        Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          elevation: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.textBlack,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.content,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.postedAt,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: AppColors.textGrey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isLiked
                                        ? AppIcons.favoriteFill
                                        : AppIcons.favorite,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                  onPressed: _toggleLike,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  widget.likeCount.toString(),
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(width: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  AppIcons.comment,
                                  size: 24,
                                  color: AppColors.textBlack,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.commentCount.toString(),
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Tombol untuk melaporkan postingan
                        ReportButton(content: "postingan"),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                color: AppColors.primaryTransparent,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(
                    "4 Komentar",
                    style: TextStyle(fontSize: 14, color: AppColors.textBlack),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CommentSection extends StatefulWidget {
  final String username;
  final String postedAt;
  final String content;
  final int likeCount;
  final int commentCount;
  final bool isLiked = false;

  const _CommentSection({
    required this.username,
    required this.postedAt,
    required this.content,
    required this.likeCount,
    required this.commentCount,
  });
  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<_CommentSection> {
  late bool isLiked = widget.isLiked;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
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
              // Nama pengguna dan isi komentar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Nama pengguna
                        Text(
                          widget.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.textBlack,
                          ),
                        ),
                        SizedBox(width: 8),
                        // Tanggal posting
                        Text(
                          widget.postedAt,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    // Isi komentar
                    Text(widget.content, textAlign: TextAlign.justify),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Tombol untuk like, comment, dan info
        Padding(
          padding: const EdgeInsets.fromLTRB(44, 0, 4, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Tombol like
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          isLiked ? AppIcons.favoriteFill : AppIcons.favorite,
                          color: Colors.red,
                          size: 24,
                        ),
                        onPressed: () {
                          setState(() {
                            isLiked = !isLiked;
                          });
                        },
                      ),
                      Text(
                        widget.likeCount.toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  // Tombol komentar
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        AppIcons.comment,
                        size: 24,
                        color: AppColors.textBlack,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.commentCount.toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
              // Tombol untuk melaporkan komentar
              ReportButton(content: "komentar"),
            ],
          ),
        ),
      ],
    );
  }
}

// Widget untuk menampilkan input komentar
class _CommentInputBar extends StatelessWidget {
  const _CommentInputBar();

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
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
