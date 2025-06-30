import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:nutrimpasi/blocs/food_category/food_category_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/food_suggestion.dart';
import 'package:nutrimpasi/screens/food/food_nutrition_calculator_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:nutrimpasi/utils/flushbar.dart';

class FoodSuggestionEditScreen extends StatefulWidget {
  final FoodSuggestion food;

  const FoodSuggestionEditScreen({super.key, required this.food});

  @override
  State<FoodSuggestionEditScreen> createState() =>
      _FoodSuggestionEditScreenState();
}

class _FoodSuggestionEditScreenState extends State<FoodSuggestionEditScreen> {
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
  FoodCategory? _selectedCategory;
  String? _selectedAgeGroup;

  // Daftar kategori yang tersedia
  List<FoodCategory> _categories = [];

  // Daftar usia konsumsi
  final List<String> _ageGroups = ['6-8', '9-11', '12-23'];

  String? _imagePath;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _showPhotoError = false;
  bool _showImageSizeError = false;

  // Menambahkan global key untuk foto untuk validasi bersama dengan form lain
  final GlobalKey _photoFieldKey = GlobalKey();
  final GlobalKey<FormFieldState> _recipeNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _categoryKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _ageKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _portionKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _descriptionKey = GlobalKey<FormFieldState>();
  final List<GlobalKey<FormFieldState>> _ingredientKeys = [];
  final List<GlobalKey<FormFieldState>> _stepKeys = [];

  // Flag untuk melacak apakah bahan atau buah diubah
  bool _ingredientsChanged = false;

  @override
  void initState() {
    super.initState();
    context.read<FoodCategoryBloc>().add(FetchFoodCategories());

    // Inisialisasi controller dengan data dari food
    _imagePath = widget.food.image;
    _recipeNameController.text = widget.food.name;
    _descriptionController.text = widget.food.description;
    _servingsController.text = widget.food.portion.toString();
    _selectedAgeGroup = widget.food.age;

    // Inisialisasi bahan (recipe)
    for (var ingredient in widget.food.recipe) {
      final controller = TextEditingController(text: ingredient);
      // Tambahkan listener untuk mendeteksi perubahan pada ingredients
      controller.addListener(() {
        final originalIngredients = widget.food.recipe;
        if (originalIngredients.length != _ingredientControllers.length ||
            originalIngredients.asMap().entries.any(
              (entry) =>
                  entry.key < _ingredientControllers.length &&
                  _ingredientControllers[entry.key].text != entry.value,
            )) {
          setState(() {
            _ingredientsChanged = true;
          });
        }
      });
      _ingredientControllers.add(controller);
      _ingredientKeys.add(GlobalKey<FormFieldState>());
    }

    // Inisialisasi buah (fruit)
    if (widget.food.fruit != null) {
      _fruitsController.text = widget.food.fruit!.join(', ');
      // Tambahkan listener untuk mendeteksi perubahan pada fruits
      _fruitsController.addListener(() {
        final originalFruits = widget.food.fruit?.join(', ') ?? '';
        if (_fruitsController.text != originalFruits) {
          setState(() {
            _ingredientsChanged = true;
          });
        }
      });
    }

    // Inisialisasi langkah (step)
    for (var step in widget.food.step) {
      _stepControllers.add(TextEditingController(text: step));
      _stepKeys.add(GlobalKey<FormFieldState>());
    }

    // Jika tidak ada bahan/langkah, tambahkan field kosong
    if (_ingredientControllers.isEmpty) _addIngredientField();
    if (_stepControllers.isEmpty) _addStepField();
  }

  // Method untuk memilih foto dari gallery
  Future<void> _getImageFromGallery() async {
    try {
      final XFile? selectedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (selectedImage != null) {
        setState(() {
          _imageFile = File(selectedImage.path);
          _imagePath = selectedImage.path;
          _showPhotoError = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      AppFlushbar.showError(
        context,
        title: 'Error',
        message: 'Gagal mengakses galeri. Coba periksa izin aplikasi',
      );
    }
  }

  // Method untuk mengambil foto dari kamera
  Future<void> _getImageFromCamera() async {
    try {
      final XFile? takenImage = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (takenImage != null) {
        setState(() {
          _imageFile = File(takenImage.path);
          _imagePath = takenImage.path;
          _showPhotoError = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      AppFlushbar.showError(
        context,
        title: 'Error',
        message: 'Gagal mengakses kamera. Coba periksa izin aplikasi',
      );
    }
  }

  // Method untuk menampilkan bottom sheet pilihan foto
  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih Sumber Foto',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Tombol opsi kamera
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      _getImageFromCamera();
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.buff,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Kamera',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Tombol opsi galeri
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      _getImageFromGallery();
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.buff,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.photo_library,
                            size: 30,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Galeri',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // Tambah field bahan baru
  void _addIngredientField({String? initialValue}) {
    setState(() {
      _ingredientsChanged = true;
      final controller = TextEditingController(text: initialValue);
      _ingredientControllers.add(controller);
      _ingredientKeys.add(GlobalKey<FormFieldState>());
    });
  }

  // Hapus field bahan
  void _removeIngredientField(int index) {
    setState(() {
      _ingredientsChanged = true;
      _ingredientControllers[index].dispose();
      _ingredientControllers.removeAt(index);
      _ingredientKeys.removeAt(index);
    });
  }

  // Tambah field langkah baru
  void _addStepField({String? initialValue}) {
    setState(() {
      _stepControllers.add(TextEditingController(text: initialValue));
      _stepKeys.add(GlobalKey<FormFieldState>());
    });
  }

  // Hapus field langkah
  void _removeStepField(int index) {
    setState(() {
      _stepControllers[index].dispose();
      _stepControllers.removeAt(index);
      _stepKeys.removeAt(index);
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

  // Method untuk validasi total panjang karakter dari bahan
  String? validateIngredientsLength(String? value, int index) {
    if (value == null || value.isEmpty) {
      return 'Bahan tidak boleh kosong';
    }

    // Hitung total panjang karakter dari semua bahan
    String combinedRecipe = '';
    for (var i = 0; i < _ingredientControllers.length; i++) {
      // Skip controller yang sedang divalidasi
      if (i == index) {
        combinedRecipe += value;
      } else {
        combinedRecipe += _ingredientControllers[i].text;
      }

      // Tambahkan separator jika bukan elemen terakhir
      if (i < _ingredientControllers.length - 1) {
        combinedRecipe += ', ';
      }
    }

    if (combinedRecipe.length < 5) {
      return 'Total bahan minimal 5 karakter';
    }

    return null;
  }

  // Method untuk validasi total panjang karakter dari langkah
  String? validateStepsLength(String? value, int index) {
    if (value == null || value.isEmpty) {
      return 'Langkah tidak boleh kosong';
    }

    // Hitung total panjang karakter dari semua langkah
    String combinedSteps = '';
    for (var i = 0; i < _stepControllers.length; i++) {
      // Skip controller yang sedang divalidasi
      if (i == index) {
        combinedSteps += value;
      } else {
        combinedSteps += _stepControllers[i].text;
      }

      // Tambahkan separator jika bukan elemen terakhir
      if (i < _stepControllers.length - 1) {
        combinedSteps += ', ';
      }
    }

    if (combinedSteps.length < 5) {
      return 'Total langkah minimal 5 karakter';
    }

    return null;
  }

  // Method untuk melakukan scroll ke field error pertama yang ditemukan
  void _scrollToFirstError() {
    // Cek apakah ada error pada foto
    if (_showPhotoError && _photoFieldKey.currentContext != null) {
      Scrollable.ensureVisible(
        _photoFieldKey.currentContext!,
        duration: const Duration(milliseconds: 300),
        alignment: 0.2,
      );
      return;
    }

    // Cek apakah ada error pada ukuran gambar
    if (_showImageSizeError && _photoFieldKey.currentContext != null) {
      Scrollable.ensureVisible(
        _photoFieldKey.currentContext!,
        duration: const Duration(milliseconds: 300),
        alignment: 0.2,
      );
      return;
    }

    // Cek apakah ada error pada field lainnya
    if (_recipeNameKey.currentState?.hasError ?? false) {
      Scrollable.ensureVisible(
        _recipeNameKey.currentContext!,
        duration: const Duration(milliseconds: 300),
        alignment: 0.2,
      );
      return;
    }

    if (_categoryKey.currentState?.hasError ?? false) {
      Scrollable.ensureVisible(
        _categoryKey.currentContext!,
        duration: const Duration(milliseconds: 300),
        alignment: 0.2,
      );
      return;
    }

    if (_ageKey.currentState?.hasError ?? false) {
      Scrollable.ensureVisible(
        _ageKey.currentContext!,
        duration: const Duration(milliseconds: 300),
        alignment: 0.2,
      );
      return;
    }

    if (_portionKey.currentState?.hasError ?? false) {
      Scrollable.ensureVisible(
        _portionKey.currentContext!,
        duration: const Duration(milliseconds: 300),
        alignment: 0.2,
      );
      return;
    }

    if (_descriptionKey.currentState?.hasError ?? false) {
      Scrollable.ensureVisible(
        _descriptionKey.currentContext!,
        duration: const Duration(milliseconds: 300),
        alignment: 0.2,
      );
      return;
    }

    for (int i = 0; i < _ingredientKeys.length; i++) {
      final key = _ingredientKeys[i];
      if (key.currentState?.hasError ?? false) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 300),
          alignment: 0.2,
        );
        return;
      }
    }

    for (int i = 0; i < _stepKeys.length; i++) {
      final key = _stepKeys[i];
      if (key.currentState?.hasError ?? false) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 300),
          alignment: 0.2,
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<FoodCategoryBloc, FoodCategoryState>(
        listener: (context, state) {
          if (state is FoodCategoryLoaded) {
            setState(() {
              _categories = state.categories;

              if (_categories.isNotEmpty) {
                // Cari kategori yang sesuai dengan foodCategoryId
                _selectedCategory =
                    widget.food.foodCategoryId != null
                        ? _categories.firstWhere(
                          (cat) => cat.id == widget.food.foodCategoryId,
                          orElse: () => _categories.first,
                        )
                        : null;
              }
            });
          }
        },
        builder: (context, state) {
          if (state is FoodCategoryLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 20,
                ),
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
                                    color: AppColors.accent,
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
                          colors: [AppColors.background, Colors.white],
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
                          color: AppColors.background,
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
                                    key: _recipeNameKey,
                                    controller: _recipeNameController,
                                    decoration: _getInputDecoration(),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Nama resep tidak boleh kosong';
                                      }
                                      if (value.length < 4) {
                                        return 'Nama resep minimal 4 karakter';
                                      }
                                      if (value.length > 255) {
                                        return 'Nama resep maksimal 255 karakter';
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

                                  // UI untuk menampilkan gambar yang sudah dipilih
                                  Container(
                                    key: _photoFieldKey,
                                    child:
                                        _imageFile != null
                                            ? Column(
                                              children: [
                                                Stack(
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      height: 200,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                        child: Image.file(
                                                          _imageFile!,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 5,
                                                      right: 5,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            _imageFile = null;
                                                            // Kembalikan ke gambar original jika menghapus
                                                            _imagePath =
                                                                widget
                                                                    .food
                                                                    .image;
                                                            _showPhotoError =
                                                                false;
                                                          });
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                4,
                                                              ),
                                                          decoration:
                                                              BoxDecoration(
                                                                color: Colors
                                                                    .white
                                                                    .withAlpha(
                                                                      175,
                                                                    ),
                                                                shape:
                                                                    BoxShape
                                                                        .circle,
                                                              ),
                                                          child: const Icon(
                                                            Icons.close,
                                                            size: 20,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                InkWell(
                                                  onTap:
                                                      _showImageSourceOptions,
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 8,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.buff,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: const [
                                                        Icon(
                                                          Icons.edit,
                                                          color:
                                                              AppColors
                                                                  .textBlack,
                                                          size: 18,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'Ganti Foto',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                AppColors
                                                                    .textBlack,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                if (_showImageSizeError)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 6.0,
                                                          left: 12.0,
                                                        ),
                                                    child: Text(
                                                      'Ukuran gambar maksimal 1MB',
                                                      style: TextStyle(
                                                        color: Colors.red[700],
                                                        fontSize: 12,
                                                        fontFamily: 'Poppins',
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            )
                                            : widget.food.image.isNotEmpty
                                            ? Column(
                                              children: [
                                                Stack(
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      height: 200,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                        child: Image.network(
                                                          storageUrl +
                                                              widget.food.image,
                                                          fit: BoxFit.cover,
                                                          loadingBuilder: (
                                                            context,
                                                            child,
                                                            loadingProgress,
                                                          ) {
                                                            if (loadingProgress ==
                                                                null) {
                                                              return child;
                                                            }
                                                            return Center(
                                                              child: CircularProgressIndicator(
                                                                value:
                                                                    loadingProgress.expectedTotalBytes !=
                                                                            null
                                                                        ? loadingProgress.cumulativeBytesLoaded /
                                                                            loadingProgress.expectedTotalBytes!
                                                                        : null,
                                                              ),
                                                            );
                                                          },
                                                          errorBuilder: (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) {
                                                            return Center(
                                                              child: Text(
                                                                'Gagal memuat gambar',
                                                                style: TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                InkWell(
                                                  onTap:
                                                      _showImageSourceOptions,
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 8,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.buff,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: const [
                                                        Icon(
                                                          Icons.edit,
                                                          color:
                                                              AppColors
                                                                  .textBlack,
                                                          size: 18,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'Ganti Foto',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                AppColors
                                                                    .textBlack,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                            : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    // Reset error state
                                                    setState(() {
                                                      _showPhotoError = false;
                                                    });
                                                    _showImageSourceOptions();
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 60,
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 8,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.buff,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      border: Border.all(
                                                        color:
                                                            _showPhotoError
                                                                ? Colors.red
                                                                : Colors.grey,
                                                        width:
                                                            _showPhotoError
                                                                ? 1.5
                                                                : 1,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: const [
                                                        Icon(
                                                          Icons.upload_outlined,
                                                          color:
                                                              AppColors
                                                                  .textBlack,
                                                          size: 18,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'Tambahkan Foto',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                AppColors
                                                                    .textBlack,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                if (_showPhotoError)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 6.0,
                                                          left: 12.0,
                                                        ),
                                                    child: Text(
                                                      'Foto masakan tidak boleh kosong',
                                                      style: TextStyle(
                                                        color: Colors.red[700],
                                                        fontSize: 12,
                                                        fontFamily: 'Poppins',
                                                      ),
                                                    ),
                                                  ),
                                              ],
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
                                  DropdownButtonFormField<FoodCategory>(
                                    key: _categoryKey,
                                    value: _selectedCategory,
                                    decoration: _getInputDecoration(),
                                    icon: const SizedBox.shrink(),
                                    hint: const Text('Pilih kategori'),
                                    items:
                                        _categories.map((category) {
                                          return DropdownMenuItem<FoodCategory>(
                                            value: category,
                                            child: Text(category.name),
                                          );
                                        }).toList(),
                                    onChanged: (FoodCategory? value) {
                                      setState(() {
                                        _selectedCategory = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
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
                                    key: _ageKey,
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
                                    key: _portionKey,
                                    controller: _servingsController,
                                    decoration: _getInputDecoration(),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Jumlah porsi tidak boleh kosong';
                                      }
                                      try {
                                        int.parse(value);
                                      } catch (e) {
                                        return 'Porsi harus berupa angka';
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
                                    key: _descriptionKey,
                                    controller: _descriptionController,
                                    maxLines: 2,
                                    decoration: _getInputDecoration(),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Deskripsi tidak boleh kosong';
                                      }
                                      if (value.length < 5) {
                                        return 'Deskripsi minimal 5 karakter';
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: _ingredientControllers.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8.0,
                                        ),
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
                                                borderRadius:
                                                    BorderRadius.circular(12),
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
                                                key: _ingredientKeys[index],
                                                controller:
                                                    _ingredientControllers[index],
                                                decoration: _getInputDecoration(
                                                  hintText:
                                                      'Bahan ${index + 1}',
                                                ),
                                                validator:
                                                    (value) =>
                                                        validateIngredientsLength(
                                                          value,
                                                          index,
                                                        ),
                                              ),
                                            ),
                                            // Tombol hapus
                                            if (_ingredientControllers.length >
                                                1)
                                              IconButton(
                                                icon: Icon(
                                                  Icons.remove_circle_outline,
                                                  color: AppColors.error,
                                                ),
                                                onPressed:
                                                    () =>
                                                        _removeIngredientField(
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
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                      ),
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: _stepControllers.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8.0,
                                        ),
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
                                                borderRadius:
                                                    BorderRadius.circular(12),
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
                                                key: _stepKeys[index],
                                                controller:
                                                    _stepControllers[index],
                                                decoration: _getInputDecoration(
                                                  hintText:
                                                      'Langkah ${index + 1}',
                                                ),
                                                validator:
                                                    (value) =>
                                                        validateStepsLength(
                                                          value,
                                                          index,
                                                        ),
                                              ),
                                            ),
                                            // Tombol hapus
                                            if (_stepControllers.length > 1)
                                              IconButton(
                                                icon: Icon(
                                                  Icons.remove_circle_outline,
                                                  color: AppColors.error,
                                                ),
                                                onPressed:
                                                    () =>
                                                        _removeStepField(index),
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
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                      ),
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
                                            // Reset semua error state terlebih dahulu
                                            setState(() {
                                              // Foto dianggap valid jika imageFile ada atau foto original masih ada
                                              _showPhotoError =
                                                  _imageFile == null &&
                                                  (widget.food.image.isEmpty);
                                              _showImageSizeError = false;
                                            });

                                            // Validasi ukuran gambar jika ada
                                            if (_imageFile != null) {
                                              final fileSize =
                                                  _imageFile!.lengthSync();
                                              final fileSizeInMB =
                                                  fileSize / (1024 * 1024);
                                              if (fileSizeInMB > 1) {
                                                setState(() {
                                                  _showImageSizeError = true;
                                                });
                                              }
                                            }

                                            // Validasi form saat tombol next ditekan
                                            bool formValid =
                                                _formKey.currentState!
                                                    .validate();

                                            // Scroll ke error pertama jika ada
                                            if (!formValid ||
                                                _showPhotoError ||
                                                _showImageSizeError) {
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                    _scrollToFirstError();
                                                  });
                                              return;
                                            }

                                            // Hanya lanjutkan jika form valid dan ada foto
                                            if (formValid &&
                                                !_showPhotoError &&
                                                !_showImageSizeError) {
                                              // Reset state error
                                              setState(() {
                                                _showPhotoError = false;
                                                _showImageSizeError = false;
                                              });

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

                                              // Mengupdate data makanan
                                              final updatedFood = FoodSuggestion(
                                                id: widget.food.id,
                                                foodCategoryId:
                                                    _selectedCategory?.id ??
                                                    widget.food.foodCategoryId,
                                                name:
                                                    _recipeNameController.text,
                                                image:
                                                    _imagePath ??
                                                    widget.food.image,
                                                age:
                                                    _selectedAgeGroup ??
                                                    widget.food.age,
                                                energy:
                                                    widget
                                                        .food
                                                        .energy, // Akan diupdate di calculator jika diperlukan
                                                protein:
                                                    widget
                                                        .food
                                                        .protein, // Akan diupdate di calculator jika diperlukan
                                                fat:
                                                    widget
                                                        .food
                                                        .fat, // Akan diupdate di calculator jika diperlukan
                                                portion:
                                                    int.tryParse(
                                                      _servingsController.text,
                                                    ) ??
                                                    widget.food.portion,
                                                recipe:
                                                    _ingredientControllers
                                                        .map((c) => c.text)
                                                        .toList(),
                                                fruit:
                                                    _fruitsController
                                                            .text
                                                            .isNotEmpty
                                                        ? _fruitsController.text
                                                            .split(', ')
                                                        : widget.food.fruit,
                                                step:
                                                    _stepControllers
                                                        .map((c) => c.text)
                                                        .toList(),
                                                description:
                                                    _descriptionController.text,
                                              );

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (
                                                        context,
                                                      ) => FoodNutritionCalculatorScreen(
                                                        ingredients:
                                                            ingredients,
                                                        food: updatedFood,
                                                        image: _imageFile,
                                                        recalculateNutrition:
                                                            _ingredientsChanged,
                                                      ),
                                                ),
                                              );
                                            } else if (_showPhotoError &&
                                                _photoFieldKey.currentContext !=
                                                    null) {
                                              // Jika foto tidak valid, scroll ke field foto
                                              Scrollable.ensureVisible(
                                                _photoFieldKey.currentContext!,
                                                duration: const Duration(
                                                  milliseconds: 300,
                                                ),
                                                alignment: 0.2,
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
          );
        },
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
