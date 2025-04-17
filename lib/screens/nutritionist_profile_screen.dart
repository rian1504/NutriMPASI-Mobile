import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/models/nutritionist_model.dart';

class NutritionistProfileScreen extends StatefulWidget {
  const NutritionistProfileScreen({super.key});

  @override
  State<NutritionistProfileScreen> createState() =>
      _NutritionistProfileScreenState();
}

class _NutritionistProfileScreenState extends State<NutritionistProfileScreen> {
  // Controller untuk carousel ahli gizi
  final PageController _carouselController = PageController(
    viewportFraction: 0.7,
  );
  int _currentCarouselPage = 0;

  // Data sample ahli gizi
  final List<Nutritionist> _nutritionists = Nutritionist.sampleNutritionists;

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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tombol kembali (back button)
            IconButton(
              icon: const Icon(Symbols.arrow_back),
              onPressed: () => Navigator.pop(context),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8),
              ),
            ),
            // Bagian header dengan teks informasi
            Container(
              color: AppColors.bisque,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Judul halaman
                      const Text(
                        'Temukan dan Hubungi\nAhli Gizi Pilihanmu!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Deskripsi layanan
                      Text(
                        'Lihat profil lengkap ahli gizi yang terdaftar. Hubungi langsung untuk berkonsultasi dan dapatkan saran terbaik untuk memenuhi kebutuhan gizi si kecil!',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textGrey,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Bagian utama dengan latar belakang gradient
            Expanded(
              child: Container(
                color: AppColors.white,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
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
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.elliptical(100, 70),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      children: [
                        // Container untuk carousel gambar ahli gizi
                        Container(
                          margin: const EdgeInsets.only(top: 48, left: 48),
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          height: 360,
                          decoration: BoxDecoration(
                            color: AppColors.offWhite,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.elliptical(90, 57),
                              bottomLeft: Radius.circular(15),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // PageView untuk carousel gambar ahli gizi
                              Expanded(
                                child: PageView.builder(
                                  controller: _carouselController,
                                  itemCount: _nutritionists.length,
                                  itemBuilder: (context, index) {
                                    final bool isCurrentItem =
                                        _currentCarouselPage == index;

                                    // Item carousel dengan animasi
                                    return AnimatedContainer(
                                      alignment: Alignment.centerLeft,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInOut,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                      ),
                                      margin: EdgeInsets.only(
                                        top: isCurrentItem ? 0 : 36,
                                        bottom: isCurrentItem ? 0 : 36,
                                        right: 48,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  isCurrentItem
                                                      ? Colors.black26
                                                      : Colors.black12,
                                              blurRadius:
                                                  isCurrentItem ? 10 : 5,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        // Gambar ahli gizi
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          child: Image.asset(
                                            _nutritionists[index].gender ==
                                                    'male'
                                                ? 'assets/images/component/ahli_gizi_laki_laki.png'
                                                : 'assets/images/component/ahli_gizi_perempuan.png',
                                            fit: BoxFit.contain,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return Container(
                                                color: AppColors.componentGrey,
                                                child: const Icon(
                                                  Symbols.person,
                                                  size: 80,
                                                  color: AppColors.textGrey,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 8),
                              // Indikator dot untuk carousel (pagination)
                              Container(
                                margin: const EdgeInsets.only(right: 48),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    _nutritionists.length,
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
                                                : AppColors.componentGrey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 48),
                        // Card informasi detail ahli gizi
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 48),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                // Header profil ahli gizi
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Foto profil ahli gizi
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.asset(
                                        _nutritionists[_currentCarouselPage]
                                            .image,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Container(
                                            color: AppColors.componentGrey,
                                            child: const Icon(
                                              Symbols.person,
                                              size: 50,
                                              color: AppColors.textGrey,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    // Informasi nama dan spesialisasi
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _nutritionists[_currentCarouselPage]
                                                .name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textBlack,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(
                                                Symbols.medical_services,
                                                size: 16,
                                                color: AppColors.textGrey,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                _nutritionists[_currentCarouselPage]
                                                    .specialization,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.textGrey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                // Tombol WhatsApp untuk kontak ahli gizi
                                if (_nutritionists[_currentCarouselPage]
                                    .hasWhatsapp)
                                  Container(
                                    margin: EdgeInsets.only(top: 16),
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF25D366,
                                        ),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        minimumSize: const Size(
                                          double.infinity,
                                          46,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/logo/whatsapp.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Hubungi via WhatsApp',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
