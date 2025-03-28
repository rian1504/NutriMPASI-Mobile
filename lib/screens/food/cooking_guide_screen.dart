import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/models/food_model.dart';

class CookingGuideScreen extends StatefulWidget {
  final String foodId;

  const CookingGuideScreen({super.key, required this.foodId});

  @override
  State<CookingGuideScreen> createState() => _CookingGuideScreenState();
}

class _CookingGuideScreenState extends State<CookingGuideScreen> {
  // Toggle untuk tampilan bahan dan langkah
  bool _showIngredients = true;
  late Food _food;

  @override
  void initState() {
    super.initState();
    // Ambil data makanan
    _food = Food.dummyFoods.firstWhere((food) => food.id == widget.foodId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gambar latar belakang
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(_food.image),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Tombol kembali
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(12),
                elevation: 2,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Icon(
                Symbols.arrow_back_ios_new,
                color: AppColors.textBlack,
                size: 20,
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
                          height: 8,
                          width: 75,
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.componentGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      // Judul makanan
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          _food.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Informasi porsi dan riwayat
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 125,
                            child: Row(
                              children: [
                                const Icon(
                                  Symbols.restaurant,
                                  size: 20,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${_food.portion} porsi',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              height: 40,
                              width: 1,
                              color: AppColors.textBlack.withAlpha(75),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Symbols.history,
                                size: 20,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '32x dimasak',
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
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _food.recipe.length,
                            itemBuilder: (context, index) {
                              final ingredient = _food.recipe[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        if (_food.fruit.isNotEmpty) ...[
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.buff,
                                    borderRadius: const BorderRadius.only(
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _food.fruit.length,
                                  padding: const EdgeInsets.all(16),
                                  itemBuilder: (context, index) {
                                    final fruit = _food.fruit[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
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
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _food.step.length,
                            itemBuilder: (context, index) {
                              final step = _food.step[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
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
    );
  }
}
