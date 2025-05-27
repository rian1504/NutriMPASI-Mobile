import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/baby_food_recommendation.dart';
import 'package:nutrimpasi/screens/food/food_detail_screen.dart';

class FoodRecommendationScreen extends StatefulWidget {
  final List<BabyFoodRecommendation> recommendedFoods;

  const FoodRecommendationScreen({super.key, required this.recommendedFoods});

  @override
  State<FoodRecommendationScreen> createState() =>
      _FoodRecommendationScreenState();
}

class _FoodRecommendationScreenState extends State<FoodRecommendationScreen> {
  // Controller scroll
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Rekomendasi',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 3,
            shadowColor: Colors.black54,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                icon: const Icon(
                  Symbols.arrow_back_ios_new_rounded,
                  color: AppColors.textBlack,
                  size: 24,
                ),
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      ),
      // Container dengan gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.7, 0.9],
            colors: [AppColors.pearl, AppColors.bisque, AppColors.primary],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // Jarak dari AppBar
                const SizedBox(height: 16),

                // Daftar rekomendasi makanan
                Expanded(
                  child:
                      widget.recommendedFoods.isEmpty
                          ? const Center(
                            child: Text(
                              'Belum ada rekomendasi tersedia',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textGrey,
                              ),
                            ),
                          )
                          : ListView.builder(
                            controller: _scrollController,
                            itemCount: widget.recommendedFoods.length,
                            itemBuilder: (context, index) {
                              final item = widget.recommendedFoods[index];
                              final food = widget.recommendedFoods[index].food;

                              // Card rekomendasi makanan
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              FoodDetailScreen(foodId: food.id),
                                    ),
                                  );
                                },
                                child: Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        // Gambar makanan
                                        Image.network(
                                          storageUrl + food.image,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Container(
                                              width: 100,
                                              height: 100,
                                              color: AppColors.cream,
                                              child: const Icon(
                                                Icons.image_not_supported,
                                                color: AppColors.textGrey,
                                              ),
                                            );
                                          },
                                        ),

                                        // Informasi makanan
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                              vertical: 8.0,
                                            ),
                                            child: Row(
                                              children: [
                                                // Kolom untuk judul dan deskripsi
                                                Expanded(
                                                  flex: 5,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          right: 8.0,
                                                        ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        // Nama makanan
                                                        Text(
                                                          food.name,
                                                          style: const TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                AppColors
                                                                    .textBlack,
                                                          ),
                                                          maxLines: 2,
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),

                                                        // Deskripsi singkat
                                                        Text(
                                                          item.reason,
                                                          style: const TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 12,
                                                            color:
                                                                AppColors
                                                                    .textGrey,
                                                          ),
                                                          maxLines: 3,
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          textAlign:
                                                              TextAlign.justify,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                // Kolom untuk indikator sumber
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    // Indikator sumber
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .secondary
                                                            .withAlpha(25),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Image.asset(
                                                        food.source == 'WHO'
                                                            ? 'assets/images/icon/source_who.png'
                                                            : food.source ==
                                                                'KEMENKES'
                                                            ? 'assets/images/icon/source_kemenkes.png'
                                                            : 'assets/images/icon/source_pengguna.png',
                                                        width: 16,
                                                        height: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
