import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/blocs/baby/baby_bloc.dart';
import 'package:nutrimpasi/blocs/food_record/food_record_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/baby.dart';
import 'package:nutrimpasi/models/food_record.dart';
import 'package:nutrimpasi/screens/food/food_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nutrimpasi/utils/flushbar.dart';
import 'package:nutrimpasi/widgets/custom_button.dart';

class CookingHistoryScreen extends StatefulWidget {
  final String? babyId;

  const CookingHistoryScreen({this.babyId, super.key});

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

  // Nilai dropdown untuk pemilihan bayi
  late String _selectedBaby;

  // Filter periode waktu
  String _selectedTimePeriod = 'Hari ini';

  // Data yang dikelompokkan berdasarkan waktu
  Map<String, List<FoodRecord>> _groupedData = {};

  // Kunci global untuk mendapatkan posisi tombol dropdown bayi
  final GlobalKey _babyDropdownButtonKey = GlobalKey();

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

  // Flag untuk melacak apakah kita harus menganimasikan data nutrisi
  bool _shouldAnimateNutrition = true;

  // Map untuk melacak grup yang sedang diperluas untuk setiap jenis periode
  final Map<String, Set<String>> _expandedGroups = {
    'Hari ini': {},
    'Minggu ini': {},
    'Bulan ini': {},
    'Tahun ini': {},
    'Semua': {},
  };

  @override
  void initState() {
    super.initState();

    // Inisialisasi animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Nilai awal default untuk animasi
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

    // Muat data
    final babyState = context.read<BabyBloc>().state;
    if (babyState is! BabyLoaded) {
      context.read<BabyBloc>().add(FetchBabies());
    } else {
      // Jika data sudah ter-load, perbarui status loading
      setState(() {
        _babies = babyState.babies;
        // Gunakan babyId dari parameter jika tersedia
        _selectedBaby = widget.babyId ?? _babies.first.id.toString();
      });
    }

    // Muat data makanan
    context.read<FoodRecordBloc>().add(FetchFoodRecords());

    // Inisialisasi format tanggal lokal Indonesia
    initializeDateFormatting('id_ID', null);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Mendapatkan daftar periode waktu yang tersedia berdasarkan data
  List<String> get _availableTimePeriods {
    return ['Hari ini', 'Minggu ini', 'Bulan ini', 'Tahun ini', 'Semua'];
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
    } else if (_selectedTimePeriod == 'Minggu ini') {
      // Tentukan tanggal awal minggu ini (Senin)
      final DateTime startOfWeek = now.subtract(
        Duration(days: now.weekday - 1),
      );

      // Kelompokkan berdasarkan hari dalam seminggu
      final Map<String, String> dayNames = {
        '1': 'Senin',
        '2': 'Selasa',
        '3': 'Rabu',
        '4': 'Kamis',
        '5': 'Jumat',
        '6': 'Sabtu',
        '7': 'Minggu',
      };

      for (int i = 0; i < 7; i++) {
        final day = startOfWeek.add(Duration(days: i));
        final dayName = dayNames['${day.weekday}']!;
        final dateStr = DateFormat('d MMM', 'id_ID').format(day);

        if (day.isAfter(now)) continue;

        final dayItems =
            itemsWithDate
                .where(
                  (food) =>
                      food.date.year == day.year &&
                      food.date.month == day.month &&
                      food.date.day == day.day,
                )
                .toList();

        if (dayItems.isNotEmpty || day.day == now.day) {
          _groupedData['$dayName, $dateStr'] = dayItems;
        }
      }
    } else if (_selectedTimePeriod == 'Bulan ini') {
      // Kelompokkan menjadi minggu 1-4 bulan ini
      final DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

      for (int week = 1; week <= 5; week++) {
        final startDate = DateTime(now.year, now.month, 1 + (week - 1) * 7);
        final endDate = DateTime(now.year, now.month, week * 7);

        // Skip jika minggu ini sudah melewati bulan
        if (startDate.isAfter(lastDayOfMonth)) continue;

        final adjustedEndDate =
            endDate.isAfter(lastDayOfMonth) ? lastDayOfMonth : endDate;

        final weekItems =
            itemsWithDate
                .where(
                  (food) =>
                      food.date.isAfter(
                        startDate.subtract(const Duration(days: 1)),
                      ) &&
                      food.date.isBefore(
                        adjustedEndDate.add(const Duration(days: 1)),
                      ),
                )
                .toList();

        final startDateStr = DateFormat('d', 'id_ID').format(startDate);
        final endDateStr = DateFormat('d MMM', 'id_ID').format(
          adjustedEndDate.isBefore(lastDayOfMonth)
              ? adjustedEndDate
              : lastDayOfMonth,
        );

        if (weekItems.isNotEmpty ||
            week == 1 ||
            (now.day >= startDate.day && now.day <= adjustedEndDate.day)) {
          _groupedData['Minggu $week ($startDateStr-$endDateStr)'] = weekItems;
        }
      }
    } else if (_selectedTimePeriod == 'Tahun ini') {
      // Kelompokkan berdasarkan bulan dalam tahun
      for (int month = 1; month <= 12; month++) {
        final firstDay = DateTime(now.year, month, 1);
        final lastDay = DateTime(now.year, month + 1, 0);

        // Skip bulan depan
        if (firstDay.isAfter(now)) continue;

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

        final monthName = DateFormat('MMMM', 'id_ID').format(firstDay);

        if (monthItems.isNotEmpty || month == now.month) {
          _groupedData[monthName] = monthItems;
        }
      }
    } else {
      // "Semua"
      final years = <int>{};
      for (var food in itemsWithDate) {
        years.add(food.date.year);
      }

      final sortedYears = years.toList()..sort((a, b) => b.compareTo(a));

      for (var year in sortedYears) {
        final yearItems =
            itemsWithDate.where((food) => food.date.year == year).toList();
        _groupedData['$year'] = yearItems;
      }
    }

    // Jika tidak ada data, tampilkan pesan
    if (_groupedData.isEmpty) {
      _groupedData = {'Tidak ada data': []};
    }

    // Setelah pengelompokan, hitung data nutrisi
    _nutritionData = _calculateNutritionData(itemsWithDate);

    // Atur nilai target akhir non-zero untuk animasi
    final double targetValue =
        (_nutritionData['currentMonthKcal'] ?? 0) /
        (_nutritionData['recommendedCalories'] ?? 6000);

    final int targetCalories = _nutritionData['currentMonthKcal'] ?? 0;
    final int targetLastMonthCalories = _nutritionData['lastMonthKcal'] ?? 0;
    final int targetDifference = _nutritionData['difference'] ?? 0;
    final int targetEnergy = _nutritionData['energy'] ?? 0;
    final int targetProtein = _nutritionData['protein'] ?? 0;
    final int targetFat = _nutritionData['fat'] ?? 0;

    // Perbarui target animasi terlepas dari flag animasi
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: targetValue > 1.0 ? 1.0 : targetValue,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

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

    // Selalu reset animation controller terlebih dahulu
    _animationController.reset();

    // Hanya animasikan jika flag bernilai true (pertama kali load atau ganti bayi)
    if (_shouldAnimateNutrition) {
      _animationController.forward();
      _shouldAnimateNutrition = false;
    } else {
      _animationController.value = 1.0;
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

  // Fungsi untuk menampilkan dropdown bayi menggunakan showGeneralDialog
  void _showBabyDropdownOptions(
    BuildContext context,
    GlobalKey dropdownButtonKey,
  ) {
    // Mendapatkan RenderBox dari GlobalKey untuk mendapatkan posisi tombol
    final RenderBox renderBox =
        dropdownButtonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(
      Offset.zero,
    ); // Posisi global tombol

    showGeneralDialog(
      context: context,
      // KUNCI: Membuat barrier transparan agar kita bisa mengontrol overlay gelap sendiri.
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      barrierLabel: 'Baby Options',
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(dialogContext).pop(),
                behavior: HitTestBehavior.translucent,
                child: Container(color: Colors.black38),
              ),
            ),

            // --- Konten Utama Dialog (Tombol yang terlihat & Modal Dropdown) ---
            Positioned(
              left: offset.dx,
              top: offset.dy,
              width: 100,
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
                alignment: Alignment.topCenter,
                child: Material(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                  elevation: 8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:
                        _babies.map((baby) {
                          return InkWell(
                            onTap: () {
                              final currentState =
                                  context.read<FoodRecordBloc>().state;
                              if (currentState is FoodRecordLoaded) {
                                setState(() {
                                  _selectedBaby = baby.id.toString();
                                  _shouldAnimateNutrition = true;
                                  _historyItems =
                                      currentState.foodRecords
                                          .where(
                                            (food) =>
                                                food.babyId.toString() ==
                                                _selectedBaby,
                                          )
                                          .toList();
                                  _groupFoodByTimePeriod();
                                });
                              }
                              Navigator.of(dialogContext).pop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 16.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      baby.name,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  if (_selectedBaby ==
                                      baby.id.toString()) // Tampilkan ikon cek
                                    const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
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
                // Gunakan babyId dari parameter jika tersedia dan belum diset
                if (_selectedBaby.isEmpty && widget.babyId != null) {
                  _selectedBaby = widget.babyId!;
                } else if (_babies.isNotEmpty) {
                  _selectedBaby =
                      _selectedBaby.isEmpty
                          ? _babies.first.id.toString()
                          : _selectedBaby;
                }
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

                _shouldAnimateNutrition = true;
                _groupFoodByTimePeriod();
              });
            } else if (state is FoodRecordError) {
              AppFlushbar.showError(
                context,
                title: 'Error',
                message: state.error,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top:
                    AppBar().preferredSize.height +
                    MediaQuery.of(context).padding.top,
              ),
              child: BlocBuilder<FoodRecordBloc, FoodRecordState>(
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
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                centerTitle: true,
                title: Text(
                  'Riwayat Memasak',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                automaticallyImplyLeading: false,
              ),
            ),
            LeadingActionButton(
              onPressed: () => Navigator.pop(context),
              icon: AppIcons.back,
            ),
          ],
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
                                final int diff =
                                    _nutritionData['difference'] ?? 0;
                                final prefix = diff >= 0 ? '+' : '-';
                                return Text(
                                  '$prefix${_differenceAnimation.value}',
                                  style: TextStyle(
                                    color:
                                        diff >= 0
                                            ? AppColors.success
                                            : AppColors.error,
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
                            AppColors.error,
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
                            AppColors.success,
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
          GestureDetector(
            key: _babyDropdownButtonKey,
            onTap: () {
              _showBabyDropdownOptions(context, _babyDropdownButtonKey);
            },
            child: Material(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: 100,
                height: 44,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 0,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _truncateBabyName(
                          _babies
                              .firstWhere(
                                (baby) => baby.id.toString() == _selectedBaby,
                                orElse:
                                    () =>
                                        _babies.isNotEmpty
                                            ? _babies.first
                                            : Baby(
                                              id: 0,
                                              name: "Pilih Bayi",
                                              gender: 'L',
                                              isProfileComplete: true,
                                            ),
                              )
                              .name,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Tampilan periode waktu terpilih
          Expanded(
            child: Material(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  10.0,
                ), // Menerapkan radius 12.0 ke semua 4 sudut
              ),
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 0,
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
          ),

          const SizedBox(width: 8),

          // Tombol filter
          Material(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                // Tampilkan bottom sheet filter
                _showFilterBottomSheet(context);
              },
              child: SizedBox(
                height: 44,
                width: 44,
                child: Icon(Symbols.filter_list, size: 20),
              ),
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
                              _shouldAnimateNutrition = false;
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
                                      ? AppColors.primary.withAlpha(50)
                                      : AppColors.white,
                              border: Border.all(
                                color: _selectedTimePeriod == period
                                    ? AppColors.primary
                                    : AppColors.componentGrey!,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child:
                                  _selectedTimePeriod == period
                                      ? Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.check,
                                            color: AppColors.primary,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            period,
                                            style: const TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      )
                                      : Text(
                                        period,
                                        style: const TextStyle(
                                          color: AppColors.textBlack,
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

    // Jika periode waktu adalah "Hari ini", tampilkan daftar sederhana
    if (_selectedTimePeriod == 'Hari ini') {
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

    // Untuk periode waktu lainnya, tampilkan accordion (filter yang tidak kosong)
    final nonEmptyGroups = Map<String, List<FoodRecord>>.from(_groupedData)
      ..removeWhere((key, value) => value.isEmpty);

    if (nonEmptyGroups.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada riwayat memasak',
          style: TextStyle(fontSize: 16, color: AppColors.textGrey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: nonEmptyGroups.keys.length,
      itemBuilder: (context, index) {
        final timeGroup = nonEmptyGroups.keys.elementAt(index);
        final foodsInGroup = nonEmptyGroups[timeGroup]!;
        return _buildAccordionGroup(timeGroup, foodsInGroup);
      },
    );
  }

  // Helper untuk mengelompokkan data makanan berdasarkan periode waktu
  bool _isGroupExpanded(String groupTitle) {
    return _expandedGroups[_selectedTimePeriod]?.contains(groupTitle) ?? false;
  }

  // helper untuk mengelompokkan data makanan berdasarkan periode waktu
  void _toggleGroupExpansion(String groupTitle, bool isExpanded) {
    setState(() {
      if (isExpanded) {
        _expandedGroups[_selectedTimePeriod]?.add(groupTitle);
      } else {
        _expandedGroups[_selectedTimePeriod]?.remove(groupTitle);
      }
    });
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
        initiallyExpanded: _isGroupExpanded(groupTitle),
        onExpansionChanged: (isExpanded) {
          _toggleGroupExpansion(groupTitle, isExpanded);
        },
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
            AppFlushbar.showInfo(
              context,
              title: 'Informasi',
              message: 'Data makanan sudah tidak tersedia',
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FoodDetailScreen(foodId: food.foodId!),
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

  // Method pembantu untuk menampilkan teks rekomendasi berdasarkan persentase konsumsi
  Widget _getRecommendationText(double percentage) {
    String message;
    Color messageColor;

    if (percentage < 60) {
      message =
          'Asupan kalori masih kurang dari kebutuhan bulanan yang direkomendasikan.';
      messageColor = AppColors.error;
    } else if (percentage > 110) {
      message =
          'Asupan kalori melebihi kebutuhan bulanan yang direkomendasikan.';
      messageColor = Colors.orange;
    } else {
      message =
          'Asupan kalori sudah sesuai dengan kebutuhan bulanan yang direkomendasikan.';
      messageColor = AppColors.success;
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
