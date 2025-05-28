// Nama file: profile_screen.dart
// Deskripsi: File ini adalah halaman profil pengguna dalam aplikasi Nutrimpasi.
// Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// Tanggal: 26 Mei 2025

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nutrimpasi/blocs/authentication/authentication_bloc.dart';
import 'package:nutrimpasi/blocs/baby/baby_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        // Tangani state LogoutSuccess
        if (state is LogoutSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            // Reset BabyBloc (jika memang terkait dengan logout)
            context.read<BabyBloc>().add(ResetBaby());
            // Navigasi ke halaman login (ganti dengan rute login yang sesuai)
            Navigator.pushReplacementNamed(context, '/login');
          });
        }
        // Tangani state AuthenticationError (opsional, tergantung kebutuhan)
        else if (state is AuthenticationError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background, // Ganti dengan warna latar belakang yang diinginkan

        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 1 / 3,
                    width: double.infinity,
                    // color: AppColors.primary,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/banner/setting_wallpaper.png',
                        ), // Ganti dengan gambar latar belakang yang sesuai
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Pengaturan",
                          style: const TextStyle(
                            color: AppColors.textWhite, // Warna teks judul
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 14),
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 60, // Ukuran avatar
                              backgroundColor: Colors.grey.shade200,
                              child: ClipOval(
                                child: SvgPicture.network(
                                  // <<< Ganti Image.network() dengan SvgPicture.network()
                                  'https://api.dicebear.com/8.x/lorelei/svg?seed=JaneDoe', // Ganti dengan URL gambar SVG yang sesuai
                                  width: 140, // Lebar gambar (radius * 2)
                                  height: 140, // Tinggi gambar (radius * 2)
                                  fit: BoxFit.cover, // Cara gambar di-fit
                                  // placeholderBuilder untuk SVG network
                                  placeholderBuilder:
                                      (BuildContext context) => Container(
                                        padding: const EdgeInsets.all(20),
                                        child: const CircularProgressIndicator(),
                                      ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: AppColors.textWhite, width: 2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(AppIcons.editFill, color: Colors.black, size: 20),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Pipit Lolita',
                          style: TextStyle(
                            color: AppColors.textWhite,
                            // color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 36,
                    right: 8,
                    child: IconButton(
                      icon: Icon(AppIcons.favoriteFill, color: AppColors.textWhite, size: 24),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: -140,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          // borderRadius: BorderRadius.circular(24.0), // Atur radius sudut
                          borderRadius: BorderRadius.circular(12.0), // Atur radius sudut
                        ),
                        color: AppColors.textWhite,
                        elevation: 1,
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(
                                AppIcons.userFill,
                                color: Colors.black,
                                size: 24, // opsional, atur agar pas di lingkaran
                              ),
                              title: Text('Profil Saya'),
                              trailing: Icon(
                                AppIcons.arrowRight,
                                color: AppColors.greyDark,
                                size: 20,
                              ),
                              // subtitle: Text('Deskripsi singkat untuk item ini.'),
                            ),
                            ListTile(
                              leading: Icon(
                                AppIcons.lockFill,
                                color: Colors.black,
                                size: 24, // opsional, atur agar pas di lingkaran
                              ),
                              title: Text('Kelola Kata Sandi'),
                              trailing: Icon(
                                AppIcons.arrowRight,
                                color: AppColors.greyDark,
                                size: 20,
                              ),
                              // subtitle: Text('Deskripsi singkat untuk item ini.'),
                            ),
                            ListTile(
                              leading: Icon(
                                AppIcons.baby,
                                color: Colors.black,
                                size: 24, // opsional, atur agar pas di lingkaran
                              ),
                              title: Text('Kelola Profil Bayi'),
                              trailing: Icon(
                                AppIcons.arrowRight,
                                color: AppColors.greyDark,
                                size: 20,
                              ),
                              // subtitle: Text('Deskripsi singkat untuk item ini.'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ), // Padding untuk status bar
              SizedBox(height: MediaQuery.of(context).padding.top + 90),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        // borderRadius: BorderRadius.circular(24.0), // Atur radius sudut
                        borderRadius: BorderRadius.circular(12.0), // Atur radius sudut
                      ),
                      color: AppColors.textWhite,
                      elevation: 1,
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              AppIcons.favoriteFill,
                              color: Colors.black,
                              size: 24, // opsional, atur agar pas di lingkaran
                            ),
                            title: Text('Resep Favorit'),
                            trailing: Icon(
                              AppIcons.arrowRight,
                              color: AppColors.greyDark,
                              size: 20,
                            ),
                            // subtitle: Text('Deskripsi singkat untuk item ini.'),
                          ),
                          ListTile(
                            leading: Icon(
                              AppIcons.forum,
                              color: Colors.black,
                              size: 24, // opsional, atur agar pas di lingkaran
                            ),
                            title: Text('Postingan yang Disukai'),
                            trailing: Icon(
                              AppIcons.arrowRight,
                              color: AppColors.greyDark,
                              size: 20,
                            ),
                            // subtitle: Text('Deskripsi singkat untuk item ini.'),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        // borderRadius: BorderRadius.circular(24.0), // Atur radius sudut
                        borderRadius: BorderRadius.circular(12.0), // Atur radius sudut
                      ),
                      color: AppColors.textWhite,
                      elevation: 1,
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              AppIcons.notificationFill,
                              color: Colors.black,
                              size: 24, // opsional, atur agar pas di lingkaran
                            ),
                            title: Text('Notifikasi'),
                            trailing: Icon(
                              AppIcons.arrowRight,
                              color: AppColors.greyDark,
                              size: 20,
                            ),
                            // subtitle: Text('Deskripsi singkat untuk item ini.'),
                          ),
                          ListTile(
                            leading: Icon(
                              AppIcons.commentFill,
                              color: Colors.black,
                              size: 24, // opsional, atur agar pas di lingkaran
                            ),
                            title: Text('Bahasa'),
                            trailing: Icon(
                              AppIcons.arrowRight,
                              color: AppColors.greyDark,
                              size: 20,
                            ),
                            // subtitle: Text('Deskripsi singkat untuk item ini.'),
                          ),
                        ],
                      ),
                    ),

                    Card(
                      shape: RoundedRectangleBorder(
                        // borderRadius: BorderRadius.circular(24.0), // Atur radius sudut
                        borderRadius: BorderRadius.circular(12.0), // Atur radius sudut
                      ),
                      color: AppColors.textWhite,
                      elevation: 1,
                      child: Column(
                        children: [
                          GestureDetector(
                            child: ListTile(
                              leading: Icon(
                                AppIcons.logout,
                                color: AppColors.error,
                                size: 24, // opsional, atur agar pas di lingkaran
                              ),
                              title: Text('Keluar', style: TextStyle(color: AppColors.error)),
                              trailing: Icon(AppIcons.arrowRight, color: AppColors.error, size: 20),
                              // subtitle: Text('Deskripsi singkat untuk item ini.'),
                            ),
                            onTap: () {
                              context.read<AuthenticationBloc>().add(LogoutRequested());
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
