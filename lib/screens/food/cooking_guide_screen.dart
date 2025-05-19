import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/blocs/food_cooking/food_cooking_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/main.dart';

class CookingGuideScreen extends StatefulWidget {
  final String foodId;
  final List<String> babyId;
  final String? scheduleId;

  const CookingGuideScreen({
    super.key,
    required this.foodId,
    required this.babyId,
    this.scheduleId,
  });

  @override
  State<CookingGuideScreen> createState() => _CookingGuideScreenState();
}

class _CookingGuideScreenState extends State<CookingGuideScreen> {
  // Toggle untuk tampilan bahan dan langkah
  bool _showIngredients = true;

  @override
  void initState() {
    super.initState();

    // Ambil data cooking guide makanan
    context.read<FoodCookingBloc>().add(
      FetchFoodCooking(foodId: widget.foodId, babyId: widget.babyId),
    );
  }

  // Method untuk menampilkan dialog konfirmasi keluar
  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                content: const Text(
                  'Anda yakin ingin keluar dari Panduan Memasak?',
                  textAlign: TextAlign.center,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                actions: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.componentBlack!,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Batal'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Keluar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FoodCookingBloc, FoodCookingState>(
      listener: (context, state) {
        if (state is FoodCookingComplete) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Memasak berhasil diselesaikan')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      MainPage(initialPage: 1), // 1 untuk FoodListingScreen
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is FoodCookingLoading) {
          return Scaffold(
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator()],
              ),
            ),
          );
        }

        if (state is FoodCookingError) {
          return Center(child: Text(state.error));
        }

        if (state is FoodCookingLoaded) {
          final food = state.foodCooking.foodCookingGuide;

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;

              final shouldPop = await _showExitConfirmationDialog();
              if (shouldPop) {
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: Scaffold(
              body: Stack(
                children: [
                  // Gambar latar belakang
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(storageUrl + food.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Tombol kembali
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 16,
                    left: 16,
                    child: Padding(
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
                            onPressed: () async {
                              final shouldPop =
                                  await _showExitConfirmationDialog();
                              if (shouldPop) {
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Panel detail resep
                  DraggableScrollableSheet(
                    initialChildSize: 0.6,
                    minChildSize: 0.6,
                    maxChildSize: 0.9,
                    builder: (context, scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(50),
                              spreadRadius: 5,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Indikator panel
                              Center(
                                child: Container(
                                  height: 5,
                                  width: 75,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.componentGrey,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              // Judul makanan
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                ),
                                child: Text(
                                  food.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textBlack,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Informasi porsi dan riwayat
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: 125,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/icon/set_makanan.png',
                                          width: 20,
                                          height: 20,
                                          color: AppColors.primary,
                                        ),
                                        const SizedBox(width: 4),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '1 Set ',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.textBlack,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '(${food.portion} Porsi)',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.textBlack,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Container(
                                      height: 40,
                                      width: 1,
                                      color: AppColors.textBlack.withAlpha(75),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/icon/jumlah_dimasak.png',
                                        width: 20,
                                        height: 20,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${food.foodRecordCount}x dimasak',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Tab bahan dan langkah
                              Container(
                                color: AppColors.buff,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _showIngredients = true;
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 8),
                                            Text(
                                              'Bahan-bahan',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight:
                                                    _showIngredients
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                color:
                                                    _showIngredients
                                                        ? AppColors.textBlack
                                                        : AppColors.textGrey,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              height: 2,
                                              width: double.infinity,
                                              color:
                                                  _showIngredients
                                                      ? AppColors.textBlack
                                                      : Colors.transparent,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _showIngredients = false;
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 8),
                                            Text(
                                              'Langkah Penyajian',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight:
                                                    !_showIngredients
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                color:
                                                    !_showIngredients
                                                        ? AppColors.textBlack
                                                        : AppColors.textGrey,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              height: 2,
                                              width: double.infinity,
                                              color:
                                                  !_showIngredients
                                                      ? AppColors.textBlack
                                                      : Colors.transparent,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Konten bahan atau langkah
                              if (_showIngredients) ...[
                                // Daftar bahan-bahan
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0,
                                    vertical: 8.0,
                                  ),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: food.recipe.length,
                                    itemBuilder: (context, index) {
                                      final ingredient = food.recipe[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 16,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '${index + 1}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(child: Text(ingredient)),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                // Bagian daftar buah
                                if (food.fruit.isNotEmpty) ...[
                                  const SizedBox(height: 16),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 24.0,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.componentGrey!,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.buff,
                                            borderRadius:
                                                const BorderRadius.only(
                                                  topLeft: Radius.circular(7),
                                                  topRight: Radius.circular(7),
                                                ),
                                          ),
                                          child: const Text(
                                            'Buah',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: food.fruit.length,
                                          padding: const EdgeInsets.all(16),
                                          itemBuilder: (context, index) {
                                            final fruit = food.fruit[index];
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 8,
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 24,
                                                    height: 24,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primary,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        '${index + 1}',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(child: Text(fruit)),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ] else ...[
                                // Daftar langkah penyajian
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0,
                                    vertical: 8.0,
                                  ),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: food.step.length,
                                    itemBuilder: (context, index) {
                                      final step = food.step[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 16,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '${index + 1}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(child: Text(step)),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                              // Tombol selesai memasak
                              if (!_showIngredients) ...[
                                const SizedBox(height: 24),
                                Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (!mounted) return;

                                        // Method untuk menyelesaikan memasak
                                        final foodId = widget.foodId;
                                        final babyId = widget.babyId;
                                        final scheduleId = widget.scheduleId;

                                        // Cek apakah scheduleId null atau tidak
                                        if (scheduleId != null) {
                                          context.read<FoodCookingBloc>().add(
                                            CompleteFoodCooking(
                                              foodId: foodId,
                                              babyId: babyId,
                                              scheduleId: scheduleId,
                                            ),
                                          );
                                        } else {
                                          context.read<FoodCookingBloc>().add(
                                            CompleteFoodCooking(
                                              foodId: foodId,
                                              babyId: babyId,
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.accent,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Selesai Memasak',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
