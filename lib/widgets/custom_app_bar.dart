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
import 'package:nutrimpasi/widgets/custom_button.dart';


//Widget untuk membuat AppBarForum dengan rounded corner di bagian kanan bawah
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




// Widget AppBarProfile dengan gambar profil yang menonjol di bawah AppBar
class AppBarProfile extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leadingWidget; // Widget opsional untuk tombol kembali/menu
  final Widget? trailingWidget; // Widget opsional untuk ikon pengaturan/lainnya
  final bool showIcon;

  const AppBarProfile({
    super.key,
    required this.title,
    this.leadingWidget,
    this.trailingWidget,
    this.showIcon = false,
  });

  // Menentukan tinggi AppBar kustom.
  // kToolbarHeight adalah tinggi standar AppBar (biasanya 56.0).
  // 60.0 adalah tinggi tambahan untuk background AppBar di bawah toolbar.
  // 30.0 adalah setengah dari tinggi gambar profil (60.0 / 2) agar menonjol.
  @override
  Size get preferredSize => Size.fromHeight(showIcon ? kToolbarHeight + 108 : kToolbarHeight + 44);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background utama AppBar dengan sudut melengkung di bagian bawah
        Container(
          height: preferredSize.height, // Tinggi background tanpa bagian menonjol
          decoration:
              showIcon
                  ? BoxDecoration(
                    color: AppColors.primary, // Warna background AppBar
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0), // Sudut melengkung kiri bawah
                      bottomRight: Radius.circular(20.0), // Sudut melengkung kanan bawah
                    ),
                  )
                  : BoxDecoration(
                    color: AppColors.primary, // Warna background AppBar
                  ),

          child: Padding(
            // Padding untuk judul agar tidak terlalu dekat dengan status bar
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16.0),
            child: Align(
              alignment: Alignment.topCenter, // Judul di bagian atas tengah
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.textWhite, // Warna teks judul
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        // Posisi untuk widget leading (misalnya tombol kembali)
        if (leadingWidget != null)
          Positioned(
            top:
                MediaQuery.of(context).padding.top + 8.0, // Sesuaikan dengan padding atas perangkat
            left: 16.0,
            child: leadingWidget!,
          ),

        // Posisi untuk widget trailing (misalnya ikon pengaturan)
        if (trailingWidget != null)
          Positioned(
            top:
                MediaQuery.of(context).padding.top + 8.0, // Sesuaikan dengan padding atas perangkat
            right: 16.0,
            child: trailingWidget!,
          ),

        // Lingkaran Gambar Profil yang Menonjol
        if (showIcon == true)
          Positioned(
            left: 0,
            right: 0,
            // bottom: -30.0 adalah nilai negatif untuk membuat gambar menonjol ke bawah
            // Nilai ini harus setengah dari tinggi/lebar CircleAvatar (60/2 = 30)
            bottom: -56.0,
            child: Center(
              child: Container(
                width:
                    MediaQuery.of(context).size.width * 0.3, // Lebar lingkaran profil (misal 60.0)
                height:
                    MediaQuery.of(context).size.width * 0.3, // Tinggi lingkaran profil (misal 60.0)
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.primary, // Warna border lingkaran
                    width: 12.0, // Lebar border
                  ),
                  shape: BoxShape.circle,
                  color: Colors.white, // Warna background lingkaran (biasanya putih)
                ),
                child: Icon(
                  AppIcons.userFill,
                  size: 60,
                  color: AppColors.accent,
                ), // Ganti dengan gambar profil;
              ),
            ),
          ),
      ],
    );
  }
}
