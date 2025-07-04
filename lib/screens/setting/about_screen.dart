import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
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
    return Scaffold(
      backgroundColor: AppColors.background,
      // AppBar
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        // Tombol kembali
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 5,
            shadowColor: Colors.black54,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(
                  Symbols.arrow_back_ios_new_rounded,
                  color: AppColors.textBlack,
                  size: 24,
                ),
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
        title: const Text(
          'Tentang NutriMPASI',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Lingkaran besar di belakang
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(50),
                            offset: const Offset(0, 8),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Lataran bawah dengan warna primer
                Container(
                  width: double.infinity,
                  height: 125,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(50),
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),

                // Lingkaran besar di depan (warna primer)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),

                // Logo aplikasi di tengah lingkaran
                Positioned(
                  top: 25,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(25),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      // Logo Politeknik
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/logo/nutrimpasi.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 100),

            // Konten utama tentang aplikasi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                margin: const EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(15),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul aplikasi
                      const Center(
                        child: Text(
                          'NutriMPASI',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Versi aplikasi
                      Center(
                        child: Text(
                          'Versi $appVersion',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.greyDark,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Deskripsi aplikasi
                      const Text(
                        'Tentang Aplikasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'NutriMPASI adalah aplikasi panduan makanan pendamping ASI yang merupakan hasil proyek PBL (Project Based Learning) dari Politeknik Negeri Batam. Aplikasi ini dibuat khusus untuk membantu para ibu dalam memberikan nutrisi terbaik untuk bayi usia 6-24 bulan.\n\nSebagai solusi inovatif dalam bidang kesehatan bayi, NutriMPASI dirancang untuk memudahkan ibu dalam menyiapkan makanan bergizi, memantau perkembangan bayi, dan berbagi pengalaman dengan komunitas ibu lainnya. Dengan fitur resep MPASI sehat, pemantauan pertumbuhan, forum diskusi, dan pengingat jadwal makan, NutriMPASI hadir sebagai solusi terpadu untuk kebutuhan nutrisi bayi Anda.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textBlack,
                        ),
                        textAlign: TextAlign.justify,
                      ),

                      const SizedBox(height: 24),

                      // Tim pengembang
                      const Text(
                        'Tim Pengembang',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),

                      const SizedBox(height: 8),

                      _buildDeveloperItem(
                        context,
                        'Rian Abdullah',
                        'NIM: 3312301003',
                        'Ketua - Backend Web dan Mobile, Database',
                      ),

                      _buildDeveloperItem(
                        context,
                        'Lea Antony',
                        'NIM: 3312301001',
                        'Anggota - Frontend Web dan Mobile',
                      ),

                      _buildDeveloperItem(
                        context,
                        'Firmansyah Pramudia Ariyanto',
                        'NIM: 3312301030',
                        'Anggota - Frontend dan Prototype',
                      ),

                      _buildDeveloperItem(
                        context,
                        'Pipit Lolita Hapsari',
                        'NIM: 3312301007',
                        'Anggota - Frontend dan UI/UX',
                      ),

                      const SizedBox(height: 24),

                      // Manajer proyek
                      const Text(
                        'Manajer Proyek',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),

                      const SizedBox(height: 8),

                      _buildMentorItem(
                        context,
                        'Sartikha, S.ST., M.Eng',
                        'NIK: 113115',
                      ),

                      const SizedBox(height: 24),

                      // Logo Politeknik dan Jurusan
                      const Text(
                        'Institusi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Baris untuk logo Politeknik dan Jurusan
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo Politeknik
                          Column(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(25),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  'assets/images/logo/polibatam.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Politeknik Negeri Batam',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(width: 20),

                          // Logo Jurusan
                          Column(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(25),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  'assets/images/logo/prodi_if.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Teknik Informatika',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Copyright
                      const Center(
                        child: Text(
                          '© 2025 Politeknik Negeri Batam',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.greyDark,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Kontak
                      const Center(
                        child: Text(
                          'Hubungi kami: nutrimpasi@gmail.com',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.greyDark,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan item pengembang
  Widget _buildDeveloperItem(
    BuildContext context,
    String name,
    String nim,
    String role,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(50),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: AppColors.primary, size: 20),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack,
                  ),
                ),
                Text(
                  nim,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.greyDark,
                  ),
                ),
                Text(
                  role,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan item manajer proyek
  Widget _buildMentorItem(BuildContext context, String name, String id) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: AppColors.accent.withAlpha(50),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.school, color: AppColors.accent, size: 20),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack,
                  ),
                ),
                Text(
                  id,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.accent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
