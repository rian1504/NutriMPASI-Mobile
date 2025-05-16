import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/blocs/food_suggestion/food_suggestion_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nutrimpasi/models/food_suggestion.dart';
import 'package:nutrimpasi/screens/food/food_recipe_success_screen.dart';

class FoodNutritionCalculatorScreen extends StatefulWidget {
  final List<String> ingredients;
  final FoodSuggestion food;
  final File? image;

  const FoodNutritionCalculatorScreen({
    super.key,
    required this.ingredients,
    required this.food,
    required this.image,
  });

  @override
  State<FoodNutritionCalculatorScreen> createState() =>
      _FoodNutritionCalculatorScreenState();
}

class _FoodNutritionCalculatorScreenState
    extends State<FoodNutritionCalculatorScreen> {
  // API key dari .env file untuk akses Gemini AI
  final String _geminiApiKey =
      dotenv.env['GEMINI_API_KEY'] ?? 'YOUR_DEFAULT_API_KEY';

  // State untuk menyimpan nilai nutrisi
  double _energyValue = 0;
  double _proteinValue = 0;
  double _fatValue = 0;
  bool _isCalculating = true;

  @override
  void initState() {
    super.initState();
    _calculateNutrition();
  }

  // Fungsi utama untuk menghitung nutrisi dari bahan yang diinput
  Future<void> _calculateNutrition() async {
    try {
      // Mencoba mendapatkan nilai nutrisi melalui Gemini AI API
      final nutritionValues = await _getNutritionValuesFromGemini(
        widget.ingredients,
      );

      if (mounted) {
        setState(() {
          _energyValue = nutritionValues['energy']!;
          _proteinValue = nutritionValues['protein']!;
          _fatValue = nutritionValues['fat']!;
          _isCalculating = false;
        });
      }
    } catch (e) {
      debugPrint('Error menggunakan API Gemini: $e');
      // Jika terjadi error, gunakan kalkulasi lokal sebagai fallback
      _calculateNutritionLocally();
    }
  }

  // Fungsi untuk mendapatkan nilai gizi dari bahan makanan menggunakan Gemini AI
  Future<Map<String, double>> _getNutritionValuesFromGemini(
    List<String> ingredients,
  ) async {
    if (_geminiApiKey == 'YOUR_DEFAULT_API_KEY' || _geminiApiKey.isEmpty) {
      debugPrint('Error: GEMINI_API_KEY not found in .env file.');
      throw Exception('API Key not configured.');
    }
    try {
      // Menyiapkan prompt untuk model AI
      final prompt = '''
      Analyze these ingredients and calculate their nutritional values from kemenkes indonesia data:
      ${ingredients.join('\n')}

      Return only a JSON object with these exact keys (nothing else):
      - energy: total energy in kcal (number)
      - protein: total protein in grams (number)
      - fat: total fat in grams (number)

      Example response:
      {"energy": 250.5, "protein": 12.3, "fat": 5.4}
      ''';

      // Inisialisasi model Gemini
      final model = GenerativeModel(
        model: 'gemini-2.0-flash-thinking-exp-01-21',
        apiKey: _geminiApiKey,
      );

      // Mengirim request ke API Gemini
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      final responseText = response.text;
      if (responseText == null) {
        throw Exception('Respons kosong dari API Gemini');
      }

      debugPrint('Respons Gemini: $responseText');

      // Ekstraksi data JSON dari respons menggunakan regex
      final String jsonPattern =
          r'```(?:json)?\s*(\{[\s\S]*?\})\s*```|(\{[\s\S]*?\})';
      RegExp jsonRegex = RegExp(jsonPattern);
      var matches = jsonRegex.allMatches(responseText);

      String? jsonString;
      for (var match in matches) {
        jsonString = match.group(1) ?? match.group(2);
        if (jsonString != null) break;
      }

      if (jsonString == null) {
        throw Exception('Tidak dapat menemukan JSON dalam respons Gemini');
      }

      debugPrint('JSON yang diekstrak: $jsonString');

      jsonString = jsonString.trim();

      // Parse JSON dan validasi struktur data
      Map<String, dynamic> nutritionData = jsonDecode(jsonString);

      if (!nutritionData.containsKey('energy') ||
          !nutritionData.containsKey('protein') ||
          !nutritionData.containsKey('fat')) {
        throw Exception(
          'Kunci nutrisi yang diperlukan tidak ada dalam respons',
        );
      }

      // Konversi nilai-nilai ke double dan kembalikan sebagai Map
      return {
        'energy': double.parse(nutritionData['energy'].toString()),
        'protein': double.parse(nutritionData['protein'].toString()),
        'fat': double.parse(nutritionData['fat'].toString()),
      };
    } catch (e) {
      debugPrint('Error dalam kalkulasi API Gemini: $e');
      throw Exception('Gagal menghitung nutrisi dengan Gemini: $e');
    }
  }

  // Fungsi fallback untuk menggunakan nilai default jika API gagal
  void _calculateNutritionLocally() {
    if (mounted) {
      setState(() {
        // Nilai default untuk fallback
        _energyValue = 120.0;
        _proteinValue = 5.0;
        _fatValue = 3.0;
        _isCalculating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 60, horizontal: 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul halaman
                  Center(
                    child: const Text(
                      'Kalkulator Gizi',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Indikator progress step (Isi Form -> Kalkulator Gizi -> Selesai)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildProgressStep(1, 'Isi Form', false),

                      // Garis penghubung
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15, left: 10),
                          child: Container(
                            height: 4,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),

                      _buildProgressStep(2, 'Kalkulator Gizi', true),

                      // Garis penghubung
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15, right: 10),
                          child: Container(
                            height: 4,
                            color: AppColors.componentGrey,
                          ),
                        ),
                      ),

                      _buildProgressStep(3, 'Selesai', false),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1E0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Menampilkan pesan jika tidak ada bahan, atau daftar bahan jika ada
                      children:
                          widget.ingredients.isEmpty
                              ? [
                                _buildIngredientItem(
                                  'Tidak ada bahan yang diinput',
                                ),
                              ]
                              : widget.ingredients
                                  .map(
                                    (ingredient) =>
                                        _buildIngredientItem(ingredient),
                                  )
                                  .toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Teks penjelasan tentang proses kalkulasi
                  const Text(
                    'Menghitung kandungan nutrisi...',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const Text(
                    'Berdasarkan bahan-bahan yang telah diinput, sistem akan menghitung total kandungan gizi meliputi energi (kalori), protein, dan lemak. Hasilnya akan ditampilkan dalam tabel berikut:',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textBlack,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Judul hasil perhitungan
                  const Text(
                    'Hasil Perhitungan Nutrisi:',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textBlack,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Widget kondisional: loading indicator atau hasil perhitungan
                  _isCalculating
                      ? const Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(
                              color: AppColors.secondary,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Menghitung nilai nutrisi...',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic,
                                color: AppColors.textBlack,
                              ),
                            ),
                          ],
                        ),
                      )
                      // Tampilan hasil perhitungan nutrisi dalam bentuk card
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Card untuk energi (kalori)
                          _buildNutritionCard(
                            'Energi',
                            _energyValue.toStringAsFixed(1),
                            'kkal',
                          ),
                          // Pembatas vertikal antar card
                          Container(
                            height: 40,
                            width: 1,
                            color: AppColors.textBlack.withAlpha(75),
                          ),
                          // Card untuk protein
                          _buildNutritionCard(
                            'Protein',
                            _proteinValue.toStringAsFixed(1),
                            'g',
                          ),
                          // Pembatas vertikal antar card
                          Container(
                            height: 40,
                            width: 1,
                            color: AppColors.textBlack.withAlpha(75),
                          ),
                          // Card untuk lemak
                          _buildNutritionCard(
                            'Lemak',
                            _fatValue.toStringAsFixed(1),
                            'g',
                          ),
                        ],
                      ),
                ],
              ),
            ),
          ),

          // Tombol kembali
          Positioned(
            top: 35,
            left: 15,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.componentGrey!),
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
        ],
      ),
      // Bottom navigation bar dengan tombol simpan
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        decoration: BoxDecoration(color: Colors.white),
        child: ElevatedButton(
          // Button dinonaktifkan selama proses kalkulasi
          onPressed:
              _isCalculating
                  ? null
                  : () {
                    if (widget.food.id == null) {
                      // Jika food.id null, berarti ini adalah penambahan baru
                      context.read<FoodSuggestionBloc>().add(
                        StoreFoodSuggestion(
                          foodCategoryId: widget.food.foodCategoryId!,
                          name: widget.food.name,
                          image: widget.image!,
                          age: widget.food.age,
                          energy: _energyValue,
                          protein: _proteinValue,
                          fat: _fatValue,
                          portion: widget.food.portion,
                          recipe: widget.food.recipe,
                          fruit: widget.food.fruit,
                          step: widget.food.step,
                          description: widget.food.description,
                        ),
                      );
                    } else {
                      // update FoodSuggestion
                      context.read<FoodSuggestionBloc>().add(
                        UpdateFoodSuggestion(
                          foodId: widget.food.id!,
                          foodCategoryId: widget.food.foodCategoryId!,
                          name: widget.food.name,
                          image: widget.image,
                          age: widget.food.age,
                          energy: _energyValue,
                          protein: _proteinValue,
                          fat: _fatValue,
                          portion: widget.food.portion,
                          recipe: widget.food.recipe,
                          fruit: widget.food.fruit,
                          step: widget.food.step,
                          description: widget.food.description,
                        ),
                      );
                    }

                    // Navigasi ke halaman sukses setelah simpan
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FoodRecipeSuccessScreen(),
                      ),
                    );
                  },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text(
            'Simpan',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // Widget helper untuk membuat item bahan makanan
  Widget _buildIngredientItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        '- $text',
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: AppColors.textBlack,
        ),
      ),
    );
  }

  // Widget helper untuk membuat indikator step progress
  Widget _buildProgressStep(int number, String label, bool isActive) {
    Color circleColor;
    Color textColor;

    // Menentukan warna berdasarkan status step
    if (isActive) {
      // Step saat ini (aktif)
      circleColor = AppColors.primary;
      textColor = Colors.white;
    } else if (number < 2) {
      // Step sebelumnya (sudah selesai)
      circleColor = AppColors.buff;
      textColor = Colors.white;
    } else {
      // Step berikutnya (belum dilakukan)
      circleColor = AppColors.componentGrey!;
      textColor = Colors.white;
    }

    // Membangun widget step (lingkaran dengan nomor)
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(shape: BoxShape.circle, color: circleColor),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        // Label step di bawah lingkaran
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: isActive ? AppColors.textBlack : Colors.grey,
          ),
        ),
      ],
    );
  }

  // Widget helper untuk membuat card nutrisi (energi, protein, lemak)
  Widget _buildNutritionCard(String label, String value, String unit) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            // Label nutrisi (misalnya "Energi")
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: AppColors.textGrey,
              ),
            ),
            const SizedBox(height: 4),
            // Nilai dan satuan nutrisi (misalnya "120.0 kkal")
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Nilai nutrisi
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 2),
                // Satuan nutrisi
                Text(
                  unit,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
