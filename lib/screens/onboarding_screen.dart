import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/screens/auth/login_screen.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Controller PageView untuk slide onboarding
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Data konten onboarding
  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Jadwal',
      'subtitle': 'Memasak',
      'description':
          'Atur jadwal MPASI dengan mudah! Rencanakan menu harian, atur porsi, dan pastikan bayi Anda mendapatkan nutrisi terbaik setiap saat.',
      'image': 'assets/images/background/onboarding_1.png',
    },
    {
      'title': 'Usulan',
      'subtitle': 'Makanan',
      'description':
          'Punya resep MPASI favorit? Bagikan kreasi terbaik Anda, jelajahi ide baru, dan bantu ibu lainnya menemukan inspirasi menu sehat untuk si kecil!',
      'image': 'assets/images/background/onboarding_2.png',
    },
    {
      'title': 'Riwayat',
      'subtitle': 'Masakan',
      'description':
          'Pantau riwayat MPASI si kecil! Lihat makanan yang dikonsumsi, hitung gizi otomatis, dan bandingkan asupan nutrisi setiap bulannya.',
      'image': 'assets/images/background/onboarding_3.png',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.porcelain,
      body: Stack(
        children: [
          // PageView untuk halaman onboarding
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              return OnboardingPage(
                title: _onboardingData[index]['title']!,
                subtitle: _onboardingData[index]['subtitle']!,
                description: _onboardingData[index]['description']!,
                image: _onboardingData[index]['image']!,
                currentPage: _currentPage,
                totalPages: _onboardingData.length,
                pageController: _pageController,
              );
            },
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final String image;
  final int currentPage;
  final int totalPages;
  final PageController pageController;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.image,
    required this.currentPage,
    required this.totalPages,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Bagian konten teks dan tombol
        Positioned(
          top: size.height * 0.6,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                22,
                32,
                22,
                MediaQuery.of(context).padding.bottom + 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Judul utama
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: AppColors.accent,
                          height: 1.2,
                        ),
                      ),
                      // Subjudul
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  // Teks deskripsi
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'TTInterphases',
                      fontSize: 16,
                      color: AppColors.textGrey,
                      height: 1.5,
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: CircularProgressIndicator(
                          value: (currentPage + 1) / totalPages,
                          backgroundColor: const Color(0xFFE0E0E0),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                          strokeWidth: 3,
                        ),
                      ),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            if (currentPage < totalPages - 1) {
                              pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                          icon: const Icon(
                            Symbols.arrow_forward,
                            color: Colors.white,
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

        // Gambar ilustrasi
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: size.height * 0.63,
          child: Image.asset(image, width: double.infinity),
        ),

        // Tombol kembali
        if (currentPage > 0)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: ElevatedButton(
              onPressed: () {
                pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(8),
                minimumSize: const Size(42, 42),
                elevation: 1,
              ),
              child: const Icon(
                Symbols.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),

        // Tombol lewati - hanya tampil pada halaman pertama dan kedua
        if (currentPage < totalPages - 1)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: SmallButton(
              text: "Lewati",
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ),
      ],
    );
  }
}
