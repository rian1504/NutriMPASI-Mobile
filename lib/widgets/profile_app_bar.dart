// Nama File: profile_app_bar.dart
// Deskripsi: Widget untuk menampilkan app bar halaman profil
// Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// Tanggal: 26 Mei 2025

// Widget untuk membuat AppBar dengan rounded corner di bagian kanan bawah
import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart';

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
