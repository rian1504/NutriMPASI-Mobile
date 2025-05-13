// Widget untuk membuat AppBar dengan rounded corner di bagian kanan bawah
import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/colors.dart';

class AppBarForum extends StatelessWidget implements PreferredSizeWidget {
  final bool showTabs; // mengaktifkan tabbar
  final bool showBackButton;
  final String screenTitle; // judul layar

  const AppBarForum({
    super.key,
    this.showTabs = false,
    this.showBackButton = false,
    required this.screenTitle,
  });

  @override
  // preferredSize akan berubah tergantung apakah tab ditampilkan
  Size get preferredSize => Size.fromHeight(showTabs ? 140 : 80);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: RightBottomRoundedClipper(),
      child: Container(
        color: AppColors.primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Judul AppBar
            Text(
              screenTitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // TabBar untuk memilih antara "Semua" dan "Postingan Saya"
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
