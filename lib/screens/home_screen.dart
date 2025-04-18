import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/models/food_model.dart';
import 'package:nutrimpasi/models/baby_model.dart';
import 'package:nutrimpasi/screens/food/cooking_history_screen.dart';
import 'package:nutrimpasi/screens/notification_screen.dart';
import 'package:nutrimpasi/screens/nutritionist_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Data dummy untuk makanan yang direkomendasikan
  final List<Food> _recommendedFoods = Food.dummyFoods.take(5).toList();

  // Controller PageView untuk bayi (vertikal)
  final PageController _babyController = PageController();
  int _currentBabyIndex = 0;

  @override
  void initState() {
    super.initState();
    _babyController.addListener(() {
      if (!_babyController.hasClients ||
          !_babyController.position.hasContentDimensions) {
        return;
      }

      // Mengatur offset dan halaman saat pengguna menggulir
      final double currentOffset = _babyController.offset;
      final double maxScrollExtent = _babyController.position.maxScrollExtent;
      final int currentPageFloor =
          _babyController.page?.floor() ?? _currentBabyIndex;
      final int currentPageRound =
          _babyController.page?.round() ?? _currentBabyIndex;
      const double overscrollThreshold = 50.0;

      // Mengatur halaman bayi saat mencapai batas atas atau bawah
      if (currentPageFloor == babies.length - 1 &&
          currentOffset > maxScrollExtent + overscrollThreshold) {
        if (_currentBabyIndex != 0 &&
            !_babyController.position.isScrollingNotifier.value) {
          _babyController.animateToPage(
            0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _currentBabyIndex != 0) {
              setState(() {
                _currentBabyIndex = 0;
              });
            }
          });
          return;
        }
      }

      // Mengatur halaman bayi saat mencapai batas bawah
      if (currentPageRound != _currentBabyIndex &&
          currentPageRound >= 0 &&
          currentPageRound < babies.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _currentBabyIndex = currentPageRound;
            });
          }
        });
      }
    });
  }

  // Data dummy bayi
  final babies = Baby.dummyBabies;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildFeaturesSection(),
              _buildRecommendationSection(),
            ],
          ),
        ),
      ),
    );
  }

  // Header dengan latar belakang banner dan kartu informasi bayi
  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Latar belakang banner
        Container(
          width: double.infinity,
          height: 300,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/banner/beranda.png'),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo dan nama aplikasi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/logo/nutrimpasi.png',
                        height: 55,
                      ),
                      const Text(
                        'NutriMPASI',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                    ],
                  ),
                  // Tombol notifikasi
                  IconButton(
                    icon: Icon(
                      Symbols.notifications,
                      color: AppColors.textBlack,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Pesan sambutan
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, Moms',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    Text(
                      'Dukung perjalanan makan si kecil\ndengan rekomendasi nutrisi terbaik!',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Kartu informasi bayi bertumpuk
        Positioned(
          top: 140,
          left: 24,
          right: 24,
          child: SizedBox(
            height: 150,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Kartu bertumpuk dengan PageView vertikal untuk scrolling snap
                SizedBox(
                  width: MediaQuery.of(context).size.width - 48,
                  height: 200,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Kartu latar belakang bertumpuk
                      ...List.generate(babies.length, (index) {
                        if (index > _currentBabyIndex &&
                            index <= _currentBabyIndex + 2) {
                          final offset = (index - _currentBabyIndex) * 4.0;
                          final cardWidth =
                              MediaQuery.of(context).size.width -
                              48 -
                              ((index - _currentBabyIndex) * 30.0);
                          final horizontalOffset =
                              (MediaQuery.of(context).size.width -
                                  48 -
                                  cardWidth) /
                              2;

                          return Positioned(
                            top: offset * 2.5,
                            left: horizontalOffset,
                            right: horizontalOffset,
                            child: Opacity(
                              opacity:
                                  1.0 - ((index - _currentBabyIndex) * 0.3),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                width: cardWidth,
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: SizedBox(height: 130),
                                ),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),

                      // PageView kartu bayi utama
                      PageView.builder(
                        controller: _babyController,
                        scrollDirection: Axis.vertical,
                        itemCount: babies.length,
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        itemBuilder: (context, index) {
                          final baby = babies[index];
                          final bool isCurrentItem = index == _currentBabyIndex;

                          return AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: isCurrentItem ? 1.0 : 0.0,
                            child: IgnorePointer(
                              ignoring: !isCurrentItem,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        // Avatar bayi
                                        SizedBox(
                                          width: 120,
                                          height: 120,
                                          child:
                                              babies[index].isProfileComplete
                                                  ? Image.asset(
                                                    babies[index].gender ==
                                                            'Laki-Laki'
                                                        ? 'assets/images/component/bayi_laki_laki.png'
                                                        : 'assets/images/component/bayi_perempuan.png',
                                                    fit: BoxFit.contain,
                                                  )
                                                  : Container(
                                                    decoration: BoxDecoration(
                                                      color: AppColors.buff,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            30,
                                                          ),
                                                    ),
                                                    child: Center(
                                                      child: Image.asset(
                                                        'assets/images/logo/nutrimpasi.png',
                                                        height: 40,
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                    ),
                                                  ),
                                        ),
                                        const SizedBox(width: 16),
                                        // Informasi bayi
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                baby.name,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.textBlack,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              if (baby.isProfileComplete) ...[
                                                // Informasi jenis kelamin
                                                Row(
                                                  children: [
                                                    Icon(
                                                      baby.gender == 'Laki-Laki'
                                                          ? Symbols.male_rounded
                                                          : Symbols
                                                              .female_rounded,
                                                      size: 16,
                                                      color: AppColors.textGrey,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      baby.gender ?? '',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            AppColors.textGrey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                // Informasi usia
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Symbols.update_rounded,
                                                      size: 16,
                                                      color: AppColors.textGrey,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      '${baby.ageInMonths} bulan',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            AppColors.textGrey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                // Informasi alergi
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Symbols.no_meals,
                                                      size: 16,
                                                      color: AppColors.textGrey,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      baby.allergy ??
                                                          'Tidak ada alergi',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            AppColors.textGrey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ] else
                                                InkWell(
                                                  onTap: () {
                                                    // TODO: Navgifasi ke halaman lengkapi profil bayi
                                                    print(
                                                      'Navigate to complete profile for ${baby.name}',
                                                    );
                                                  },
                                                  child: Text(
                                                    'Lengkapi Data Bayi',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          AppColors.secondary,
                                                      decoration:
                                                          TextDecoration
                                                              .underline,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Tombol tambah bayi
                Positioned(
                  right: -24,
                  top: 40,
                  child: InkWell(
                    onTap: () {
                      // Logika tambah bayi
                    },
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(20),
                    ),
                    child: Container(
                      width: 80,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(50),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Symbols.add,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Bagian rekomendasi makanan
  Widget _buildRecommendationSection() {
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul bagian
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rekomendasi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                Icon(
                  Symbols.arrow_forward_ios,
                  size: 16,
                  color: AppColors.secondary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Kartu rekomendasi terkunci
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Gambar makanan terkunci
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.network(
                              _recommendedFoods[0].image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(125),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        Positioned.fill(
                          child: Center(
                            child: Icon(
                              Symbols.lock,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    // Teks informasi
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Buka fitur ini dengan melengkapi\nprofil bayi kamu!',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Bagian carousel fitur lainnya
Widget _buildFeaturesSection() {
  // Data fitur
  final List<Map<String, dynamic>> features = [
    {
      'title': 'Materi Pembelajaran',
      'image': 'assets/images/card/materi_pembelajaran.png',
      'navigate': (BuildContext context) {
        // TODO: Halaman Materi Pembelajaran
      },
    },
    {
      'title': 'Konsultasi Ahli Gizi',
      'image': 'assets/images/card/konsultasi_ahli_gizi.png',
      'navigate': (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NutritionistProfileScreen(),
          ),
        );
      },
    },
    {
      'title': 'Riwayat Memasak',
      'image': 'assets/images/card/riwayat_memasak.png',
      'navigate': (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CookingHistoryScreen()),
        );
      },
    },
    {
      'title': 'Usulan Makanan',
      'image': 'assets/images/card/usulan_makanan.png',
      'navigate': (BuildContext context) {
        // TODO: Halaman Usulan Makanan
      },
    },
    {
      'title': 'Makanan Favorit',
      'image': 'assets/images/card/makanan_favorit.png',
      'navigate': (BuildContext context) {
        // TODO: Halaman Makanan Favorit
      },
    },
  ];

  return Container(
    margin: const EdgeInsets.only(top: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul bagian
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fitur Lainnya',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              Icon(
                Symbols.arrow_forward_ios,
                size: 16,
                color: AppColors.secondary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Carousel kartu fitur
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: features.length,
            itemBuilder: (context, index) {
              final feature = features[index];
              final cardColor =
                  index % 2 == 0 ? AppColors.bisque : AppColors.lavenderBlue;

              return Column(
                children: [
                  // Kartu fitur dengan InkWell
                  InkWell(
                    onTap: () {
                      if (feature['navigate'] != null) {
                        feature['navigate'](context);
                      }
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 140,
                      height: 140,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(50),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          feature['image'],
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Judul fitur
                  SizedBox(
                    width: 140,
                    child: Text(
                      feature['title'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    ),
  );
}
