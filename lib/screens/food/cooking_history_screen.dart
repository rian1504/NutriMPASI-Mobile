import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/models/food_model.dart';
import 'package:nutrimpasi/screens/food/food_detail_screen.dart';

class CookingHistoryScreen extends StatefulWidget {
  const CookingHistoryScreen({super.key});

  @override
  State<CookingHistoryScreen> createState() => _CookingHistoryScreenState();
}

class _CookingHistoryScreenState extends State<CookingHistoryScreen> {
  // Data riwayat memasak
  final List<Food> _historyItems = [
    Food.dummyFoods[0],
    Food.dummyFoods[1],
    Food.dummyFoods[2],
    Food.dummyFoods[3],
  ];

  // Data dummy nutrisi
  final Map<String, dynamic> _nutritionData = {
    'totalKcal': 2279,
    'lastMonthKcal': 2050,
    'difference': 229,
    'energy': 317,
    'protein': 127,
    'fat': 29,
  };

  // Dropdown value untuk pemilihan bayi
  String? _selectedBaby = 'Pilih Bayi';
  // Tanggal terpilih
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pearl,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
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
        title: const Text(
          'Riwayat Memasak',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian atas dengan ringkasan nutrisi
          _buildNutritionSummary(),

          // Widget untuk pemilihan bayi dan tanggal
          _buildSelectionFilters(),

          // Daftar riwayat makanan
          Expanded(child: _buildFoodHistoryList()),
        ],
      ),
    );
  }

  // Widget untuk menampilkan ringkasan nutrisi dalam bentuk chart
  Widget _buildNutritionSummary() {
    return Material(
      elevation: 8,
      shadowColor: Colors.black.withAlpha(150),
      clipBehavior: Clip.antiAlias,
      shape: PointedBottomShape(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 50,
          left: 20,
          right: 20,
        ),
        color: AppColors.primary,
        child: Column(
          children: [
            // Indikator nutrisi lingkaran dengan perbandingan bulan lalu
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Informasi bulan lalu
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bulan Lalu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${_nutritionData['lastMonthKcal']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'kkal',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(width: 20),

                // Indikator progres lingkaran
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background lingkaran
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withAlpha(50),
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: 0.75,
                          strokeWidth: 10,
                          backgroundColor: Colors.white.withAlpha(50),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.secondary,
                          ),
                        ),
                      ),
                      // Text di tengah
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${_nutritionData['totalKcal']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Total kkal',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // Informasi bulan ini
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bulan Ini',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '+${_nutritionData['difference']}',
                          style: TextStyle(
                            color: AppColors.green,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'kkal',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Indikator nutrisi per bagian (Energi, Protein, Lemak)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Indikator Energi
                  _buildVerticalNutrientIndicator(
                    'Energi',
                    _nutritionData['energy'],
                    'kkal',
                    AppColors.secondary,
                  ),

                  // Indikator Protein
                  _buildVerticalNutrientIndicator(
                    'Protein',
                    _nutritionData['protein'],
                    'g',
                    AppColors.red,
                  ),

                  // Indikator Lemak
                  _buildVerticalNutrientIndicator(
                    'Lemak',
                    _nutritionData['fat'],
                    'g',
                    AppColors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk indikator nutrisi berbentuk pil vertikal
  Widget _buildVerticalNutrientIndicator(
    String label,
    int value,
    String unit,
    Color color,
  ) {
    return Row(
      children: [
        // Container untuk indikator vertikal
        Column(
          children: [
            Container(
              width: 20,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(75),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Progres bar berbentuk pil vertikal
                  Container(
                    width: 20,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  // Lingkaran di bagian atas pil yang terisi untuk efek 3D
                  Positioned(
                    bottom: 25,
                    child: Container(
                      width: 20,
                      height: 15,
                      decoration: BoxDecoration(
                        color: color
                            .withRed(150)
                            .withBlue(150)
                            .withGreen(150)
                            .withAlpha(150),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(width: 8),

        // Teks label dan nilai di sebelah kanan pil
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Teks label
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 4),

            // Teks nilai
            Text(
              '$value$unit',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget untuk pemilihan bayi dan tanggal
  Widget _buildSelectionFilters() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Dropdown untuk memilih bayi
          Container(
            width: 100,
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedBaby,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                  size: 20,
                ),
                iconSize: 20,
                elevation: 16,
                isDense: true,
                isExpanded: true,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                dropdownColor: AppColors.primary,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedBaby = newValue;
                  });
                },
                items:
                    <String>[
                      'Pilih Bayi',
                      'Bayi 1',
                      'Bayi 2',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Tampilan tanggal terpilih
          Expanded(
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Center(
                child: Text(
                  'Jumat, 25 April',
                  style: const TextStyle(
                    color: AppColors.textBlack,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Tombol kalender dengan shadow
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                // Tampilkan date picker
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null && pickedDate != _selectedDate) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
              icon: const Icon(Icons.calendar_month, size: 20),
              color: AppColors.textBlack,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk daftar riwayat makanan
  Widget _buildFoodHistoryList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _historyItems.length,
      itemBuilder: (context, index) {
        final food = _historyItems[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodDetailScreen(foodId: food.id),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(50),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar makanan
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: Image.network(
                      food.image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Informasi makanan
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nama makanan dan sumber
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Nama makanan
                              Expanded(
                                child: Text(
                                  food.name,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textBlack,
                                  ),
                                ),
                              ),

                              // Indikator sumber
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withAlpha(25),
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  food.source == 'WHO'
                                      ? 'assets/images/icon/source_who.png'
                                      : food.source == 'KEMENKES'
                                      ? 'assets/images/icon/source_kemenkes.png'
                                      : 'assets/images/icon/source_pengguna.png',
                                  width: 16,
                                  height: 16,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Informasi nutrisi
                          Row(
                            children: [
                              // Energi
                              _buildFoodNutrientInfo('Energi', '98kkal'),

                              // Vertical divider
                              Container(
                                height: 24,
                                width: 1,
                                color: Colors.grey.shade300,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                              ),

                              // Protein
                              _buildFoodNutrientInfo('Protein', '45.1g'),

                              // Vertical divider
                              Container(
                                height: 24,
                                width: 1,
                                color: Colors.grey.shade300,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                              ),

                              // Lemak
                              _buildFoodNutrientInfo('Lemak', '3.5g'),
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
    );
  }

  // Widget untuk menampilkan informasi nutrisi per makanan
  Widget _buildFoodNutrientInfo(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom clipper untuk membuat bentuk lancip di bagian bawah
class PointedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);

    path.lineTo(size.width / 2, size.height);

    path.lineTo(size.width, size.height - 40);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Custom shape untuk memberikan shadow yang mengikuti bentuk segitiga
class PointedBottomShape extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    var path = Path();
    path.lineTo(0, rect.height - 40);

    path.lineTo(rect.width / 2, rect.height);

    path.lineTo(rect.width, rect.height - 40);

    path.lineTo(rect.width, 0);
    path.close();

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
