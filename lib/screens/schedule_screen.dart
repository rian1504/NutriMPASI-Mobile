import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/models/food_model.dart';
import 'package:nutrimpasi/screens/food/cooking_guide_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // Controller PageView untuk navigasi hari
  final PageController _dayController = PageController(viewportFraction: 0.2);
  int _currentDay = 0;

  // Variabel untuk card yang sedang terbuka
  String? _openCardId;

  // Data dummy jadwal makanan
  final List<Map<String, dynamic>> _scheduleItems = [
    {'food': Food.dummyFoods[0], 'babyName': 'Bayi 1', 'portion': '1 Porsi'},
    {'food': Food.dummyFoods[1], 'babyName': 'Bayi 2', 'portion': '1 Porsi'},
    {'food': Food.dummyFoods[2], 'babyName': 'Bayi 1', 'portion': '1 Porsi'},
  ];

  // Data hari dan tanggal
  final List<Map<String, dynamic>> _days = List.generate(7, (index) {
    final today = DateTime.now();
    final date = today.add(Duration(days: index));
    return {'day': _getDayName(date.weekday), 'date': date.day};
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        backgroundColor: AppColors.offWhite,
        leading: Image.asset('assets/images/logo/nutrimpasi.png', height: 40),
        title: const Text(
          'Jadwal Memasak',
          style: TextStyle(
            color: AppColors.textBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Bagian navigasi hari dan tanggal
          SizedBox(
            height: 100,
            child: PageView.builder(
              controller: _dayController,
              onPageChanged: (index) {
                setState(() {
                  _currentDay = index;
                });
              },
              itemCount: _days.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _dayController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
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
                              : Colors.white,
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
                                    : AppColors.textBlack,
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
                                    : AppColors.textBlack,
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
                    onPressed: () {
                      // Logika tambah jadwal
                    },
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

                // Card dalam mode terbuka
                if (_openCardId == food.id) {
                  return Stack(
                    children: [
                      Row(
                        children: [
                          // Area utama card
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _openCardId = null;
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width - 132,
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: buildCardContent(item, food),
                              ),
                            ),
                          ),
                          // Tombol edit jadwal
                          GestureDetector(
                            onTap: () {
                              // Logika edit jadwal
                              print('Edit: ${food.name}');
                            },
                            child: Container(
                              width: 50,
                              height: 100,
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                              ),
                              child: const Icon(
                                Symbols.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // Tombol hapus jadwal
                          GestureDetector(
                            onTap: () {
                              // Logika hapus jadwal
                              print('Delete: ${food.name}');
                            },
                            child: Container(
                              width: 50,
                              height: 100,
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: const Icon(
                                Symbols.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }

                // Card dalam mode normal (tidak terbuka)
                return Dismissible(
                  key: Key(food.id),
                  direction: DismissDirection.endToStart,
                  dismissThresholds: const {DismissDirection.endToStart: 0.3},
                  onUpdate: (details) {
                    // Jika digeser lebih dari 30%, buka card
                    if (details.progress >= 0.3) {
                      setState(() {
                        // Tutup card lain yang mungkin terbuka
                        _openCardId = food.id;
                      });
                    }
                  },
                  confirmDismiss: (direction) async {
                    // Selalu kembalikan false untuk mencegah card terhapus
                    return false;
                  },
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 50,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                          child: const Icon(Symbols.edit, color: Colors.white),
                        ),
                        Container(
                          width: 50,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: const Icon(
                            Symbols.delete,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        setState(() {
                          _openCardId = null;
                        });
                      },
                      child: buildCardContent(item, food),
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

  // Widget untuk membangun konten kartu jadwal
  Widget buildCardContent(Map<String, dynamic> item, Food food) {
    return Row(
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

        // Informasi makanan
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Nama makanan
                        Text(
                          food.name,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBlack,
                          ),
                        ),

                        // Nama bayi
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
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Informasi porsi
                    Text(
                      '${food.portion} Porsi',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Tombol masak
                    GestureDetector(
                      onTap: () {
                        // Logika masak
                        print('Masak: ${food.name}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    CookingGuideScreen(foodId: food.id),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.buff,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Symbols.chef_hat,
                              color: AppColors.textBlack,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
