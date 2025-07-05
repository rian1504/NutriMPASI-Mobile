// Nama file: profile_screen.dart
// Deskripsi: File ini adalah halaman profil pengguna dalam aplikasi Nutrimpasi.
// Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// Tanggal: 26 Mei 2025

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/blocs/authentication/authentication_bloc.dart';
import 'package:nutrimpasi/blocs/baby/baby_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/screens/auth/login_screen.dart';
import 'package:nutrimpasi/screens/baby/baby_list_screen.dart';
import 'package:nutrimpasi/screens/features/notification_screen.dart';
import 'package:nutrimpasi/screens/setting/manage_profile_screen.dart';
import 'package:nutrimpasi/screens/setting/manage_password_screen.dart';
import 'package:nutrimpasi/screens/setting/favorite_recipe_screen.dart';
import 'package:nutrimpasi/screens/setting/favorite_thread_screen.dart';
import 'package:nutrimpasi/screens/setting/about_screen.dart';
import 'package:nutrimpasi/utils/flushbar.dart';
import 'package:nutrimpasi/utils/navigation_animation.dart';
import 'package:nutrimpasi/widgets/custom_app_bar.dart';
import 'package:nutrimpasi/widgets/custom_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        appVersion = packageInfo.version;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dapatkan data user dari authentication bloc
    final authState = context.watch<AuthenticationBloc>().state;
    final loggedInUser = authState is LoginSuccess ? authState.user : null;

    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              // Navigasi ke login
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            }
            AppFlushbar.showNormal(
              context,
              title: 'Selamat tinggal Mama!',
              message: state.message,
              marginVerticalValue: 8,
            );
            context.read<BabyBloc>().add(ResetBaby());
          });
        } else if (state is AuthenticationError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AppFlushbar.showError(
              context,
              title: 'Error',
              message: state.error,
            );
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 60,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Stack(
                  // clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: MediaQuery.of(context).size.height * 1 / 3,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 1 / 3,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/banner/setting_wallpaper.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top:
                                  getStatusBarHeight(context) +
                                  (getAppBarHeight / 2) -
                                  10, // Sekitar tengah vertikal di toolbar
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Text(
                                  'Pengaturan',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top:
                                  getStatusBarHeight(context) +
                                  (getAppBarHeight), // Sekitar tengah vertikal di toolbar
                              left: 0,
                              right: 0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  //avatar
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(60),
                                      color: AppColors.white,
                                    ),
                                    // radius: 60,
                                    // backgroundColor: AppColors.white,
                                    child:
                                        loggedInUser?.avatar != null
                                            ? ClipOval(
                                              child: Image.network(
                                                storageUrl +
                                                    loggedInUser!.avatar!,
                                                width: 120,
                                                height: 120,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                            : Icon(
                                              Icons.person_rounded,
                                              color: AppColors.primary,
                                              size: 120,
                                            ),
                                  ),
                                  SizedBox(height: 8),
                                  // nama pengguna
                                  Text(
                                    loggedInUser?.name ?? 'Pengguna',
                                    style: TextStyle(
                                      color: AppColors.textWhite,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: MediaQuery.of(context).size.height * 2 / 3,
                      child: Container(),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 1 / 3 - 48,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              color: AppColors.textWhite,
                              elevation: 1,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      Icons.person,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                    title: Text('Profil Saya'),
                                    trailing: Icon(
                                      AppIcons.arrowRight,
                                      color: AppColors.greyDark,
                                      size: 20,
                                    ),
                                    onTap: () {
                                      pushWithSlideTransition(
                                        context,
                                        ManageProfileScreen(user: loggedInUser),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      AppIcons.lockFill,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                    title: Text('Kelola Kata Sandi'),
                                    trailing: Icon(
                                      AppIcons.arrowRight,
                                      color: AppColors.greyDark,
                                      size: 20,
                                    ),
                                    onTap: () {
                                      pushWithSlideTransition(
                                        context,
                                        ManageSettingScreen(),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      AppIcons.baby,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                    title: Text('Kelola Profil Bayi'),
                                    trailing: Icon(
                                      AppIcons.arrowRight,
                                      color: AppColors.greyDark,
                                      size: 20,
                                    ),
                                    onTap: () {
                                      pushWithSlideTransition(
                                        context,
                                        BabyListScreen(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              color: AppColors.textWhite,
                              elevation: 1,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      AppIcons.favoriteFill,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                    title: Text('Resep Favorit'),
                                    trailing: Icon(
                                      AppIcons.arrowRight,
                                      color: AppColors.greyDark,
                                      size: 20,
                                    ),
                                    onTap: () {
                                      pushWithSlideTransition(
                                        context,
                                        FavoriteRecipeScreen(),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      AppIcons.forum,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                    title: Text('Postingan yang Disukai'),
                                    trailing: Icon(
                                      AppIcons.arrowRight,
                                      color: AppColors.greyDark,
                                      size: 20,
                                    ),
                                    onTap: () {
                                      pushWithSlideTransition(
                                        context,
                                        FavoriteThreadScreen(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              color: AppColors.textWhite,
                              elevation: 1,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      AppIcons.notificationFill,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                    title: Text('Notifikasi'),
                                    trailing: Icon(
                                      AppIcons.arrowRight,
                                      color: AppColors.greyDark,
                                      size: 20,
                                    ),
                                    onTap: () {
                                      pushWithSlideTransition(
                                        context,
                                        NotificationScreen(),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: Image.asset(
                                      'assets/images/icon/nutrimpasi.png',
                                      width: 24,
                                      height: 24,
                                      color: Colors.black,
                                    ),
                                    title: Text('Tentang NutriMPASI'),
                                    trailing: Icon(
                                      AppIcons.arrowRight,
                                      color: AppColors.greyDark,
                                      size: 20,
                                    ),
                                    onTap: () {
                                      pushWithSlideTransition(
                                        context,
                                        AboutScreen(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              color: AppColors.textWhite,
                              elevation: 1,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      AppIcons.logout,
                                      color: AppColors.error,
                                      size: 24,
                                    ),
                                    title: Text(
                                      'Keluar',
                                      style: TextStyle(color: AppColors.error),
                                    ),
                                    trailing: Icon(
                                      AppIcons.arrowRight,
                                      color: AppColors.error,
                                      size: 20,
                                    ),
                                    onTap: () async {
                                      // Tampilkan ConfirmDialog
                                      final bool?
                                      confirmed = await showDialog<bool>(
                                        context: context,
                                        builder: (dialogContext) {
                                          return ConfirmDialog(
                                            titleText: "Konfirmasi Keluar",
                                            contentText:
                                                "Apakah Anda yakin ingin keluar dari akun ini?",
                                            confirmButtonText: "Keluar",
                                            cancelButtonText: "Batal",
                                            confirmButtonColor:
                                                AppColors
                                                    .error, // Tombol keluar biasanya merah
                                            confirmButtonTextColor:
                                                Colors.white,
                                            onCancel:
                                                () => Navigator.of(
                                                  dialogContext,
                                                ).pop(
                                                  false,
                                                ), // Kembali false jika batal
                                            onConfirm:
                                                () => Navigator.of(
                                                  dialogContext,
                                                ).pop(
                                                  true,
                                                ), // Kembali true jika keluar
                                          );
                                        },
                                      );

                                      // Jika pengguna mengkonfirmasi (menekan "Keluar")
                                      if (confirmed == true) {
                                        // Memicu event LogoutRequested ke AuthenticationBloc
                                        // Pastikan context masih valid sebelum memanggil Bloc
                                        if (context.mounted) {
                                          context
                                              .read<AuthenticationBloc>()
                                              .add(LogoutRequested());
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            // Informasi versi dan copyright
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Versi $appVersion',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.greyDark,
                                    ),
                                  ),
                                  Text(
                                    '© 2025 Politeknik Negeri Batam',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.greyDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),
                          ],
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
    );
  }
}
