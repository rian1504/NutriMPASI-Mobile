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
import 'package:nutrimpasi/screens/baby/baby_list_screen.dart';
import 'package:nutrimpasi/screens/features/notification_screen.dart';
import 'package:nutrimpasi/screens/setting/setting_profile_screen.dart';
import 'package:nutrimpasi/screens/setting/setting_password_screen.dart';
import 'package:nutrimpasi/screens/setting/favorite_recipes_screen.dart';
import 'package:nutrimpasi/screens/setting/history_likes_screen.dart';
import 'package:nutrimpasi/utils/navigation_animation.dart';
import 'package:nutrimpasi/widgets/custom_button.dart';
import 'package:nutrimpasi/widgets/custom_dialog.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    // Dapatkan data user dari authentication bloc
    final authState = context.watch<AuthenticationBloc>().state;
    final loggedInUser = authState is LoginSuccess ? authState.user : null;

    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            context.read<BabyBloc>().add(ResetBaby());
            Navigator.pushReplacementNamed(context, '/login');
          });
        } else if (state is AuthenticationError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
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
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        8,
                        MediaQuery.of(context).padding.top,
                        8,
                        8,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/images/logo/nutrimpasi.png',
                                height: 56,
                              ),
                              Text(
                                "Pengaturan",
                                style: const TextStyle(
                                  color: AppColors.textWhite,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              CircleButton(
                                onPressed: () {
                                  pushWithSlideTransition(
                                    context,
                                    FavoriteRecipeScreen(),
                                  );
                                },
                                icon: AppIcons.favoriteRegular,
                              ),
                            ],
                          ),

                          // SizedBox(height: 14),
                          Stack(
                            children: [
                              // avatar
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey.shade200,
                                child: ClipOval(
                                  child:
                                      loggedInUser!.avatar != null
                                          ? Image.network(
                                            storageUrl + loggedInUser.avatar!,
                                            width: 32,
                                            height: 32,
                                            fit: BoxFit.cover,
                                          )
                                          : Icon(
                                            AppIcons.userFill,
                                            color: AppColors.primary,
                                            size: 20,
                                          ),
                                ),
                              ),
                              // tombol edit avatar
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: AppColors.textWhite,
                                      width: 2,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    AppIcons.editFill,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          // username
                          Text(
                            loggedInUser.name,
                            style: TextStyle(
                              color: AppColors.textWhite,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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
                                  AppIcons.userFill,
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
                                    ProfileSettingScreen(user: loggedInUser),
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
                                    PasswordSettingScreen(),
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
                                title: Text('Thread yang Disukai'),
                                trailing: Icon(
                                  AppIcons.arrowRight,
                                  color: AppColors.greyDark,
                                  size: 20,
                                ),
                                onTap: () {
                                  pushWithSlideTransition(
                                    context,
                                    HistoryLikeScreen(),
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
                                leading: Icon(
                                  AppIcons.commentFill,
                                  color: Colors.black,
                                  size: 24,
                                ),
                                title: Text('Bahasa'),
                                trailing: Icon(
                                  AppIcons.arrowRight,
                                  color: AppColors.greyDark,
                                  size: 20,
                                ),
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
                                        confirmButtonTextColor: Colors.white,
                                        onCancel:
                                            () =>
                                                Navigator.of(dialogContext).pop(
                                                  false,
                                                ), // Kembali false jika batal
                                        onConfirm:
                                            () =>
                                                Navigator.of(dialogContext).pop(
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
                                      context.read<AuthenticationBloc>().add(
                                        LogoutRequested(),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
