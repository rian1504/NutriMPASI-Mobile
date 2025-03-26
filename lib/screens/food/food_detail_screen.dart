import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/screens/food/cooking_guide_screen.dart';
import 'package:nutrimpasi/models/food_model.dart';
import 'package:nutrimpasi/models/food_category_model.dart';

class FoodDetailScreen extends StatefulWidget {
  final String foodId;
  const FoodDetailScreen({super.key, required this.foodId});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  // Variabel untuk menyimpan status favorit dan jumlah favorit
  bool _isFavorite = false;
  int _favoriteCount = 12;
  late Food _food;

  @override
  void initState() {
    super.initState();
    // Mendapatkan data makanan berdasarkan ID
    _food = Food.dummyFoods.firstWhere((food) => food.id == widget.foodId);
    _isFavorite = _food.isFavorite;
  }

  // Fungsi untuk mengubah status favorit dan jumlah favorit
  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
      if (_isFavorite) {
        _favoriteCount++;
      } else {
        _favoriteCount--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Bagian Konten Utama
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bagian atas
                  Stack(
                    children: [
                      // Background gambar
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).padding.top + 325,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.05, 0.41, 0.72, 1.0],
                            colors: [
                              Color(0xFFFFE1BE),
                              Color(0xFFFFC698),
                              Color(0xFFFFAC84),
                              Color(0xFFFF7F53),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.elliptical(200, 90),
                            bottomRight: Radius.elliptical(200, 90),
                          ),
                        ),
                      ),

                      // Tombol kembali
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 16,
                        left: 16,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                            elevation: 2,
                          ),
                          child: const Icon(
                            Symbols.arrow_back_ios_new,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),

                      Positioned(
                        top: MediaQuery.of(context).padding.top + 60,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Bagian gambar makanan
                              Container(
                                width: 225,
                                height: 225,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(25),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    _food.image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Tombol Favorit
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 270,
                        right: 24,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(25),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  _isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                                onPressed: _toggleFavorite,
                                padding: EdgeInsets.zero,
                              ),
                              Positioned(
                                bottom: 4,
                                child: Text(
                                  _favoriteCount.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Bagian informasi makanan
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Judul makanan
                        Text(
                          _food.name,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            // Rentang usia
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withAlpha(25),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _food.age,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            // Kategori makanan
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha(25),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                FoodCategory.dummyCategories
                                    .firstWhere(
                                      (category) =>
                                          category.id == _food.foodCategoryId,
                                    )
                                    .name,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Sumber resep
                        const Text(
                          'Resep oleh: ',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: AppColors.textGrey,
                          ),
                        ),
                        Row(
                          children: [
                            if (_food.source == 'WHO')
                              Image.asset(
                                'assets/images/logo_who.png',
                                width: 100,
                                height: 30,
                              )
                            else if (_food.source == 'KEMENKES')
                              Image.asset(
                                'assets/images/logo_kemenkes.png',
                                width: 100,
                                height: 30,
                              )
                            else if (_food.source == 'Pengguna')
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    size: 24,
                                    color: AppColors.secondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Pengguna',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Deskripsi makanan
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Deskripsi',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondary,
                              ),
                            ),

                            const SizedBox(height: 8),

                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.075,
                              child: SingleChildScrollView(
                                child: Text(
                                  _food.description,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: AppColors.textGrey,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // Informasi nutrisi
                        Text(
                          'Nutrisi Per Set (${_food.portion} Porsi)',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withAlpha(50),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Bagian energi
                              _buildNutritionCard(
                                'Energi',
                                '${_food.energy}',
                                'kkal',
                              ),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.grey.withAlpha(75),
                              ),
                              // Bagian Protein
                              _buildNutritionCard(
                                'Protein',
                                '${_food.protein}',
                                'g',
                              ),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.grey.withAlpha(75),
                              ),
                              // Bagian Lemak
                              _buildNutritionCard('Lemak', '${_food.fat}', 'g'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          // Bagian aksi
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(75),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 32.0,
                horizontal: 32.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tombol tambahkan ke jadwal
                  ElevatedButton(
                    onPressed: () {
                      // Pop up tambah jadwal
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // Menggunakan Map untuk menyimpan status checkbox bayi
                          Map<String, bool> selectedBabies = {
                            'Bayi 1': false,
                            'Bayi 2': false,
                          };
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () => Navigator.pop(context),
                                          customBorder: const CircleBorder(),
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.secondary,
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: Text(
                                      'Atur Jadwal Memasak',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Bagian pemilihan bayi
                                  const Text(
                                    'Pilih Profil Bayi',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      color: AppColors.textGrey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  StatefulBuilder(
                                    builder: (context, setState) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: selectedBabies['Bayi 1'],
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedBabies['Bayi 1'] =
                                                        value!;
                                                  });
                                                },
                                                activeColor: AppColors.primary,
                                              ),
                                              const Text(
                                                'Bayi 1',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: selectedBabies['Bayi 2'],
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedBabies['Bayi 2'] =
                                                        value!;
                                                  });
                                                },
                                                activeColor: AppColors.primary,
                                              ),
                                              const Text(
                                                'Bayi 2',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Bagian tanggal
                                  const Text(
                                    'Pilih Penjadwalan',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      color: AppColors.textGrey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  InkWell(
                                    onTap: () async {
                                      final DateTime? picked =
                                          await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.now().add(
                                              const Duration(days: 6),
                                            ),
                                          );
                                      if (picked != null) {
                                        // TODO: Logika untuk memilih jadwal
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.componentGrey!,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text(
                                            'Pilih Tanggal',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              color: AppColors.textGrey,
                                            ),
                                          ),
                                          Icon(
                                            Symbols.calendar_month,
                                            size: 20,
                                            color: AppColors.textGrey,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Tombol simpan
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // TODO: Logika untuk menyimpan jadwal
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                      child: const Text(
                                        'Simpan',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      elevation: 2,
                    ),
                    child: const Icon(Symbols.calendar_add_on, size: 28),
                  ),

                  const SizedBox(width: 16),

                  // Tombol masak sekarang
                  ElevatedButton(
                    onPressed: () {
                      // Pop up masak sekarang
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // Menggunakan Map untuk menyimpan status checkbox bayi
                          Map<String, bool> selectedBabies = {
                            'Bayi 1': false,
                            'Bayi 2': false,
                          };
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () => Navigator.pop(context),
                                          customBorder: const CircleBorder(),
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.secondary,
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: Text(
                                      'Masak Sekarang',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Bagian pemilihan bayi
                                  const Text(
                                    'Pilih Profil Bayi',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      color: AppColors.textGrey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  StatefulBuilder(
                                    builder: (context, setState) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: selectedBabies['Bayi 1'],
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedBabies['Bayi 1'] =
                                                        value!;
                                                  });
                                                },
                                                activeColor: AppColors.primary,
                                              ),
                                              const Text(
                                                'Bayi 1',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: selectedBabies['Bayi 2'],
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedBabies['Bayi 2'] =
                                                        value!;
                                                  });
                                                },
                                                activeColor: AppColors.primary,
                                              ),
                                              const Text(
                                                'Bayi 2',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 24),

                                  // Tombol Lanjut
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => CookingGuideScreen(
                                                  foodId: _food.id,
                                                ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                      child: const Text(
                                        'Lanjutkan',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      elevation: 2,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Masak Sekarang',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 10),
                          const Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membangun card nutrisi
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
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: AppColors.textGrey,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
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
