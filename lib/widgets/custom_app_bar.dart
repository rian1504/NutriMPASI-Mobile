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

// Tinggi status bar
double getStatusBarHeight(BuildContext context) =>
    MediaQuery.of(context).padding.top;
// Tinggi AppBar 56.0 dp
const double getAppBarHeight = kToolbarHeight;

class CustomAppBar extends StatelessWidget {
  final String title;
  final IconData? leadingIcon;
  final IconData? icon;
  final VoidCallback? onLeadingPressed;
  final Widget?
  customLeadingWidget; // Untuk widget leading yang sepenuhnya kustom
  final Widget? trailingWidget; // Untuk widget aksi di kanan
  final bool? appBarContent; // Konten utama yang bisa di-scroll
  final Widget content;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leadingIcon,
    this.icon,
    this.onLeadingPressed,
    this.customLeadingWidget,
    this.trailingWidget,
    this.appBarContent = false,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        clipBehavior: Clip.none,
        // Scaffold.body adalah Stack utama
        children: [
          // LAPISAN 1: BACKGROUND HEADER
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height:
                getStatusBarHeight(context) +
                getAppBarHeight, // Tinggi total area header
            child: Container(
              color: AppColors.primary, // Warna latar belakang header
              // Anda bisa mengganti dengan Image.asset atau Image.network di sini
              // child: Image.asset('assets/images/header_bg.png', fit: BoxFit.cover),
            ),
          ),

          if (appBarContent == true)
            Positioned(
              // top: 30,
              top: getAppBarHeight + getStatusBarHeight(context),
              left: 0,
              right: 0,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: 125,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                        child: Center(
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              icon,
                              size: 100,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // LAPISAN 2: KONTEN UTAMA LAYAR (HARUS PUNYA PADDING DARI ATAS)
          Positioned.fill(
            top:
                getStatusBarHeight(context) +
                getAppBarHeight +
                110, // Konten dimulai di bawah header kustom
            child: content,
          ),

          // LAPISAN 3: ELEMEN HEADER KUSTOM (Positioned)

          // 3a. LEADING BUTTON (Positioned FloatingActionButton-like)
          // customLeadingWidget ?? // Prioritaskan customLeadingWidget jika diberikan
          LeadingActionButton(
            onPressed: () => Navigator.pop(context),
            icon: AppIcons.back,
          ),

          // 3b. JUDUL DI TENGAH (Positioned Text)
          Positioned(
            top:
                getStatusBarHeight(context) +
                (getAppBarHeight / 2) -
                8, // Sekitar tengah vertikal di toolbar
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
          ),

          // 3c. TRAILING WIDGET (ACTIONS)
          Positioned(
            top:
                getStatusBarHeight(context) +
                4, // Sejajar dengan tombol leading
            right: 8, // Jarak dari kanan
            child:
                trailingWidget ??
                const SizedBox.shrink(), // Gunakan trailingWidget jika ada
          ),

          // 3d. Header Content (Jika ada)
          // if (appBarContent == true)
          //   Positioned(
          //     // top: 50,
          //     top:
          //         getStatusBarHeight(context) +
          //         getAppBarHeight +
          //         0, // Tinggi total area header,
          //     child: Stack(
          //       clipBehavior: Clip.none,
          //       children: [
          //         Container(
          //           width: double.infinity,
          //           height: 125,
          //           decoration: BoxDecoration(
          //             color: AppColors.primary,
          //             borderRadius: const BorderRadius.only(
          //               bottomLeft: Radius.circular(30),
          //               bottomRight: Radius.circular(30),
          //             ),
          //             boxShadow: [
          //               BoxShadow(
          //                 color: Colors.black.withAlpha(50),
          //                 offset: const Offset(0, 4),
          //                 blurRadius: 8,
          //                 spreadRadius: 2,
          //               ),
          //             ],
          //           ),
          //         ),
          //         Positioned(
          //           top: 0,
          //           left: 0,
          //           right: 0,
          //           child: Center(
          //             child: Container(
          //               width: 200,
          //               height: 200,
          //               decoration: BoxDecoration(
          //                 shape: BoxShape.circle,
          //                 color: AppColors.primary,
          //                 boxShadow: [
          //                   BoxShadow(
          //                     color: Colors.black.withAlpha(10),
          //                     offset: const Offset(0, 8),
          //                     blurRadius: 0,
          //                     spreadRadius: 0,
          //                   ),
          //                 ],
          //               ),
          //               child: Center(
          //                 child: Container(
          //                   width: 150,
          //                   height: 150,
          //                   decoration: BoxDecoration(
          //                     color: Colors.white,
          //                     shape: BoxShape.circle,
          //                     boxShadow: [
          //                       BoxShadow(
          //                         color: Colors.black.withAlpha(25),
          //                         blurRadius: 6,
          //                         spreadRadius: 1,
          //                       ),
          //                     ],
          //                   ),
          //                   child: const Icon(
          //                     Icons.lock_rounded,
          //                     size: 100,
          //                     color: AppColors.accent,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
        ],
      ),
    );
  }
}

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
  Size get preferredSize =>
      Size.fromHeight(showTabs ? kToolbarHeight + 100 : kToolbarHeight + 62);

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
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 10.0,
                    ),
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
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                    ),

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
          LeadingActionButton(
            onPressed: () => Navigator.pop(context),
            icon: AppIcons.exit,
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
  Size get preferredSize =>
      Size.fromHeight(showIcon ? kToolbarHeight + 108 : kToolbarHeight + 44);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background utama AppBar dengan sudut melengkung di bagian bawah
        Container(
          height:
              preferredSize.height, // Tinggi background tanpa bagian menonjol
          decoration:
              showIcon
                  ? BoxDecoration(
                    color: AppColors.primary, // Warna background AppBar
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                        20.0,
                      ), // Sudut melengkung kiri bawah
                      bottomRight: Radius.circular(
                        20.0,
                      ), // Sudut melengkung kanan bawah
                    ),
                  )
                  : BoxDecoration(
                    color: AppColors.primary, // Warna background AppBar
                  ),

          child: Padding(
            // Padding untuk judul agar tidak terlalu dekat dengan status bar
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16.0,
            ),
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
                MediaQuery.of(context).padding.top +
                8.0, // Sesuaikan dengan padding atas perangkat
            left: 16.0,
            child: leadingWidget!,
          ),

        // Posisi untuk widget trailing (misalnya ikon pengaturan)
        if (trailingWidget != null)
          Positioned(
            top:
                MediaQuery.of(context).padding.top +
                8.0, // Sesuaikan dengan padding atas perangkat
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
                    MediaQuery.of(context).size.width *
                    0.3, // Lebar lingkaran profil (misal 60.0)
                height:
                    MediaQuery.of(context).size.width *
                    0.3, // Tinggi lingkaran profil (misal 60.0)
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.primary, // Warna border lingkaran
                    width: 12.0, // Lebar border
                  ),
                  shape: BoxShape.circle,
                  color:
                      Colors
                          .white, // Warna background lingkaran (biasanya putih)
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
