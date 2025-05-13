import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/models/food_model.dart';
import 'package:nutrimpasi/screens/food/food_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class CookingHistoryScreen extends StatefulWidget {
  const CookingHistoryScreen({super.key});

  @override
  State<CookingHistoryScreen> createState() => _CookingHistoryScreenState();
}

class _CookingHistoryScreenState extends State<CookingHistoryScreen> {
  // Data riwayat memasak
  final List<Food> _historyItems = Food.dummyFoodsWithDates;

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
  String _selectedBaby = 'Bayi 1';

  // Filter periode waktu
  String _selectedTimePeriod = 'Harian';

  // Data yang dikelompokkan berdasarkan waktu
  Map<String, List<Food>> _groupedData = {};

  @override
  void initState() {
    super.initState();
    // Inisialisasi format tanggal lokal Indonesia
    initializeDateFormatting('id_ID', null);

    // Inisialisasi pengelompokan data berdasarkan periode waktu default
    _groupFoodByTimePeriod();
  }

  // Mendapatkan daftar periode waktu yang tersedia berdasarkan data
  List<String> get _availableTimePeriods {
    // Periode dasar selalu tersedia
    final List<String> periods = ['Harian'];

    // Cek apakah ada data dari hari yang berbeda untuk opsi Mingguan
    final bool hasDifferentDays = _hasItemsInDifferentPeriods(
      (a, b) => a.year == b.year && a.month == b.month && a.day != b.day,
    );
    if (hasDifferentDays) {
      periods.add('Mingguan');
    }

    // Cek apakah ada data dari bulan yang berbeda untuk opsi Bulanan
    final bool hasDifferentMonths = _hasItemsInDifferentPeriods(
      (a, b) => a.year == b.year && a.month != b.month,
    );
    if (hasDifferentMonths) {
      periods.add('Bulanan');
    }

    // Cek apakah ada data dari tahun yang berbeda untuk opsi Tahunan
    final bool hasDifferentYears = _hasItemsInDifferentPeriods(
      (a, b) => a.year != b.year,
    );
    if (hasDifferentYears) {
      periods.add('Tahunan');
    }

    // Jika ada lebih dari satu periode waktu, tambahkan opsi "Semua"
    if (periods.length > 1) {
      periods.add('Semua');
    }

    return periods;
  }

  // Helper method untuk mengecek apakah item memiliki perbedaan waktu berdasarkan kondisi
  bool _hasItemsInDifferentPeriods(
    bool Function(DateTime, DateTime) condition,
  ) {
    // Filter item yang memiliki cooking date
    final items =
        _historyItems.where((food) => food.cookingDate != null).toList();
    if (items.length <= 1) return false;

    for (int i = 0; i < items.length - 1; i++) {
      final dateA = items[i].cookingDate!;

      for (int j = i + 1; j < items.length; j++) {
        final dateB = items[j].cookingDate!;

        if (condition(dateA, dateB)) {
          return true;
        }
      }
    }

    return false;
  }

  // Mengelompokkan data makanan berdasarkan periode waktu
  void _groupFoodByTimePeriod() {
    _groupedData = {};

    // Filter item yang memiliki cooking date
    final itemsWithDate =
        _historyItems.where((food) => food.cookingDate != null).toList();

    if (_selectedTimePeriod == 'Harian') {
      // Pengelompokan berdasarkan hari
      for (var food in itemsWithDate) {
        final date = food.cookingDate!;
        final today = DateTime.now();
        final yesterday = DateTime.now().subtract(const Duration(days: 1));

        String formattedDate;
        if (date.year == today.year &&
            date.month == today.month &&
            date.day == today.day) {
          formattedDate = 'Hari ini';
        } else if (date.year == yesterday.year &&
            date.month == yesterday.month &&
            date.day == yesterday.day) {
          formattedDate = 'Kemarin';
        } else {
          formattedDate = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
        }

        if (!_groupedData.containsKey(formattedDate)) {
          _groupedData[formattedDate] = [];
        }
        _groupedData[formattedDate]!.add(food);
      }
    } else if (_selectedTimePeriod == 'Mingguan') {
      // Pengelompokan berdasarkan minggu
      for (var food in itemsWithDate) {
        final date = food.cookingDate!;
        // Mendapatkan tanggal awal minggu (Senin)
        final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
        // Mendapatkan tanggal akhir minggu (Minggu)
        final endOfWeek = startOfWeek.add(const Duration(days: 6));

        final String weekRange =
            '${DateFormat('d MMM', 'id_ID').format(startOfWeek)} - ${DateFormat('d MMM yyyy', 'id_ID').format(endOfWeek)}';

        if (!_groupedData.containsKey(weekRange)) {
          _groupedData[weekRange] = [];
        }
        _groupedData[weekRange]!.add(food);
      }
    } else if (_selectedTimePeriod == 'Bulanan') {
      // Pengelompokan berdasarkan bulan
      for (var food in itemsWithDate) {
        final date = food.cookingDate!;
        final String month = DateFormat('MMMM yyyy', 'id_ID').format(date);

        if (!_groupedData.containsKey(month)) {
          _groupedData[month] = [];
        }
        _groupedData[month]!.add(food);
      }
    } else if (_selectedTimePeriod == 'Tahunan') {
      // Pengelompokan berdasarkan tahun
      for (var food in itemsWithDate) {
        final date = food.cookingDate!;
        final String year = DateFormat('yyyy', 'id_ID').format(date);

        if (!_groupedData.containsKey(year)) {
          _groupedData[year] = [];
        }
        _groupedData[year]!.add(food);
      }
    } else {
      // "Semua" - Tampilkan semua data tanpa pengelompokan
      _groupedData = {'Semua Waktu': itemsWithDate};
    }

    // Jika tidak ada data, tampilkan pesan
    if (_groupedData.isEmpty) {
      _groupedData = {'Tidak ada data': []};
    }

    setState(() {});
  }

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
    return Stack(
      children: [
        // Container dengan bentuk lancip di bagian bawah menggunakan ClipPath
        ClipPath(
          clipper: PointedBottomClipper(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 50,
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(150),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
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
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
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
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
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
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
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
        ),
      ],
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

  // Helper untuk memotong teks nama bayi yang terlalu panjang
  String _truncateBabyName(String name) {
    const int charsPerLine = 15;
    const int maxLines = 2;
    const int maxChars = charsPerLine * maxLines;

    if (name.length <= maxChars) {
      return name;
    }

    return '${name.substring(0, maxChars - 3)}...';
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
                    _selectedBaby = newValue!;
                  });
                },
                selectedItemBuilder: (BuildContext context) {
                  return <String>[
                    'Bayi 1',
                    'Bayi 2 Bayi 2 Bayi 2 Bayi 2 Bayi 2 Bayi 2 Bayi 2 Bayi 2',
                    'Bayi 3',
                  ].map<Widget>((String value) {
                    return Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _truncateBabyName(value),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList();
                },
                items:
                    <String>[
                      'Bayi 1',
                      'Bayi 2 Bayi 2 Bayi 2 Bayi 2 Bayi 2 Bayi 2 Bayi 2 Bayi 2',
                      'Bayi 3',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Tampilan periode waktu terpilih
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
                  _selectedTimePeriod,
                  style: const TextStyle(
                    color: AppColors.textBlack,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Tombol filter
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
              onPressed: () {
                // Tampilkan bottom sheet filter
                _showFilterBottomSheet(context);
              },
              icon: const Icon(Symbols.filter_list, size: 20),
              color: AppColors.textBlack,
            ),
          ),
        ],
      ),
    );
  }

  // Menampilkan bottom sheet untuk filter waktu
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indikator panel
            Center(
              child: Container(
                height: 5,
                width: 75,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.componentGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            // Judul
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Text(
                'Pilih Rentang Waktu',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
            ),

            // Grid opsi filter
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final List<String> periods = _availableTimePeriods;
                  final isOdd = periods.length % 2 != 0;
                  final lastItemIndex = periods.length - 1;

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.start,
                    children: List.generate(periods.length, (index) {
                      final period = periods[index];
                      final isLastItem = index == lastItemIndex;

                      // Kalkulasi lebar item (setengah dari total lebar - padding)
                      final itemWidth = (constraints.maxWidth - 12) / 2;

                      return SizedBox(
                        width:
                            (isOdd && isLastItem)
                                ? constraints.maxWidth
                                : itemWidth,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedTimePeriod = period;
                            });
                            _groupFoodByTimePeriod();
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  _selectedTimePeriod == period
                                      ? AppColors.primary
                                      : AppColors.buff,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                period,
                                style: TextStyle(
                                  color:
                                      _selectedTimePeriod == period
                                          ? Colors.white
                                          : AppColors.textBlack,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // Widget untuk daftar riwayat makanan
  Widget _buildFoodHistoryList() {
    // Jika tidak ada data
    if (_groupedData.isEmpty ||
        (_groupedData.length == 1 && _groupedData.values.first.isEmpty)) {
      return const Center(
        child: Text(
          'Tidak ada riwayat memasak',
          style: TextStyle(fontSize: 16, color: AppColors.textGrey),
        ),
      );
    }

    // Jika periode waktu adalah "Semua", tampilkan daftar sederhana
    if (_selectedTimePeriod == 'Semua') {
      final foods = _groupedData.values.first;
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final food = foods[index];
          return _buildFoodHistoryItem(food);
        },
      );
    }

    // Untuk periode waktu lainnya, tampilkan accordion
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _groupedData.keys.length,
      itemBuilder: (context, index) {
        final timeGroup = _groupedData.keys.elementAt(index);
        final foodsInGroup = _groupedData[timeGroup]!;

        // Jika tidak ada makanan dalam grup ini, tampilkan pesan
        if (foodsInGroup.isEmpty) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(30),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(
                  timeGroup,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textBlack,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Tidak ada data',
                  style: TextStyle(fontSize: 14, color: AppColors.textGrey),
                ),
              ],
            ),
          );
        }

        return _buildAccordionGroup(timeGroup, foodsInGroup);
      },
    );
  }

  // Widget untuk grup accordion
  Widget _buildAccordionGroup(String groupTitle, List<Food> foods) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        title: Text(
          groupTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.textBlack,
          ),
        ),
        children:
            foods.map((food) {
              return Container(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: _buildFoodHistoryItem(food),
              );
            }).toList(),
      ),
    );
  }

  // Widget untuk item makanan pada daftar riwayat
  Widget _buildFoodHistoryItem(Food food) {
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
                      // Nama makanan dan porsi
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
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Informasi porsi
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.buff,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/icon/set_makanan.png',
                                  width: 14,
                                  height: 14,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${food.portion} Porsi',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textBlack,
                                  ),
                                ),
                              ],
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
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                          ),

                          // Protein
                          _buildFoodNutrientInfo('Protein', '45.1g'),

                          // Vertical divider
                          Container(
                            height: 24,
                            width: 1,
                            color: Colors.grey.shade300,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
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
    final path = Path();
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
