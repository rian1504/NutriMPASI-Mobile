import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/models/food_model.dart';
import 'package:nutrimpasi/screens/food/cooking_guide_screen.dart';
import 'package:nutrimpasi/screens/food/cooking_history_screen.dart';
import 'package:nutrimpasi/main.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // Controller PageView untuk navigasi hari
  final PageController _dayController = PageController(
    initialPage: 2,
    viewportFraction: 0.2,
  );
  int _currentDay = 2;

  // Variabel untuk card yang sedang terbuka
  String? _openCardId;

  // Data dummy jadwal makanan
  final List<Map<String, dynamic>> _scheduleItems = [
    {'food': Food.dummyFoods[0], 'babyName': 'Bayi 1', 'portion': '1 Porsi'},
    {'food': Food.dummyFoods[1], 'babyName': 'Bayi 2', 'portion': '1 Porsi'},
    {'food': Food.dummyFoods[2], 'babyName': 'Bayi 1', 'portion': '1 Porsi'},
  ];

  // Data hari dan tanggal
  final List<Map<String, dynamic>> _days = List.generate(11, (index) {
    final today = DateTime.now();
    final date = today.add(Duration(days: index - 2));
    return {
      'day': _getDayName(date.weekday),
      'date': date.day,
      'enabled': index >= 2 && index < 9,
    };
  });

  // Fungsi untuk mendapatkan nama hari
  static String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Senin';
      case 2:
        return 'Selasa';
      case 3:
        return 'Rabu';
      case 4:
        return 'Kamis';
      case 5:
        return 'Jumat';
      case 6:
        return 'Sabtu';
      case 7:
        return 'Minggu';
      default:
        return '';
    }
  }

  void _navigateToFoodList() {
    // Tampilkan snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Pilih makanan yang ingin di tambahkan ke Jadwal Memasak",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.secondary,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.05,
          left: 20,
          right: 20,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // Fungsi untuk navigasi ke FoodListScreen
    final MainPageState? mainPage =
        context.findAncestorStateOfType<MainPageState>();
    if (mainPage != null) {
      mainPage.changePage(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pearl,
      appBar: AppBar(
        backgroundColor: AppColors.pearl,
        leading: Image.asset('assets/images/logo/nutrimpasi.png', height: 40),
        title: const Text(
          'Jadwal Memasak',
          style: TextStyle(
            color: AppColors.textBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CookingHistoryScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(8.0),
              elevation: 2,
            ),
            child: const Icon(
              Symbols.history,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Bagian navigasi hari dan tanggal
          SizedBox(
            height: 100,
            child: PageView.builder(
              controller: _dayController,
              onPageChanged: (index) {
                if (index < 2) {
                  _dayController.animateToPage(
                    2,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  return;
                } else if (index > 8) {
                  _dayController.animateToPage(
                    8,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  return;
                }
                setState(() {
                  _currentDay = index;
                });
              },
              itemCount: _days.length,
              itemBuilder: (context, index) {
                final bool isEnabled = _days[index]['enabled'];

                return GestureDetector(
                  onTap: () {
                    if (isEnabled) {
                      _dayController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          _currentDay == index
                              ? AppColors.primary
                              : isEnabled
                              ? Colors.white
                              : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _days[index]['day'],
                          style: TextStyle(
                            color:
                                _currentDay == index
                                    ? Colors.white
                                    : isEnabled
                                    ? AppColors.textBlack
                                    : Colors.grey[500],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _days[index]['date'].toString(),
                          style: TextStyle(
                            color:
                                _currentDay == index
                                    ? Colors.white
                                    : isEnabled
                                    ? AppColors.textBlack
                                    : Colors.grey[500],
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bagian banner gambar
          Container(
            margin: const EdgeInsets.all(16),
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.componentGrey,
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                image: AssetImage('assets/images/banner/jadwal_makanan.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Tombol tambah jadwal masak
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ElevatedButton(
                    onPressed: _navigateToFoodList,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Symbols.add),
                        const SizedBox(width: 4),
                        const Text(
                          'Tambah Jadwal Masak',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Daftar jadwal makanan
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _scheduleItems.length,
              itemBuilder: (context, index) {
                final item = _scheduleItems[index];
                final food = item['food'] as Food;
                final itemId = '${food.id}_$index';
                final isOpen = _openCardId == itemId;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity! < 0) {
                        // Swipe ke kiri
                        setState(() {
                          _openCardId = itemId;
                        });
                      } else if (details.primaryVelocity! > 0) {
                        // Swipe ke kanan
                        setState(() {
                          _openCardId = null;
                        });
                      }
                    },
                    child: Stack(
                      children: [
                        // Tombol aksi (edit dan hapus)
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Row(
                            children: [
                              // Tombol edit
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.red,
                                ),
                                child: Container(
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: AppColors.brightYellow,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: InkWell(
                                      onTap: () {
                                        // Tampilkan Dialog untuk edit jadwal
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            // Map untuk checkbox bayi
                                            Map<String, bool> selectedBabies = {
                                              'Bayi 1':
                                                  item['babyName'] == 'Bayi 1',
                                              'Bayi 2':
                                                  item['babyName'] == 'Bayi 2',
                                            };
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  16,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Material(
                                                          color:
                                                              Colors
                                                                  .transparent,
                                                          child: InkWell(
                                                            onTap:
                                                                () =>
                                                                    Navigator.pop(
                                                                      context,
                                                                    ),
                                                            customBorder:
                                                                const CircleBorder(),
                                                            child: Container(
                                                              width: 24,
                                                              height: 24,
                                                              decoration: BoxDecoration(
                                                                shape:
                                                                    BoxShape
                                                                        .circle,
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                border: Border.all(
                                                                  color:
                                                                      AppColors
                                                                          .textBlack,
                                                                ),
                                                              ),
                                                              child: const Center(
                                                                child: Icon(
                                                                  Icons.close,
                                                                  color:
                                                                      AppColors
                                                                          .textBlack,
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
                                                        'Atur Ulang Jadwal Memasak',
                                                        style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              AppColors
                                                                  .textBlack,
                                                        ),
                                                      ),
                                                    ),

                                                    const SizedBox(height: 16),

                                                    // Pilihan bayi
                                                    const Text(
                                                      'Pilih Profil Bayi',
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 14,
                                                        color:
                                                            AppColors.textGrey,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    StatefulBuilder(
                                                      builder: (
                                                        context,
                                                        setState,
                                                      ) {
                                                        return Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Checkbox(
                                                                  value:
                                                                      selectedBabies['Bayi 1'],
                                                                  onChanged: (
                                                                    value,
                                                                  ) {
                                                                    setState(() {
                                                                      selectedBabies['Bayi 1'] =
                                                                          value!;
                                                                    });
                                                                  },
                                                                  activeColor:
                                                                      AppColors
                                                                          .primary,
                                                                ),
                                                                const Text(
                                                                  'Bayi 1',
                                                                  style: TextStyle(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Checkbox(
                                                                  value:
                                                                      selectedBabies['Bayi 2'],
                                                                  onChanged: (
                                                                    value,
                                                                  ) {
                                                                    setState(() {
                                                                      selectedBabies['Bayi 2'] =
                                                                          value!;
                                                                    });
                                                                  },
                                                                  activeColor:
                                                                      AppColors
                                                                          .primary,
                                                                ),
                                                                const Text(
                                                                  'Bayi 2',
                                                                  style: TextStyle(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                    const SizedBox(height: 16),

                                                    // Pilihan tanggal
                                                    const Text(
                                                      'Pilih Penjadwalan',
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 14,
                                                        color:
                                                            AppColors.textGrey,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    InkWell(
                                                      onTap: () async {
                                                        final DateTime?
                                                        picked = await showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime.now(),
                                                          lastDate:
                                                              DateTime.now().add(
                                                                const Duration(
                                                                  days: 6,
                                                                ),
                                                              ),
                                                        );
                                                        if (picked != null) {
                                                          // TODO: Logika untuk memilih jadwal
                                                        }
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 8,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color:
                                                                AppColors
                                                                    .componentGrey!,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: const [
                                                            Text(
                                                              'Pilih Tanggal',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 14,
                                                                color:
                                                                    AppColors
                                                                        .textGrey,
                                                              ),
                                                            ),
                                                            Icon(
                                                              Symbols
                                                                  .calendar_month,
                                                              size: 20,
                                                              color:
                                                                  AppColors
                                                                      .textGrey,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 24),

                                                    // Tombol simpan jadwal
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          // TODO: Logika untuk menyimpan jadwal
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              AppColors
                                                                  .secondary,
                                                          foregroundColor:
                                                              Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                          ),
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                vertical: 12,
                                                              ),
                                                        ),
                                                        child: const Text(
                                                          'Simpan',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                      child: const Center(
                                        child: Icon(
                                          Symbols.edit,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Tombol hapus
                              Container(
                                width: 60,
                                decoration: BoxDecoration(
                                  color: AppColors.red,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    // Tampilkan dialog konfirmasi hapus
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(20),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                  'Anda yakin ingin menghapus Jadwal Memasak ini?',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 24),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    // Tombol Batal
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              AppColors
                                                                  .componentBlack,
                                                          foregroundColor:
                                                              Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(
                                                            context,
                                                          ).pop();
                                                        },
                                                        child: const Text(
                                                          'Batal',
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    // Tombol Hapus
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              AppColors.red,
                                                          foregroundColor:
                                                              Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            _scheduleItems
                                                                .removeAt(
                                                                  index,
                                                                );
                                                            _openCardId = null;
                                                          });
                                                          Navigator.of(
                                                            context,
                                                          ).pop();
                                                        },
                                                        child: const Text(
                                                          'Hapus',
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: const Center(
                                    child: Icon(
                                      Symbols.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Card jadwal
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          transform: Matrix4.translationValues(
                            isOpen ? -120 : 0,
                            0,
                            0,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(25),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Gambar makanan
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    food.image,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Info makanan
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        food.name,
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textBlack,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['babyName'],
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          color: AppColors.textGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Tombol masak
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        item['portion'],
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.secondary,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      CookingGuideScreen(
                                                        foodId: food.id,
                                                      ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: AppColors.secondary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Symbols.chef_hat,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
