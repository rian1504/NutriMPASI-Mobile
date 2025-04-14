import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/colors.dart';
// import 'package:nutrimpasi/screens/food/food_nutrition_calculator_screen.dart';

class FoodAddSuggestionScreen extends StatefulWidget {
  const FoodAddSuggestionScreen({super.key});

  @override
  State<FoodAddSuggestionScreen> createState() =>
      _FoodAddSuggestionScreenState();
}

class _FoodAddSuggestionScreenState extends State<FoodAddSuggestionScreen> {
  // Kunci form untuk validasi
  final _formKey = GlobalKey<FormState>();

  // Controller untuk field formulir
  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // List controller untuk field dinamis
  final List<TextEditingController> _ingredientControllers = [];
  final List<TextEditingController> _stepControllers = [];

  // Pilihan kategori dropdown
  String? _selectedCategory;

  // Daftar kategori yang tersedia
  final List<String> _categories = [
    'Karbohidrat',
    'Bubur & Puree',
    'Sup & Kuah',
    'Finger Food',
  ];

  @override
  void initState() {
    super.initState();
    // Tambahkan field kosong saat inisialisasi
    _addIngredientField();
    _addStepField();
  }

  // Tambah field bahan baru
  void _addIngredientField() {
    setState(() {
      _ingredientControllers.add(TextEditingController());
    });
  }

  // Hapus field bahan
  void _removeIngredientField(int index) {
    setState(() {
      _ingredientControllers[index].dispose();
      _ingredientControllers.removeAt(index);
    });
  }

  // Tambah field langkah baru
  void _addStepField() {
    setState(() {
      _stepControllers.add(TextEditingController());
    });
  }

  // Hapus field langkah
  void _removeStepField(int index) {
    setState(() {
      _stepControllers[index].dispose();
      _stepControllers.removeAt(index);
    });
  }

  @override
  void dispose() {
    _recipeNameController.dispose();
    _descriptionController.dispose();

    // Hapus semua controller dinamis
    for (var controller in _ingredientControllers) {
      controller.dispose();
    }
    for (var controller in _stepControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Konten utama
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              children: [
                // Judul dan indikator progres
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.zero,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Teks judul
                      const Text(
                        'Tambahkan Usulan Makanan',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      // Indikator progres
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Langkah 1
                          _buildProgressStep(1, 'Isi Form', true),

                          // Garis 1
                          Expanded(
                            child: Container(
                              height: 1,
                              color: AppColors.componentGrey,
                            ),
                          ),

                          // Langkah 2
                          _buildProgressStep(2, 'Kalkulator Gizi', false),

                          // Garis 2
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.grey.withAlpha(75),
                            ),
                          ),

                          // Langkah 3
                          _buildProgressStep(3, 'Selesai', false),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.offWhite, AppColors.white],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.elliptical(60, 30),
                        bottomLeft: Radius.elliptical(60, 30),
                      ),
                    ),
                  ),
                ),
                // Kontainer formulir
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.offWhite,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Input nama resep
                              const Text(
                                'Masukkan Nama Resep',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textBlack,
                                ),
                              ),
                              const SizedBox(height: 4),
                              TextFormField(
                                controller: _recipeNameController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Nama resep tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              // Tombol unggah foto
                              const Text(
                                'Unggah Foto Masakan',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textBlack,
                                ),
                              ),
                              const SizedBox(height: 4),
                              InkWell(
                                onTap: () {
                                  // TODO: Implementasi unggah foto
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.buff,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.upload_outlined,
                                        color: AppColors.textBlack,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Tambahkan Foto',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textBlack,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Dropdown kategori
                              const Text(
                                'Pilih Kategori Masakan',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textBlack,
                                ),
                              ),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<String>(
                                value: _selectedCategory,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  suffixIcon: const Icon(Icons.arrow_drop_down),
                                ),
                                icon: const SizedBox.shrink(),
                                hint: const Text('Pilih kategori'),
                                items:
                                    _categories.map((category) {
                                      return DropdownMenuItem<String>(
                                        value: category,
                                        child: Text(category),
                                      );
                                    }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategory = value;
                                  });
                                },
                                isExpanded: true,
                                isDense: true,
                              ),

                              const SizedBox(height: 16),

                              // Input deskripsi
                              const Text(
                                'Masukkan Deskripsi Masakan',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textBlack,
                                ),
                              ),
                              const SizedBox(height: 4),
                              TextFormField(
                                controller: _descriptionController,
                                maxLines: 2,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Deskripsi tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              // Input bahan masakan
                              const Text(
                                'Masukkan Bahan Masakan',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textBlack,
                                ),
                              ),

                              // Field bahan dinamis
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _ingredientControllers.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Nomor indeks
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: const BoxDecoration(
                                            color: AppColors.buff,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${index + 1}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Field input bahan
                                        Expanded(
                                          child: TextFormField(
                                            controller:
                                                _ingredientControllers[index],
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              hintText: 'Bahan ${index + 1}',
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Bahan tidak boleh kosong';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        // Tombol hapus
                                        if (_ingredientControllers.length > 1)
                                          IconButton(
                                            icon: const Icon(
                                              Icons.remove_circle_outline,
                                              color: AppColors.red,
                                            ),
                                            onPressed:
                                                () => _removeIngredientField(
                                                  index,
                                                ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              // Tombol tambah bahan
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: _addIngredientField,
                                  icon: const Icon(Icons.add_circle_outline),
                                  label: const Text('Tambah Bahan'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                  ),
                                ),
                              ),

                              // Input langkah penyajian
                              const Text(
                                'Masukkan Langkah Penyajian',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textBlack,
                                ),
                              ),

                              // Field langkah dinamis
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _stepControllers.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Nomor indeks
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: const BoxDecoration(
                                            color: AppColors.buff,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${index + 1}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Field input langkah
                                        Expanded(
                                          child: TextFormField(
                                            controller: _stepControllers[index],
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              hintText: 'Langkah ${index + 1}',
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Langkah tidak boleh kosong';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        // Tombol hapus
                                        if (_stepControllers.length > 1)
                                          IconButton(
                                            icon: const Icon(
                                              Icons.remove_circle_outline,
                                              color: AppColors.red,
                                            ),
                                            onPressed:
                                                () => _removeStepField(index),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              // Tombol tambah langkah
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: _addStepField,
                                  icon: const Icon(Icons.add_circle_outline),
                                  label: const Text('Tambah Langkah'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 240),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tombol next
          Positioned(
            right: 0,
            bottom: 20,
            child: Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: AppColors.offWhite,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        // Validasi form saat tombol next ditekan
                        // if (_formKey.currentState!.validate()) {
                        //   List<String> ingredients =
                        //       _ingredientControllers
                        //           .map((controller) => controller.text)
                        //           .toList();

                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder:
                        //           (context) => FoodNutritionCalculatorScreen(
                        //             ingredients: ingredients,
                        //           ),
                        //     ),
                        //   );
                        // }
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: AppColors.buff,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.chevron_right,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk langkah progres
  Widget _buildProgressStep(int number, String label, bool isActive) {
    return Column(
      children: [
        // Lingkaran dengan angka
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primary : Colors.white,
            border: Border.all(
              color: isActive ? AppColors.primary : AppColors.componentGrey!,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : Colors.grey,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        // Teks label
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
}
