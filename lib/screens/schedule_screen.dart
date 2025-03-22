import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/models/food_model.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // Controller scroll horizontal tanggal
  final ScrollController _dateScrollController = ScrollController();
  // Controller scroll untuk mendeteksi posisi
  final ScrollController _scrollController = ScrollController();
  // Variable tombol scroll ke atas
  bool _showScrollToTop = false;

  // Tanggal hari ini dan 6 hari ke depan
  late List<DateTime> _weekDays;
  int _selectedDayIndex = 0; // Indeks hari terpilih

  // Data jadwal makanan dari model Food
  late List<Map<String, dynamic>> _scheduleItems;

  // Mengambil data dari model Food
  void _initScheduleItems() {
    // Mengambil data dari model Food
    final foods = Food.dummyFoods;

    // Mengkonversi data Food ke format yang dibutuhkan untuk jadwal
    _scheduleItems =
        foods
            .map(
              (food) => {
                'title': food.name,
                'babyName': 'Abdul',
                'portion': '${food.portion} Porsi',
                'image': food.image,
                'age': food.age,
                'energy': food.energy,
                'protein': food.protein,
                'fat': food.fat,
                'ingredients': food.fruit.join(', '),
              },
            )
            .toList();
  }

  // Indeks card yang sedang terbuka
  int? _openCardIndex;

  @override
  void initState() {
    super.initState();
    _initWeekDays();
    _initScheduleItems();

    // Listener untuk mendeteksi posisi scroll
    _scrollController.addListener(() {
      setState(() {
        _showScrollToTop = _scrollController.offset > 350;
      });
    });
  }

  // Inisialisasi tanggal untuk 7 hari
  void _initWeekDays() {
    final now = DateTime.now();
    _weekDays = List.generate(
      7,
      (index) => DateTime(now.year, now.month, now.day + index),
    );
  }

  // Format nama hari dalam Bahasa Indonesia
  String _getDayName(int weekday) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header jadwal
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Jadwal Memasak',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ),

              // Carousel tanggal
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 8.0,
                ),
                height: 90,
                child: ListView.builder(
                  controller: _dateScrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: _weekDays.length,
                  itemBuilder: (context, index) {
                    final day = _weekDays[index];
                    final isSelected = _selectedDayIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDayIndex = index;
                        });
                      },
                      child: Container(
                        width: 70,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(25),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _getDayName(day.weekday),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              day.day.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    isSelected
                                        ? Colors.white
                                        : AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Gambar header dari Picsum
              Container(
                margin: const EdgeInsets.all(16),
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://picsum.photos/800/400?random=0',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Tombol tambah jadwal
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implementasi tambah jadwal
                  },
                  icon: const Icon(Symbols.add),
                  label: const Text('Tambah Jadwal Masak'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              // Daftar jadwal makanan
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: List.generate(_scheduleItems.length, (index) {
                    final item = _scheduleItems[index];

                    // Tampilan card (terbuka atau normal)
                    return _openCardIndex == index
                        ? Stack(
                          children: [
                            Row(
                              children: [
                                // Card utama
                                Expanded(
                                  child: GestureDetector(
                                    // Tutup card saat di-tap
                                    onTap: () {
                                      setState(() {
                                        _openCardIndex = null;
                                      });
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 84,
                                            height: 84,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  item['image'],
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          // Informasi makanan
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item['title'],
                                                  style: const TextStyle(
                                                    color: AppColors.secondary,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  item['babyName'],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Tombol aksi
                                Row(
                                  children: [
                                    // Tombol edit
                                    GestureDetector(
                                      onTap: () {
                                        // TODO: Implementasi edit jadwal
                                      },
                                      child: Container(
                                        width: 60,
                                        height: 84,
                                        color: Colors.blue,
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Symbols.edit,
                                              color: Colors.white,
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Edit',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Tombol hapus
                                    GestureDetector(
                                      onTap: () {
                                        // TODO: Implementasi hapus jadwal
                                      },
                                      child: Container(
                                        width: 60,
                                        height: 84,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              const BorderRadius.horizontal(
                                                right: Radius.circular(10),
                                              ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Symbols.delete,
                                              color: Colors.white,
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Hapus',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                        : ClipRect(
                          child: Dismissible(
                            key: Key('schedule-$index'),
                            direction: DismissDirection.endToStart,
                            background: Container(),
                            secondaryBackground: Container(
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Tombol edit
                                  GestureDetector(
                                    onTap: () {
                                      // TODO: Implementasi edit jadwal
                                    },
                                    child: Container(
                                      width: 60,
                                      height: 84,
                                      color: Colors.blue,
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Symbols.edit,
                                            color: Colors.white,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Edit',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Tombol hapus
                                  GestureDetector(
                                    onTap: () {
                                      // TODO: Implementasi hapus jadwal
                                    },
                                    child: Container(
                                      width: 60,
                                      height: 84,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            const BorderRadius.horizontal(
                                              right: Radius.circular(10),
                                            ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Symbols.delete,
                                            color: Colors.white,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Hapus',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Kontrol perilaku dismiss
                            confirmDismiss: (direction) async {
                              // Buka card saat digeser ke kiri
                              if (direction == DismissDirection.endToStart) {
                                setState(() {
                                  _openCardIndex = index;
                                });
                              }
                              return false;
                            },
                            // Threshold geser
                            dismissThresholds: const {
                              DismissDirection.endToStart: 0.25,
                            },
                            movementDuration: const Duration(milliseconds: 200),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Gambar makanan dari Picsum
                                    Container(
                                      width: 84,
                                      height: 84,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: NetworkImage(item['image']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Informasi makanan
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['title'],
                                            style: const TextStyle(
                                              color: AppColors.secondary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            item['babyName'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Porsi dan tombol masak
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          item['portion'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: const Icon(
                                            Symbols.restaurant,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
      // Tombol scroll ke atas
      floatingActionButton:
          _showScrollToTop
              ? FloatingActionButton(
                backgroundColor: AppColors.primary,
                onPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Icon(Icons.arrow_upward, color: Colors.white),
              )
              : null,
    );
  }
}
