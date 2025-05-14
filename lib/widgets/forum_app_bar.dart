// Widget untuk membuat AppBar dengan rounded corner di bagian kanan bawah
import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart';

class AppBarForum extends StatelessWidget implements PreferredSizeWidget {
  final bool showTabs;
  final bool showBackButton;
  final String screenTitle;

  const AppBarForum({
    super.key,
    this.showTabs = false,
    this.showBackButton = false,
    required this.screenTitle,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(showTabs ? kToolbarHeight + 116 : kToolbarHeight + 76);

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
                const SizedBox(height: 16),
                // Judul
                Text(
                  screenTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // TabBar jika diaktifkan
                if (showTabs)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                        tabs: const [
                          Tab(text: 'Semua'),
                          Tab(text: 'Postingan Saya'),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Tombol back seperti floating action button
        if (showBackButton)
          Positioned(
            top: 44,
            left: 16,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 3,
              onPressed: () => Navigator.pop(context),
              child: Icon(AppIcons.back),
            ),
          ),
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
