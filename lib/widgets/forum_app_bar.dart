// Nama File: forum_app_bar.dart
// Deskripsi: Widget untuk menampilkan app bar dengan rounded corner di bagian kanan bawah
// Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// Tanggal: 13 Mei 2025

// Widget untuk membuat AppBar dengan rounded corner di bagian kanan bawah
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/blocs/like/like_bloc.dart';
import 'package:nutrimpasi/blocs/thread/thread_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart';
import 'package:nutrimpasi/widgets/button.dart';

class AppBarForum extends StatelessWidget implements PreferredSizeWidget {
  final bool showTabs;
  final bool showBackButton;
  final bool showExitButton;
  final String title;
  final String category;

  const AppBarForum({
    super.key,
    this.showTabs = false,
    this.showBackButton = false,
    this.showExitButton = false,
    required this.title,
    required this.category,
  });

  @override
  Size get preferredSize => Size.fromHeight(showTabs ? kToolbarHeight + 100 : kToolbarHeight + 62);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background dengan clip
        ClipPath(
          clipper: RightBottomRoundedClipper(),
          child: Container(
            height: preferredSize.height,
            width: double.infinity,
            color: AppColors.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const SizedBox(height: 16),
                if (showTabs == false)
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10.0),
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (showTabs == true)
                  // Judul
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),

                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                // TabBar jika diaktifkan
                if (showTabs)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        labelPadding: EdgeInsets.zero,
                        indicator: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorPadding: const EdgeInsets.all(6),
                        labelColor: Colors.white,
                        unselectedLabelColor: AppColors.primary,
                        tabs: const [Tab(text: 'Semua'), Tab(text: 'Postingan Saya')],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Tombol back seperti floating action button
        if (showBackButton)
          LeadingActionButton(
            onPressed: () {
              Navigator.pop(context);

              switch (category) {
                case 'forum':
                  context.read<ThreadBloc>().add(FetchThreads());
                  break;
                case 'like':
                  context.read<LikeBloc>().add(FetchLikes());
                  break;
                default:
                  '';
              }
            },
            icon: AppIcons.back,
          ),
        if (showExitButton)
          LeadingActionButton(onPressed: () => Navigator.pop(context), icon: AppIcons.exit),
      ],
    );
  }
}

// Custom clipper untuk membuat rounded corner di bagian kanan bawah
class RightBottomRoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0); // Garis lurus ke kanan atas
    path.lineTo(size.width, size.height - 40); // Garis turun ke atas lengkungan
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - 40,
      size.height,
    ); // Lengkung kanan bawah
    path.lineTo(0, size.height); // Garis ke kiri bawah
    path.close(); // Tutup path ke titik awal (0, 0)
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
