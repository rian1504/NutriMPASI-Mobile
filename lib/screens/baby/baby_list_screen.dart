import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/models/baby_model.dart';
import 'package:nutrimpasi/screens/baby/baby_edit_screen.dart';
import 'package:nutrimpasi/screens/baby/baby_add_screen.dart';

class BabyListScreen extends StatefulWidget {
  const BabyListScreen({super.key});

  @override
  State<BabyListScreen> createState() => _BabyListScreenState();
}

class _BabyListScreenState extends State<BabyListScreen> {
  // Controller untuk carousel bayi
  final PageController _carouselController = PageController(
    viewportFraction: 0.85,
  );
  int _currentCarouselPage = 0;

  // Data sample bayi
  final List<Baby> _babies = Baby.dummyBabies;

  @override
  void initState() {
    super.initState();
    // Listener untuk update halaman carousel yang aktif
    _carouselController.addListener(() {
      int page = _carouselController.page?.round() ?? 0;
      if (_currentCarouselPage != page) {
        setState(() {
          _currentCarouselPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE1BE),
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(8),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo/nutrimpasi.png', height: 40),
            const SizedBox(width: 4),
            const Text(
              'NutriMPASI',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(width: 24),
          ],
        ),
        centerTitle: true,
        actions: [const SizedBox(width: 48)],
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian utama dengan latar belakang gradient
          Expanded(
            child: Stack(
              children: [
                // Background dengan dua bagian: gradient 50% di atas, putih 50% di bawah
                Column(
                  children: [
                    // Bagian gradient (50% atas)
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.05, 0.41, 0.72, 1.0],
                            colors: [
                              Color(0xFFFFE1BE),
                              Color(0xFFFFC698),
                              Color(0xFFFFAC84),
                              Color(0xFFFF7F53),
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    // Bagian putih (50% bawah)
                    Expanded(flex: 1, child: Container(color: Colors.white)),
                  ],
                ),

                // Konten utama (overlay di atas background)
                Column(
                  children: [
                    const SizedBox(height: 48),
                    // Judul halaman
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Kelola Profil Bayi Anda',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textBlack,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tambahkan atau edit data bayi untuk mendapatkan rekomendasi makanan yang lebih sesuai.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textGrey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                    // PageView untuk carousel bayi
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 420,
                            child: PageView.builder(
                              controller: _carouselController,
                              itemCount: _babies.length + 1,
                              itemBuilder: (context, index) {
                                final bool isCurrentItem =
                                    _currentCarouselPage == index;

                                // Kartu tambah bayi baru
                                if (index == _babies.length) {
                                  return _buildAddBabyCard(isCurrentItem);
                                }

                                // Kartu profil bayi
                                final baby = _babies[index];
                                return _buildBabyCard(baby, isCurrentItem);
                              },
                            ),
                          ),
                          // Memberikan jarak yang cukup agar shadow tidak terpotong
                          const SizedBox(height: 24),
                          // Indikator dot untuk carousel (pagination)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _babies.length + 1,
                              (index) => Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      _currentCarouselPage == index
                                          ? AppColors.primary
                                          : AppColors.componentGrey!.withAlpha(
                                            125,
                                          ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      // Tombol tambah bayi floating
      floatingActionButton:
          _currentCarouselPage == _babies.length
              ? null
              : FloatingActionButton(
                onPressed: () {
                  // Navigasi ke kartu tambah bayi
                  _carouselController.animateToPage(
                    _babies.length,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                backgroundColor: AppColors.secondary,
                child: const Icon(Symbols.add, color: Colors.white),
              ),
    );
  }

  // Widget untuk kartu profil bayi
  Widget _buildBabyCard(Baby baby, bool isCurrentItem) {
    return Container(
      // Menambahkan padding di luar container utama untuk shadow
      padding: const EdgeInsets.only(bottom: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: isCurrentItem ? 0 : 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(200),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header dengan nama dan tombol edit
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    baby.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  // Tombol edit
                  IconButton(
                    icon: const Icon(Symbols.edit_rounded),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BabyEditScreen(baby: baby),
                        ),
                      ).then((_) {
                        setState(() {});
                      });
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.secondary.withAlpha(25),
                      foregroundColor: AppColors.secondary,
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Konten utama dengan gambar dan informasi
              Expanded(
                child: Row(
                  children: [
                    // Gambar bayi
                    Container(
                      width: 125,
                      height: 200,
                      decoration: BoxDecoration(
                        color:
                            baby.gender == 'Laki-Laki'
                                ? AppColors.lavenderBlue.withAlpha(125)
                                : AppColors.bisque.withAlpha(125),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child:
                            baby.isProfileComplete
                                ? Image.asset(
                                  baby.gender == 'Laki-Laki'
                                      ? 'assets/images/component/bayi_laki_laki.png'
                                      : 'assets/images/component/bayi_perempuan.png',
                                  fit: BoxFit.contain,
                                  height: 150,
                                )
                                : Image.asset(
                                  'assets/images/logo/nutrimpasi.png',
                                  height: 50,
                                  color: AppColors.primary,
                                ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Informasi bayi
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildInfoRow(
                            Symbols.cake,
                            'Usia',
                            getAgeDisplay(baby),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Symbols.height_rounded,
                            'Tinggi Badan',
                            '${baby.height ?? '-'} cm',
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Symbols.scale_rounded,
                            'Berat Badan',
                            '${baby.weight ?? '-'} kg',
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Symbols.no_meals,
                            'Alergi',
                            baby.allergy ?? 'Tidak ada',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Tombol aksi di bagian bawah
              const SizedBox(height: 16),
              Row(
                children: [
                  // Tombol hapus profil
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implementasi hapus profil bayi
                        _showDeleteConfirmation(baby);
                      },
                      icon: const Icon(Symbols.delete_outline, size: 16),
                      label: const Text(
                        'Hapus Profil',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Tombol lihat riwayat
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implementasi lihat riwayat bayi
                      },
                      icon: const Icon(Symbols.history, size: 16),
                      label: const Text(
                        'Riwayat',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk kartu tambah bayi baru
  Widget _buildAddBabyCard(bool isCurrentItem) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: isCurrentItem ? 0 : 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(200),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ikon dan judul
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.bisque,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Symbols.child_care,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Tambah Profil Bayi Baru',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Tambahkan data bayi untuk mendapatkan rekomendasi makanan yang sesuai dengan kebutuhan si kecil',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textGrey),
              ),
            ),
            const SizedBox(height: 32),
            // Tombol tambah
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BabyAddScreen(),
                  ),
                ).then((_) {
                  setState(() {});
                });
              },
              icon: const Icon(Symbols.add),
              label: const Text('Tambah Bayi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk baris informasi bayi
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textGrey),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textGrey.withAlpha(200),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textBlack,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Fungsi untuk menghitung dan menampilkan usia bayi dalam bulan
  String getAgeDisplay(Baby baby) {
    if (baby.birthDate == null) return '- bulan';

    final now = DateTime.now();
    final months =
        (now.year - baby.birthDate!.year) * 12 +
        now.month -
        baby.birthDate!.month;

    if (now.day < baby.birthDate!.day) {
      return '${months - 1} bulan';
    }

    return '$months bulan';
  }

  // Dialog konfirmasi hapus bayi
  void _showDeleteConfirmation(Baby baby) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Anda yakin ingin menghapus Profil Bayi ini?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tombol Batal
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.componentBlack,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Batal'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Tombol Hapus
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            // TODO: Implementasi hapus bayi
                            Navigator.pop(context);
                          },
                          child: const Text('Hapus'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
