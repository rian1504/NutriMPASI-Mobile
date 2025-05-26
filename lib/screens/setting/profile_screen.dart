// Nama file: profile_screen.dart
// Deskripsi: File ini adalah halaman profil pengguna dalam aplikasi Nutrimpasi.
// Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// Tanggal: 26 Mei 2025

import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart';
import 'package:nutrimpasi/widgets/profile_app_bar.dart' show AppBarProfile;

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  color: AppColors.primary,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/profile/profile_picture.jpg',
                                ), // Ganti dengan gambar xprofil yang sesuai
                                fit: BoxFit.cover,
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
                      SizedBox(height: 16),
                      Text(
                        'Pipit Lolita',
                        style: TextStyle(
                          color: AppColors.textWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(AppIcons.favorite, color: AppColors.textWhite, size: 24),
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
                          trailing: Icon(AppIcons.arrowRight, color: AppColors.greyDark, size: 20),
                          // subtitle: Text('Deskripsi singkat untuk item ini.'),
                        ),
                        ListTile(
                          leading: Icon(
                            AppIcons.forum,
                            color: Colors.black,
                            size: 24, // opsional, atur agar pas di lingkaran
                          ),
                          title: Text('Postingan yang Disukai'),
                          trailing: Icon(AppIcons.arrowRight, color: AppColors.greyDark, size: 20),
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
                          trailing: Icon(AppIcons.arrowRight, color: AppColors.greyDark, size: 20),
                          // subtitle: Text('Deskripsi singkat untuk item ini.'),
                        ),
                        ListTile(
                          leading: Icon(
                            AppIcons.commentFill,
                            color: Colors.black,
                            size: 24, // opsional, atur agar pas di lingkaran
                          ),
                          title: Text('Bahasa'),
                          trailing: Icon(AppIcons.arrowRight, color: AppColors.greyDark, size: 20),
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
                            AppIcons.logout,
                            color: AppColors.error,
                            size: 24, // opsional, atur agar pas di lingkaran
                          ),
                          title: Text('Keluar', style: TextStyle(color: AppColors.error)),
                          trailing: Icon(AppIcons.arrowRight, color: AppColors.error, size: 20),
                          // subtitle: Text('Deskripsi singkat untuk item ini.'),
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
    );
  }
}
