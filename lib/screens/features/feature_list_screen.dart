import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/main.dart';
import 'package:nutrimpasi/screens/features/learning_material_screen.dart';
import 'package:nutrimpasi/screens/food/cooking_history_screen.dart';
import 'package:nutrimpasi/screens/features/nutritionist_profile_screen.dart';
import 'package:nutrimpasi/screens/setting/favorite_recipe_screen.dart';

class FeatureListScreen extends StatelessWidget {
  const FeatureListScreen({super.key});

  // Fungsi untuk navigasi ke halaman daftar makanan
  void _navigateToFoodList(
    BuildContext context, {
    bool showUserSuggestions = false,
  }) {
    final MainPageState? mainPage =
        context.findAncestorStateOfType<MainPageState>();

    if (mainPage != null) {
      Navigator.pop(context);
      mainPage.changePage(
        1,
        additionalParams: {'showUserSuggestions': showUserSuggestions},
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder:
              (context) => MainPage(
                initialPage: 1,
                additionalParams: {'showUserSuggestions': showUserSuggestions},
              ),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Data fitur yang sama dengan yang ada di home screen
    final List<Map<String, dynamic>> features = [
      {
        'title': 'Materi Pembelajaran',
        'image': 'assets/images/card/materi_pembelajaran.png',
        'navigate': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LearningMaterialScreen(),
            ),
          );
        },
        'description': 'Pelajari berbagai informasi seputar nutrisi untuk bayi',
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
        'description': 'Konsultasi dengan ahli gizi terpercaya',
      },
      {
        'title': 'Riwayat Memasak',
        'image': 'assets/images/card/riwayat_memasak.png',
        'navigate': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CookingHistoryScreen(),
            ),
          );
        },
        'description': 'Lihat riwayat resep yang sudah kamu masak',
      },
      {
        'title': 'Usulan Makanan',
        'image': 'assets/images/card/usulan_makanan.png',
        'navigate': (BuildContext context) {
          _navigateToFoodList(context, showUserSuggestions: true);
        },
        'description': 'Daftar resep makanan yang telah Anda buat',
      },
      {
        'title': 'Makanan Favorit',
        'image': 'assets/images/card/makanan_favorit.png',
        'navigate': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FavoriteRecipeScreen(),
            ),
          );
        },
        'description': 'Kumpulan resep makanan favorit untuk bayi',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Fitur Lainnya',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false, // Remove default back button
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 5,
            shadowColor: Colors.black54,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(
                  Symbols.arrow_back_ios_new_rounded,
                  color: AppColors.white,
                  size: 24,
                ),
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.7, 0.9],
            colors: [AppColors.background, AppColors.bisque, AppColors.primary],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: ListView.builder(
            itemCount: features.length,
            itemBuilder: (context, index) {
              final feature = features[index];
              final backgroundColor =
                  index % 2 == 0 ? AppColors.bisque : AppColors.lavenderBlue;
              return Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    onTap: () {
                      if (feature['navigate'] != null) {
                        feature['navigate'](context);
                      }
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            // Feature Image
                            SizedBox(
                              width: 70,
                              height: 70,
                              child: Image.asset(
                                feature['image'],
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Feature Title and Description
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    feature['title'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textBlack,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    feature['description'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textGrey,
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
        ),
      ),
    );
  }
}
