import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/blocs/nutritionist/nutritionist_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/nutritionist.dart';
import 'package:nutrimpasi/utils/flushbar.dart';
import 'package:url_launcher/url_launcher.dart';

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

  // Data ahli gizi
  List<Nutritionist> _nutritionists = [];

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

    // Load data
    context.read<NutritionistBloc>().add(FetchNutritionists());
  }

  @override
  void dispose() {
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan tombol back
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Material(
                  elevation: 5,
                  shadowColor: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(
                        AppIcons.back,
                        color: AppColors.white,
                        size: 24,
                      ),
                      iconSize: 24,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
              // Bagian header dengan teks informasi
              Container(
                color: AppColors.primary,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Judul halaman
                        const Text(
                          'Temukan dan Hubungi\nAhli Gizi Pilihanmu!',
                          style: TextStyle(
                            fontSize: 24,
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
              Container(
                color: Colors.white,
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.1, 0.7, 0.9],
                      colors: [
                        AppColors.primary,
                        AppColors.bisque,
                        AppColors.background,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.elliptical(100, 70),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: BlocBuilder<NutritionistBloc, NutritionistState>(
                      builder: (context, state) {
                        // Mengambil data ahli gizi dari state
                        if (state is NutritionistLoaded) {
                          _nutritionists = state.nutritionists;
                        }

                        return Column(
                          children: [
                            // Container untuk carousel gambar ahli gizi
                            Container(
                              margin: const EdgeInsets.only(top: 48, left: 48),
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              height: 360,
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                              child:
                                  state is NutritionistLoading
                                      ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                      : state is NutritionistError
                                      ? Center(child: Text(state.error))
                                      : state is NutritionistLoaded &&
                                          _nutritionists.isNotEmpty
                                      ? Column(
                                        children: [
                                          // PageView untuk carousel gambar ahli gizi
                                          SizedBox(
                                            height: 280,
                                            child: PageView.builder(
                                              controller: _carouselController,
                                              itemCount: _nutritionists.length,
                                              itemBuilder: (context, index) {
                                                final bool isCurrentItem =
                                                    _currentCarouselPage ==
                                                    index;

                                                // Item carousel dengan animasi
                                                return AnimatedContainer(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  duration: const Duration(
                                                    milliseconds: 300,
                                                  ),
                                                  curve: Curves.easeInOut,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 12.0,
                                                      ),
                                                  margin: EdgeInsets.only(
                                                    top: isCurrentItem ? 0 : 36,
                                                    bottom:
                                                        isCurrentItem ? 0 : 36,
                                                    right: 48,
                                                  ),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                            Radius.circular(30),
                                                          ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              isCurrentItem
                                                                  ? Colors
                                                                      .black26
                                                                  : Colors
                                                                      .black12,
                                                          blurRadius:
                                                              isCurrentItem
                                                                  ? 10
                                                                  : 5,
                                                          offset: const Offset(
                                                            0,
                                                            2,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    // Gambar ahli gizi
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                            Radius.circular(30),
                                                          ),
                                                      child: Image.asset(
                                                        _nutritionists[index]
                                                                    .gender ==
                                                                'L'
                                                            ? 'assets/images/component/ahli_gizi_laki_laki.png'
                                                            : 'assets/images/component/ahli_gizi_perempuan.png',
                                                        fit: BoxFit.contain,
                                                        errorBuilder: (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) {
                                                          return Container(
                                                            color:
                                                                AppColors
                                                                    .componentGrey,
                                                            child: const Icon(
                                                              Symbols.person,
                                                              size: 80,
                                                              color:
                                                                  AppColors
                                                                      .textGrey,
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
                                          if (_nutritionists.isNotEmpty)
                                            Container(
                                              margin: const EdgeInsets.only(
                                                right: 48,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: List.generate(
                                                  _nutritionists.length,
                                                  (index) => Container(
                                                    width: 8,
                                                    height: 8,
                                                    margin:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          _currentCarouselPage ==
                                                                  index
                                                              ? AppColors
                                                                  .primary
                                                              : AppColors
                                                                  .componentGrey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      )
                                      : const Center(
                                        child: Text('Tidak ada data ahli gizi'),
                                      ),
                            ),

                            const SizedBox(height: 48),

                            // Card informasi detail ahli gizi
                            if (state is NutritionistLoaded &&
                                _nutritionists.isNotEmpty &&
                                _currentCarouselPage < _nutritionists.length)
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 48,
                                ),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Foto profil ahli gizi
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                            child: Image.network(
                                              storageUrl +
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
                                                  color:
                                                      AppColors.componentGrey,
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
                                                    Expanded(
                                                      child: Text(
                                                        _nutritionists[_currentCarouselPage]
                                                            .specialist,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              AppColors
                                                                  .textGrey,
                                                        ),
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
                                          .telp
                                          .isNotEmpty)
                                        Container(
                                          margin: EdgeInsets.only(top: 16),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _launchWhatsApp(
                                                _nutritionists[_currentCarouselPage]
                                                    .telp,
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF25D366,
                                              ),
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                                                  width: 24,
                                                  height: 24,
                                                ),
                                                const SizedBox(width: 8),
                                                Flexible(
                                                  child: const Text(
                                                    'Hubungi via WhatsApp',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchWhatsApp(String phoneNumber) async {
    // Format nomor telepon: hapus semua karakter non-digit
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    // Buat URL WhatsApp
    final url = 'https://wa.me/$cleanedNumber';

    try {
      // Langsung launch URL
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        // Tampilkan flushbar jika terjadi error
        AppFlushbar.showError(
          context,
          title: 'Error',
          message: 'Tidak dapat membuka WhatsApp: ${e.toString()}',
        );
      }
    }
  }
}
