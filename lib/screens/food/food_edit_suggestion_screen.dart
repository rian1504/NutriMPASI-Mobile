import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/screens/food/food_nutrition_calculator_screen.dart';

class FoodEditSuggestionScreen extends StatefulWidget {
  final String foodId;

  const FoodEditSuggestionScreen({super.key, required this.foodId});

  @override
  State<FoodEditSuggestionScreen> createState() =>
      _FoodEditSuggestionScreenState();
}

class _FoodEditSuggestionScreenState extends State<FoodEditSuggestionScreen> {
  // Kunci form untuk validasi
  final _formKey = GlobalKey<FormState>();

  // Controller untuk field formulir
  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _servingsController = TextEditingController();
  final TextEditingController _fruitsController = TextEditingController();

  // List controller untuk field dinamis
  final List<TextEditingController> _ingredientControllers = [];
  final List<TextEditingController> _stepControllers = [];

  // Pilihan kategori dropdown
  String? _selectedCategory;
  String? _selectedAgeGroup;

  // Daftar kategori yang tersedia
  final List<String> _categories = [
    'Karbohidrat',
    'Bubur & Puree',
    'Sup & Kuah',
    'Finger Food',
  ];

  // Daftar usia konsumsi
  final List<String> _ageGroups = [
    '6-8 bulan',
    '9-11 bulan',
    '12-23 bulan',
    '> 24 bulan',
  ];

  @override
  void initState() {
    super.initState();
    // Tambahkan field kosong saat inisialisasi
    _addIngredientField();
    _addStepField();

    // TODO: Fetch data resep dari API menggunakan foodId
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
    _servingsController.dispose();
    _fruitsController.dispose();

    // Hapus semua controller dinamis
    for (var controller in _ingredientControllers) {
      controller.dispose();
    }
    for (var controller in _stepControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  // Style untuk form input
  InputDecoration _getInputDecoration({String? hintText}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hintText,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
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
                        'Edit Usulan Makanan',
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

                          // Garis penghubung
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 15,
                                left: 10,
                              ),
                              child: Container(
                                height: 4,
                                color: AppColors.secondary,
                              ),
                            ),
                          ),

                          // Langkah 2
                          _buildProgressStep(2, 'Kalkulator Gizi', false),

                          // Garis penghubung
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 15,
                                right: 10,
                              ),
                              child: Container(
                                height: 4,
                                color: AppColors.componentGrey,
                              ),
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
                      colors: [AppColors.pearl, Colors.white],
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
                      color: AppColors.pearl,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Form(
                          key: _formKey,
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(20),
                            children: [
                              // Input nama resep
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Masukkan Nama Resep',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textBlack,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              TextFormField(
                                controller: _recipeNameController,
                                decoration: _getInputDecoration(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Nama resep tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              // Tombol unggah foto
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Unggah Foto Masakan',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textBlack,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
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
                                    border: Border.all(color: Colors.grey),
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
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Pilih Kategori Masakan',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textBlack,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<String>(
                                value: _selectedCategory,
                                decoration: _getInputDecoration(),
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Kategori harus dipilih';
                                  }
                                  return null;
                                },
                                isExpanded: true,
                                isDense: true,
                              ),

                              const SizedBox(height: 16),

                              // Dropdown usia konsumsi
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Pilih Usia Konsumsi',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textBlack,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<String>(
                                value: _selectedAgeGroup,
                                decoration: _getInputDecoration(),
                                icon: const SizedBox.shrink(),
                                hint: const Text('Pilih usia'),
                                items:
                                    _ageGroups.map((age) {
                                      return DropdownMenuItem<String>(
                                        value: age,
                                        child: Text(age),
                                      );
                                    }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAgeGroup = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Usia konsumsi harus dipilih';
                                  }
                                  return null;
                                },
                                isExpanded: true,
                                isDense: true,
                              ),

                              const SizedBox(height: 16),

                              // Input jumlah porsi
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Tentukan Porsi',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textBlack,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              TextFormField(
                                controller: _servingsController,
                                decoration: _getInputDecoration(),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Jumlah porsi tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              // Input deskripsi
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Masukkan Deskripsi Masakan',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textBlack,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              TextFormField(
                                controller: _descriptionController,
                                maxLines: 2,
                                decoration: _getInputDecoration(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Deskripsi tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              // Input bahan masakan
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Masukkan Bahan Masakan',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textBlack,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
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
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${index + 1}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
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
                                            decoration: _getInputDecoration(
                                              hintText: 'Bahan ${index + 1}',
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
                                            icon: Icon(
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

                              const SizedBox(height: 16),

                              // Input buah
                              const Text(
                                'Buah',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textBlack,
                                ),
                              ),
                              const SizedBox(height: 4),
                              TextFormField(
                                controller: _fruitsController,
                                decoration: _getInputDecoration(),
                              ),

                              const SizedBox(height: 16),

                              // Input langkah penyajian
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Masukkan Langkah Penyajian',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textBlack,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
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
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${index + 1}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Field input langkah
                                        Expanded(
                                          child: TextFormField(
                                            controller: _stepControllers[index],
                                            decoration: _getInputDecoration(
                                              hintText: 'Langkah ${index + 1}',
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
                                            icon: Icon(
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
                              const SizedBox(height: 90),
                            ],
                          ),
                        ),

                        // Tombol next
                        Positioned(
                          right: -20,
                          bottom: -20,
                          child: Material(
                            color: Colors.transparent,
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
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        // Validasi form saat tombol next ditekan
                                        if (_formKey.currentState!.validate()) {
                                          List<String> ingredients =
                                              _ingredientControllers
                                                  .map(
                                                    (controller) =>
                                                        controller.text,
                                                  )
                                                  .toList();

                                          // menambahkan field buah ke bahan untuk perhitungan gizi
                                          if (_fruitsController
                                              .text
                                              .isNotEmpty) {
                                            ingredients.add(
                                              _fruitsController.text,
                                            );
                                          }

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      FoodNutritionCalculatorScreen(
                                                        ingredients:
                                                            ingredients,
                                                      ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: const BoxDecoration(
                                          color: AppColors.buff,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Symbols.arrow_forward_ios_rounded,
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
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
            color: isActive ? AppColors.primary : AppColors.componentGrey,
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
                color: Colors.white,
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
