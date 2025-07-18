import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/blocs/food_cooking/food_cooking_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/main.dart';
import 'package:nutrimpasi/models/food_cooking.dart';
import 'package:nutrimpasi/widgets/custom_button.dart';
import 'package:nutrimpasi/widgets/custom_dialog.dart';

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

  FoodCookingGuide? food;

  // Fungsi untuk menghitung jumlah bahan berdasarkan jumlah bayi
  String scaleIngredient(String ingredient) {
    // jika hanya 1 bayi yang dipilih, kembalikan jumlah bahan asli
    if (widget.babyId.length <= 1) {
      return ingredient;
    }

    // Jika format umum
    RegExp quantityPatternMiddle = RegExp(
      r'([a-zA-Z\s]+)\s+(\d+(?:[,.]\d+)?|\d+\/\d+)\s*([a-zA-Z]*)',
      caseSensitive: false,
    );

    // Jika format kuantitas di awal
    RegExp quantityPatternBegin = RegExp(
      r'^(\d+(?:[,.]\d+)?|\d+\/\d+)\s*([a-zA-Z]*)\s+([a-zA-Z\s]+)',
      caseSensitive: false,
    );

    // Jika format kuantitas di tengah
    var matchMiddle = quantityPatternMiddle.firstMatch(ingredient);
    if (matchMiddle != null) {
      String itemName = matchMiddle.group(1)?.trim() ?? '';
      String quantityStr = matchMiddle.group(2) ?? '';
      String unit = matchMiddle.group(3) ?? '';

      double value;
      if (quantityStr.contains('/')) {
        var parts = quantityStr.split('/');
        double numerator = double.parse(parts[0]);
        double denominator = double.parse(parts[1]);
        value = numerator / denominator * widget.babyId.length;
      } else {
        if (quantityStr.contains(',')) {
          quantityStr = quantityStr.replaceAll(',', '.');
        }
        value = double.tryParse(quantityStr) ?? 0;
        value *= widget.babyId.length;
      }

      String newQuantity;
      if (value == value.toInt()) {
        newQuantity = value.toInt().toString();
      } else {
        newQuantity = value.toString().replaceAll('.', ',');
      }

      return "$itemName $newQuantity $unit".trim();
    }

    // Jika format kuantitas di awal
    var matchBegin = quantityPatternBegin.firstMatch(ingredient);
    if (matchBegin != null) {
      String quantityStr = matchBegin.group(1) ?? '';
      String unit = matchBegin.group(2) ?? '';
      String itemName = matchBegin.group(3)?.trim() ?? '';

      double value;
      if (quantityStr.contains('/')) {
        var parts = quantityStr.split('/');
        double numerator = double.parse(parts[0]);
        double denominator = double.parse(parts[1]);
        value = numerator / denominator * widget.babyId.length;
      } else {
        if (quantityStr.contains(',')) {
          quantityStr = quantityStr.replaceAll(',', '.');
        }
        value = double.tryParse(quantityStr) ?? 0;
        value *= widget.babyId.length;
      }

      String newQuantity;
      if (value == value.toInt()) {
        newQuantity = value.toInt().toString();
      } else {
        newQuantity = value.toString().replaceAll('.', ',');
      }

      return "$newQuantity $unit $itemName".trim();
    }

    // Jika format kuantitas di akhir
    RegExp spaceUnitPattern = RegExp(
      r'(.+?)\s+(\d+(?:[,.]\d+)?|\d+\/\d+)\s+([a-zA-Z]+)',
      caseSensitive: false,
    );

    var spaceMatch = spaceUnitPattern.firstMatch(ingredient);
    if (spaceMatch != null) {
      String itemName = spaceMatch.group(1)?.trim() ?? '';
      String quantityStr = spaceMatch.group(2) ?? '';
      String unit = spaceMatch.group(3) ?? '';

      double value;
      if (quantityStr.contains('/')) {
        var parts = quantityStr.split('/');
        double numerator = double.parse(parts[0]);
        double denominator = double.parse(parts[1]);
        value = numerator / denominator * widget.babyId.length;
      } else {
        if (quantityStr.contains(',')) {
          quantityStr = quantityStr.replaceAll(',', '.');
        }
        value = double.tryParse(quantityStr) ?? 0;
        value *= widget.babyId.length;
      }

      String newQuantity;
      if (value == value.toInt()) {
        newQuantity = value.toInt().toString();
      } else {
        newQuantity = value.toString().replaceAll('.', ',');
      }

      return "$itemName $newQuantity $unit".trim();
    }

    // Jika tidak ada pola yang cocok, gunakan regex untuk menangkap angka
    RegExp numbersOnly = RegExp(r'(\d+(?:[,.]\d+)?|\d+\/\d+)');
    var numMatch = numbersOnly.firstMatch(ingredient);
    if (numMatch != null) {
      String quantityStr = numMatch.group(1) ?? '';
      String before = ingredient.substring(0, numMatch.start);
      String after = ingredient.substring(numMatch.end);

      double value;
      if (quantityStr.contains('/')) {
        var parts = quantityStr.split('/');
        double numerator = double.parse(parts[0]);
        double denominator = double.parse(parts[1]);
        value = numerator / denominator * widget.babyId.length;
      } else {
        if (quantityStr.contains(',')) {
          quantityStr = quantityStr.replaceAll(',', '.');
        }
        value = double.tryParse(quantityStr) ?? 0;
        value *= widget.babyId.length;
      }

      String newQuantity;
      if (value == value.toInt()) {
        newQuantity = value.toInt().toString();
      } else {
        newQuantity = value.toString().replaceAll('.', ',');
      }

      return before + newQuantity + after;
    }

    return ingredient;
  }

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
              (context) => ConfirmDialog(
                titleText: 'Konfirmasi Keluar',
                contentText: 'Anda yakin ingin keluar dari Panduan Memasak?',
                onConfirm: () => Navigator.pop(context, true),
                onCancel: () => Navigator.pop(context, false),
                confirmButtonColor: AppColors.error,
                confirmButtonText: 'Keluar',
              ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FoodCookingBloc, FoodCookingState>(
      listener: (context, state) {
        if (state is FoodCookingComplete) {
          // Tampilkan dialog sukses setelah memasak selesai
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext dialogContext) {
              // Otomatis tutup dialog setelah 2 detik
              Future.delayed(const Duration(seconds: 2), () {
                if (dialogContext.mounted && Navigator.canPop(dialogContext)) {
                  Navigator.pop(dialogContext);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage(initialPage: 1),
                    ),
                  );
                }
              });

              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Gambar sukses
                      Image.asset(
                        'assets/images/component/berhasil_memasak.png',
                        height: 200,
                        width: 200,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                      // Teks sukses
                      const Text(
                        'Selesai Memasak!',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Proses memasak selesai. Informasi resep ini telah dicatat di Riwayat Memasak.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
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
          food = state.foodCooking.foodCookingGuide;
        }

        if (food == null) return const SizedBox.shrink();

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;

            if (state is FoodCookingCompleteLoading) return;

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
                      image: NetworkImage(storageUrl + food!.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Tombol kembali
                LeadingActionButton(
                  onPressed:
                      state is FoodCookingCompleteLoading
                          ? null
                          : () async {
                            final shouldPop =
                                await _showExitConfirmationDialog();
                            if (shouldPop) {
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            }
                          },
                  icon: AppIcons.back,
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
                                food!.name,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                              text:
                                                  '${widget.babyId.length} Set ',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.textBlack,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  '(${food!.portion * widget.babyId.length} Porsi)',
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
                                      '${food!.foodRecordCount}x dimasak',
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: food!.recipe.length,
                                  itemBuilder: (context, index) {
                                    final originalIngredient =
                                        food!.recipe[index];
                                    final scaledIngredient = scaleIngredient(
                                      originalIngredient,
                                    );

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                          Expanded(
                                            child: Text(scaledIngredient),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // Bagian daftar buah
                              if (food!.fruit.any(
                                (item) => item.trim().isNotEmpty,
                              )) ...[
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
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: food!.fruit.length,
                                        padding: const EdgeInsets.all(16),
                                        itemBuilder: (context, index) {
                                          final fruit = scaleIngredient(
                                            food!.fruit[index],
                                          );
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 8,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: food!.step.length,
                                  itemBuilder: (context, index) {
                                    final step = food!.step[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                    onPressed:
                                        state is FoodCookingCompleteLoading
                                            ? null
                                            : () {
                                              if (!mounted) return;

                                              // Method untuk menyelesaikan memasak
                                              final foodId = widget.foodId;
                                              final babyId = widget.babyId;
                                              final scheduleId =
                                                  widget.scheduleId;

                                              // Cek apakah scheduleId null atau tidak
                                              if (scheduleId != null) {
                                                context
                                                    .read<FoodCookingBloc>()
                                                    .add(
                                                      CompleteFoodCooking(
                                                        foodId: foodId,
                                                        babyId: babyId,
                                                        scheduleId: scheduleId,
                                                      ),
                                                    );
                                              } else {
                                                context
                                                    .read<FoodCookingBloc>()
                                                    .add(
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
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child:
                                        state is FoodCookingCompleteLoading
                                            ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 3,
                                              ),
                                            )
                                            : const Text(
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
      },
    );
  }
}
