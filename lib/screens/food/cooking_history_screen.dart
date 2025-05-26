import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/blocs/baby/baby_bloc.dart';
import 'package:nutrimpasi/blocs/food_record/food_record_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/baby.dart';
import 'package:nutrimpasi/models/food_record.dart';
import 'package:nutrimpasi/screens/food/food_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class CookingHistoryScreen extends StatefulWidget {
  const CookingHistoryScreen({super.key});

  @override
  State<CookingHistoryScreen> createState() => _CookingHistoryScreenState();
}

class _CookingHistoryScreenState extends State<CookingHistoryScreen>
    with SingleTickerProviderStateMixin {
  // Data riwayat memasak
  List<FoodRecord> _historyItems = [];

  // Data bayi
  List<Baby> _babies = [];

  // Data nutrisi
  Map<String, dynamic> _nutritionData = {};

  // Dropdown value untuk pemilihan bayi
  late String _selectedBaby;

  // Filter periode waktu
  String _selectedTimePeriod = 'Hari ini';

  // Data yang dikelompokkan berdasarkan waktu
  Map<String, List<FoodRecord>> _groupedData = {};

  // Animation controller untuk indikator progres
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  // Animasi untuk semua nilai nutrisi
  late Animation<int> _calorieCountAnimation;
  late Animation<int> _lastMonthCalorieAnimation;
  late Animation<int> _differenceAnimation;
  late Animation<int> _energyAnimation;
  late Animation<int> _proteinAnimation;
  late Animation<int> _fatAnimation;

  @override
  void initState() {
    super.initState();

    // Inisialisasi animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Inisialisasi animasi progres
    _progressAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Inisialisasi animasi untuk semua nilai nutrisi
    _calorieCountAnimation = IntTween(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _lastMonthCalorieAnimation = IntTween(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _differenceAnimation = IntTween(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _energyAnimation = IntTween(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _proteinAnimation = IntTween(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _fatAnimation = IntTween(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Load data
    final babyState = context.read<BabyBloc>().state;
    if (babyState is! BabyLoaded) {
      context.read<BabyBloc>().add(FetchBabies());
    } else {
      // Jika data sudah ter-load, perbarui status loading
      setState(() {
        _babies = babyState.babies;
        _selectedBaby = _babies.first.id.toString();
      });
    }

    // Load data makanan
    context.read<FoodRecordBloc>().add(FetchFoodRecords());

    // Inisialisasi format tanggal lokal Indonesia
    initializeDateFormatting('id_ID', null);

    // Inisialisasi pengelompokan data berdasarkan periode waktu default
    _groupFoodByTimePeriod();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Mendapatkan daftar periode waktu yang tersedia berdasarkan data
  List<String> get _availableTimePeriods {
    // Periode dasar selalu tersedia
    final List<String> periods = ['Hari ini'];

    // Selalu tampilkan Mingguan dan Bulanan
    periods.add('Mingguan');
    periods.add('Bulanan');

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
    // final items = _historyItems.where((food) => food.date != null).toList();
    final items = _historyItems.toList();
    if (items.length <= 1) return false;

    for (int i = 0; i < items.length - 1; i++) {
      final dateA = items[i].date;

      for (int j = i + 1; j < items.length; j++) {
        final dateB = items[j].date;

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
    final now = DateTime.now();

    // Filter item yang memiliki cooking date
    final itemsWithDate = _historyItems.toList();

    if (_selectedTimePeriod == 'Hari ini') {
      // Hanya ambil data hari ini
      final todayItems =
          itemsWithDate
              .where(
                (food) =>
                    food.date.year == now.year &&
                    food.date.month == now.month &&
                    food.date.day == now.day,
              )
              .toList();

      _groupedData = {'Hari ini': todayItems};
    } else if (_selectedTimePeriod == 'Mingguan') {
      // Kelompokkan menjadi minggu 1-4 bulan ini
      for (int week = 1; week <= 4; week++) {
        final startDate = DateTime(now.year, now.month, 1 + (week - 1) * 7);
        final endDate =
            week == 4
                ? DateTime(now.year, now.month + 1, 0)
                : DateTime(now.year, now.month, week * 7);

        final weekItems =
            itemsWithDate
                .where(
                  (food) =>
                      food.date.isAfter(
                        startDate.subtract(const Duration(days: 1)),
                      ) &&
                      food.date.isBefore(endDate.add(const Duration(days: 1))),
                )
                .toList();

        if (weekItems.isNotEmpty) {
          _groupedData['Minggu $week'] = weekItems;
        }
      }
    } else if (_selectedTimePeriod == 'Bulanan') {
      // Kelompokkan menjadi 12 bulan tahun ini
      for (int month = 1; month <= 12; month++) {
        final firstDay = DateTime(now.year, month, 1);
        final lastDay = DateTime(now.year, month + 1, 0);

        final monthItems =
            itemsWithDate
                .where(
                  (food) =>
                      food.date.isAfter(
                        firstDay.subtract(const Duration(days: 1)),
                      ) &&
                      food.date.isBefore(lastDay.add(const Duration(days: 1))),
                )
                .toList();

        if (monthItems.isNotEmpty) {
          _groupedData[DateFormat('MMMM', 'id_ID').format(firstDay)] =
              monthItems;
        }
      }
    } else if (_selectedTimePeriod == 'Tahunan') {
      // Kelompokkan per tahun (hanya tahun yang ada datanya)
      final years = <int>{};
      for (var food in itemsWithDate) {
        years.add(food.date.year);
      }

      for (var year in years) {
        final yearItems =
            itemsWithDate.where((food) => food.date.year == year).toList();

        _groupedData[year.toString()] = yearItems;
      }
    } else {
      // "Semua" - Tampilkan semua data tanpa pengelompokan
      _groupedData = {'Semua Waktu': itemsWithDate};
    }

    // Jika tidak ada data, tampilkan pesan
    if (_groupedData.isEmpty) {
      _groupedData = {'Tidak ada data': []};
    }

    // Setelah pengelompokan, hitung data nutrisi
    _nutritionData = _calculateNutritionData(itemsWithDate);

    // Aktifkan animasi jika data nutrisi tersedia
    if (_nutritionData.containsKey('currentMonthKcal') &&
        _nutritionData.containsKey('recommendedCalories')) {
      final double targetValue =
          (_nutritionData['currentMonthKcal'] ?? 0) /
          (_nutritionData['recommendedCalories'] ?? 6000);

      final int targetCalories = _nutritionData['currentMonthKcal'] ?? 0;
      final int targetLastMonthCalories = _nutritionData['lastMonthKcal'] ?? 0;
      final int targetDifference = _nutritionData['difference'] ?? 0;
      final int targetEnergy = _nutritionData['energy'] ?? 0;
      final int targetProtein = _nutritionData['protein'] ?? 0;
      final int targetFat = _nutritionData['fat'] ?? 0;

      // Reset animasi
      _animationController.reset();

      // Perbarui nilai animasi progres
      _progressAnimation = Tween<double>(
        begin: 0.0,
        end: targetValue > 1.0 ? 1.0 : targetValue,
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      );

      // Perbarui animasi untuk semua nilai nutrisi
      _calorieCountAnimation = IntTween(begin: 0, end: targetCalories).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      );

      _lastMonthCalorieAnimation = IntTween(
        begin: 0,
        end: targetLastMonthCalories,
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      );

      _differenceAnimation = IntTween(
        begin: 0,
        end: targetDifference.abs(),
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      );

      _energyAnimation = IntTween(begin: 0, end: targetEnergy).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      );

      _proteinAnimation = IntTween(begin: 0, end: targetProtein).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      );

      _fatAnimation = IntTween(begin: 0, end: targetFat).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      );

      // Mulai animasi
      _animationController.forward();
    }

    setState(() {});
  }

  Map<String, dynamic> _calculateNutritionData(List<FoodRecord> foods) {
    // Hitung nutrisi bulan ini
    final currentMonthNutrition = _calculateCurrentMonthNutrition(foods);

    // Hitung kalori bulan ini dan bulan lalu
    int currentMonthKcal = _calculateCurrentMonthKcal(foods);
    int lastMonthKcal = _calculateLastMonthKcal(foods).round();
    int difference = currentMonthKcal - lastMonthKcal;

    // Hitung rekomendasi kalori sesuai umur bayi
    int recommendedCalories = _calculateRecommendedCaloriesPerMonth();

    return {
      'currentMonthKcal': currentMonthKcal,
      'lastMonthKcal': lastMonthKcal,
      'difference': difference,
      'energy': currentMonthNutrition['energy']!.round(),
      'protein': currentMonthNutrition['protein']!.round(),
      'fat': currentMonthNutrition['fat']!.round(),
      'recommendedCalories': recommendedCalories,
    };
  }

  // Menghitung rekomendasi kalori per bulan berdasarkan umur bayi
  int _calculateRecommendedCaloriesPerMonth() {
    // Temukan data bayi yang dipilih
    if (_babies.isEmpty) {
      return 6000;
    }

    final selectedBabyObject = _babies.firstWhere(
      (baby) => baby.id.toString() == _selectedBaby,
      orElse: () => _babies.first,
    );

    if (selectedBabyObject.dob == null) {
      return 6000;
    }

    // Hitung umur dalam bulan
    final now = DateTime.now();
    final birthDate = selectedBabyObject.dob!;
    int ageInMonths =
        (now.year - birthDate.year) * 12 + now.month - birthDate.month;
    if (now.day < birthDate.day) {
      ageInMonths--;
    }

    // Tentukan rekomendasi kalori sesuai rentang umur
    if (ageInMonths > 23) {
      return 32000;
    } else if (ageInMonths >= 12 && ageInMonths <= 23) {
      return 16500;
    } else if (ageInMonths >= 9 && ageInMonths < 12) {
      return 9000;
    } else {
      return 6000;
    }
  }

  int _calculateCurrentMonthKcal(List<FoodRecord> foods) {
    // Jika tidak ada data makanan sama sekali, langsung return 0
    if (foods.isEmpty) return 0;

    final nutrition = _calculateCurrentMonthNutrition(foods);

    // Convert nutrition values to double with null safety
    final energy = nutrition['energy'] ?? 0.0;
    final protein = nutrition['protein'] ?? 0.0;
    final fat = nutrition['fat'] ?? 0.0;

    // Calculate total calories with proper rounding
    return (energy + (protein * 4) + (fat * 9)).round();
  }

  double _calculateLastMonthKcal(List<FoodRecord> foods) {
    // Jika tidak ada data makanan sama sekali, langsung return 0
    if (foods.isEmpty) return 0;

    final now = DateTime.now();
    final firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
    final firstDayOfLastMonth = DateTime(now.year, now.month - 1, 1);

    double lastMonthTotal = 0;
    bool hasLastMonthData = false;

    for (var food in foods) {
      if (food.date.isAfter(
            firstDayOfLastMonth.subtract(const Duration(days: 1)),
          ) &&
          food.date.isBefore(firstDayOfCurrentMonth)) {
        lastMonthTotal += food.energy + (food.protein * 4) + (food.fat * 9);
        hasLastMonthData = true;
      }
    }

    // Jika tidak ada data di bulan lalu, return 0
    return hasLastMonthData ? lastMonthTotal : 0;
  }

  Map<String, double> _calculateCurrentMonthNutrition(List<FoodRecord> foods) {
    final now = DateTime.now();
    final firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
    final lastDayOfCurrentMonth = DateTime(now.year, now.month + 1, 0);

    double energy = 0;
    double protein = 0;
    double fat = 0;

    for (var food in foods) {
      if (food.date.isAfter(
            firstDayOfCurrentMonth.subtract(const Duration(days: 1)),
          ) &&
          food.date.isBefore(
            lastDayOfCurrentMonth.add(const Duration(days: 1)),
          )) {
        energy += food.energy;
        protein += food.protein;
        fat += food.fat;
      }
    }

    return {'energy': energy, 'protein': protein, 'fat': fat};
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BabyBloc, BabyState>(
          listener: (context, state) {
            if (state is BabyLoaded) {
              setState(() {
                _babies = state.babies;
                _selectedBaby = _babies.first.name;
              });
            }
          },
        ),
        BlocListener<FoodRecordBloc, FoodRecordState>(
          listener: (context, state) {
            if (state is FoodRecordLoaded) {
              setState(() {
                _historyItems =
                    state.foodRecords
                        .where(
                          (food) => food.babyId.toString() == _selectedBaby,
                        )
                        .toList();
                _groupFoodByTimePeriod();
              });
            } else if (state is FoodRecordError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
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
        body: BlocBuilder<FoodRecordBloc, FoodRecordState>(
          builder: (context, state) {
            if (state is FoodRecordLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FoodRecordError) {
              return Center(child: Text(state.error));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bagian atas dengan ringkasan nutrisi
                _buildNutritionSummary(),

                // Widget untuk pemilihan bayi dan tanggal
                _buildSelectionFilters(),

                // Daftar riwayat makanan
                Expanded(child: _buildFoodHistoryList()),
              ],
            );
          },
        ),
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
                            AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return Text(
                                  '${_lastMonthCalorieAnimation.value}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
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
                      width: 150,
                      height: 150,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background lingkaran
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withAlpha(50),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return SizedBox(
                                width: 150,
                                height: 150,
                                child: CircularProgressIndicator(
                                  // Nilai progress berdasarkan animasi
                                  value: _progressAnimation.value,
                                  strokeWidth: 10,
                                  backgroundColor: Colors.white.withAlpha(50),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        AppColors.accent,
                                      ),
                                ),
                              );
                            },
                          ),
                          // Text di tengah
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return Text(
                                    '${_calorieCountAnimation.value}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Total kkal Bulan ini',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () {
                                      _showRecommendationInfo(context);
                                    },
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(75),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.info_outline,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
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
                            AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                final prefix =
                                    _nutritionData['difference'] >= 0
                                        ? '+'
                                        : '-';
                                return Text(
                                  '$prefix${_differenceAnimation.value}',
                                  style: TextStyle(
                                    color:
                                        _nutritionData['difference'] >= 0
                                            ? AppColors.green
                                            : AppColors.red,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
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
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return _buildVerticalNutrientIndicator(
                            'Energi',
                            _energyAnimation.value,
                            'kkal',
                            AppColors.accent,
                          );
                        },
                      ),

                      // Indikator Protein
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return _buildVerticalNutrientIndicator(
                            'Protein',
                            _proteinAnimation.value,
                            'g',
                            AppColors.red,
                          );
                        },
                      ),

                      // Indikator Lemak
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return _buildVerticalNutrientIndicator(
                            'Lemak',
                            _fatAnimation.value,
                            'g',
                            AppColors.green,
                          );
                        },
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
              '${value.toInt()}$unit',
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
                  final currentState = context.read<FoodRecordBloc>().state;
                  if (currentState is FoodRecordLoaded) {
                    setState(() {
                      _selectedBaby = newValue!;

                      _historyItems =
                          currentState.foodRecords
                              .where(
                                (food) =>
                                    food.babyId.toString() == _selectedBaby,
                              )
                              .toList();
                      _groupFoodByTimePeriod();
                    });
                  }
                },
                selectedItemBuilder: (BuildContext context) {
                  return _babies.map<Widget>((baby) {
                    return Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _truncateBabyName(baby.name),
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
                    _babies.map<DropdownMenuItem<String>>((baby) {
                      return DropdownMenuItem<String>(
                        value: baby.id.toString(),
                        child: Text(
                          baby.name,
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
  Widget _buildAccordionGroup(String groupTitle, List<FoodRecord> foods) {
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
  Widget _buildFoodHistoryItem(FoodRecord food) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          if (food.foodId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data makanan sudah tidak tersedia'),
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        FoodDetailScreen(foodId: food.foodId.toString()),
              ),
            );
          }
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
                  storageUrl + food.image,
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
                          _buildFoodNutrientInfo(
                            'Energi',
                            '${food.energy}kkal',
                          ),

                          // Vertical divider
                          Container(
                            height: 24,
                            width: 1,
                            color: Colors.grey.shade300,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                          ),

                          // Protein
                          _buildFoodNutrientInfo('Protein', '${food.protein}g'),

                          // Vertical divider
                          Container(
                            height: 24,
                            width: 1,
                            color: Colors.grey.shade300,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                          ),

                          // Lemak
                          _buildFoodNutrientInfo('Lemak', '${food.fat}g'),
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

  // Method untuk menampilkan info rekomendasi kalori
  void _showRecommendationInfo(BuildContext context) {
    final int recommended = _nutritionData['recommendedCalories'] ?? 6000;
    final int current = _nutritionData['currentMonthKcal'] ?? 0;
    final double percentage = (current / recommended * 100).roundToDouble();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Informasi Asupan Kalori',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rekomendasi kalori: $recommended kkal/bulan',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                'Total konsumsi: $current kkal (${percentage.toStringAsFixed(1)}%)',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              _getRecommendationText(percentage),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tutup'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    );
  }

  // Helper untuk menampilkan teks rekomendasi berdasarkan persentase konsumsi
  Widget _getRecommendationText(double percentage) {
    String message;
    Color messageColor;

    if (percentage < 60) {
      message =
          'Asupan kalori masih kurang dari kebutuhan bulanan yang direkomendasikan.';
      messageColor = AppColors.red;
    } else if (percentage > 110) {
      message =
          'Asupan kalori melebihi kebutuhan bulanan yang direkomendasikan.';
      messageColor = Colors.orange;
    } else {
      message =
          'Asupan kalori sudah sesuai dengan kebutuhan bulanan yang direkomendasikan.';
      messageColor = AppColors.green;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: messageColor.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 12,
          color: messageColor,
          fontWeight: FontWeight.w500,
        ),
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
