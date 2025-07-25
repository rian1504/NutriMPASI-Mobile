import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/blocs/baby/baby_bloc.dart';
import 'package:nutrimpasi/blocs/schedule/schedule_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/schedule.dart';
import 'package:nutrimpasi/screens/food/cooking_guide_screen.dart';
import 'package:nutrimpasi/screens/food/cooking_history_screen.dart';
import 'package:nutrimpasi/main.dart';
import 'package:nutrimpasi/utils/flushbar.dart';
import 'package:nutrimpasi/utils/navigation_animation.dart';
import 'package:nutrimpasi/widgets/custom_button.dart';
import 'package:nutrimpasi/widgets/custom_dialog.dart';
import 'package:nutrimpasi/widgets/custom_message_dialog.dart';

class ScheduleScreen extends StatefulWidget {
  final DateTime? targetDate;

  const ScheduleScreen({super.key, this.targetDate});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // Controller PageView untuk navigasi hari
  late PageController _dayController;
  int _currentDay = 2;
  late DateTime _selectedDate;

  // Variabel untuk card yang sedang terbuka
  String? _openCardId;

  // Data schedule
  List<Schedule> get _scheduleItems {
    final state = context.read<ScheduleBloc>().state;
    if (state is ScheduleLoaded) {
      return state.schedules.where((schedule) {
        return isSameDay(schedule.date, _selectedDate);
      }).toList();
    }
    return [];
  }

  // Helper method untuk memeriksa apakah dua tanggal adalah hari yang sama
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Helper method untuk mendapatkan formatted date string
  String get formattedSelectedDate {
    return "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();

    // Fungsi untuk menginisialisasi tanggal terpilih
    if (widget.targetDate != null) {
      _selectedDate = widget.targetDate!;

      final today = DateTime.now();
      final diff =
          _selectedDate
              .difference(DateTime(today.year, today.month, today.day))
              .inDays;

      if (diff >= -2 && diff <= 8) {
        _currentDay = 2 + diff;
      }
    } else {
      _selectedDate = DateTime.now();
      _currentDay = 2;
    }

    _dayController = PageController(
      initialPage: _currentDay,
      viewportFraction: 0.2,
    );

    context.read<ScheduleBloc>().add(FetchSchedules());
    Intl.defaultLocale = 'id';
  }

  // Data hari dan tanggal
  List<Map<String, dynamic>> get _days {
    final today = DateTime.now();
    final baseDate = DateTime(today.year, today.month, today.day);

    return List.generate(11, (index) {
      final date = baseDate.add(Duration(days: index - 2));
      return {
        'day': DateFormat('E', 'id').format(date),
        'date': date.day,
        'fullDate': date,
        'enabled': index >= 2 && index < 9,
      };
    });
  }

  void _navigateToFoodList() {
    // Tampilkan flushbar
    AppFlushbar.showInfo(
      context,
      title: 'Informasi',
      message: 'Pilih makanan yang ingin ditambahkan ke Jadwal Memasak',
    );

    // Fungsi untuk navigasi ke FoodListScreen
    final MainPageState? mainPage =
        context.findAncestorStateOfType<MainPageState>();
    if (mainPage != null) {
      mainPage.changePage(1);
    }
  }

  // Fungsi untuk menampilkan dialog informasi swipe
  void _showSwipeInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Informasi',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack,
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        customBorder: const CircleBorder(),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: AppColors.textBlack),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.close,
                              color: AppColors.textBlack,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.componentGrey!.withAlpha(75),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Symbols.touch_app,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: const Text(
                              'Cara Menggunakan Jadwal:',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textBlack,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Bagian 1: Membuka opsi
                      const Text(
                        '1. Membuka Opsi Jadwal:',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: const Text(
                          '• Geser jadwal ke kiri atau tekan tombol panah kiri',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: AppColors.textBlack,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Symbols.chevron_left,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Tekan tombol ini untuk membuka opsi',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                color: AppColors.textBlack,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Bagian 2: Pilihan aksi
                      const Text(
                        '2. Pilihan Aksi:',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Symbols.chef_hat,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Masak',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: AppColors.textBlack,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.warning,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Symbols.edit,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Edit',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: AppColors.textBlack,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Symbols.delete,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Hapus',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: AppColors.textBlack,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Bagian 3: Menutup opsi
                      const Text(
                        '3. Menutup Opsi:',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: const Text(
                          '• Geser kembali ke kanan atau tekan tombol silang',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: AppColors.textBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Mengerti',
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
  }

  // Metode untuk mengupdate tanggal terpilih
  void _updateSelectedDate(int index) {
    if (_days[index]['enabled']) {
      setState(() {
        _currentDay = index;
        _selectedDate = _days[index]['fullDate'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
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
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleButton(
              onPressed: () {
                pushWithSlideTransition(context, CookingHistoryScreen());
              },
              icon: Symbols.history,
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
                _updateSelectedDate(index);
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
                      _updateSelectedDate(index);
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
                        Flexible(
                          child: const Text(
                            'Tambah Jadwal Masak',
                            style: TextStyle(
                              fontSize: 12,
                              overflow: TextOverflow.ellipsis,
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

          const SizedBox(height: 14),

          // Menampilkan tanggal yang dipilih
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEEE, d MMMM yyyy', 'id').format(_selectedDate),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack,
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _showSwipeInfo,
                    customBorder: const CircleBorder(),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Symbols.info,
                        size: 20,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_scheduleItems.isNotEmpty) SizedBox(height: 8),

          // Daftar jadwal makanan
          BlocConsumer<ScheduleBloc, ScheduleState>(
            listener: (context, state) {
              if (state is ScheduleUpdated) {
                AppFlushbar.showSuccess(
                  context,
                  message: "Jadwal berhasil diubah",
                  title: "Berhasil",
                );

                setState(() {
                  _openCardId = null;
                  context.read<ScheduleBloc>().add(FetchSchedules());
                });
              } else if (state is ScheduleDeleted) {
                AppFlushbar.showSuccess(
                  context,
                  message: "Jadwal berhasil dihapus",
                  title: "Berhasil",
                );

                setState(() {
                  _openCardId = null;
                  context.read<ScheduleBloc>().add(FetchSchedules());
                });
              } else if (state is ScheduleError) {
                // Tampilkan flushbar jika terjadi error
                AppFlushbar.showError(
                  context,
                  title: 'Error',
                  message: state.error,
                );
              }
            },
            builder: (context, state) {
              if (state is ScheduleLoading) {
                return const Center(
                  child: Column(
                    children: [
                      SizedBox(height: 100),
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              }

              if (state is ScheduleError) {
                return Center(child: Text(state.error));
              }

              if (_scheduleItems.isEmpty) {
                return Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: EmptyMessage(
                        title: 'Belum ada jadwal memasak ',
                        subtitle:
                            'Tambahkan jadwal memasak untuk hari ini dengan menekan tombol di atas',
                        buttonText: 'Tambah Jadwal',
                        iconName: AppIcons.schedule,
                      ),
                    ),
                  ),
                );
              }

              if (state is ScheduleLoaded) {
                // Cek jika data kosong
                if (state.schedules.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 50),
                        Icon(
                          Symbols.fastfood,
                          size: 60,
                          color: AppColors.textGrey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada jadwal memasak',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Jika ada data, tampilkan daftar jadwal
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _scheduleItems.length,
                    itemBuilder: (context, index) {
                      final item = _scheduleItems[index];
                      final food = item.food;
                      final babies = item.babies;
                      final itemId = '${food?.id}_$index';
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
                                    // Tombol masak
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.warning,
                                      ),
                                      child: Container(
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: AppColors.accent,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20.0,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              // Mengubah list baby ke list id baby
                                              List<String> babyId =
                                                  babies
                                                      .map(
                                                        (baby) =>
                                                            baby.id.toString(),
                                                      )
                                                      .toList();

                                              pushWithSlideTransition(
                                                context,
                                                CookingGuideScreen(
                                                  foodId: food!.id.toString(),
                                                  babyId: babyId,
                                                  scheduleId:
                                                      item.id.toString(),
                                                ),
                                              );
                                            },
                                            child: const Center(
                                              child: Icon(
                                                Symbols.chef_hat,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Tombol edit
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.error,
                                      ),
                                      child: Container(
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: AppColors.warning,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 0,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              // Ambil data bayi
                                              final babyState =
                                                  context
                                                      .read<BabyBloc>()
                                                      .state;

                                              if (babyState is BabyLoaded) {
                                                final babies = babyState.babies;

                                                // Tampilkan Dialog untuk edit jadwal
                                                showDialog(
                                                  context: context,
                                                  builder: (
                                                    BuildContext context,
                                                  ) {
                                                    // Map untuk checkbox bayi (gunakan ID bayi sebagai key)
                                                    Map<int, bool>
                                                    selectedBabies = {
                                                      for (var baby in babies)
                                                        baby.id: false,
                                                    };

                                                    DateTime? selectedDate =
                                                        item.date;
                                                    String? babyValidationError;
                                                    String? dateValidationError;

                                                    // Reset semua bayi ke false terlebih dahulu
                                                    selectedBabies =
                                                        selectedBabies.map(
                                                          (key, value) =>
                                                              MapEntry(
                                                                key,
                                                                false,
                                                              ),
                                                        );

                                                    // Set true untuk bayi yang terdaftar di schedule
                                                    for (var baby
                                                        in item.babies) {
                                                      if (selectedBabies
                                                          .containsKey(
                                                            baby.id,
                                                          )) {
                                                        selectedBabies[baby
                                                                .id] =
                                                            true;
                                                      }
                                                    }

                                                    return StatefulBuilder(
                                                      builder: (
                                                        context,
                                                        setState,
                                                      ) {
                                                        return Dialog(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  16,
                                                                ),
                                                          ),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  16,
                                                                ),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Material(
                                                                      color:
                                                                          Colors
                                                                              .transparent,
                                                                      child: InkWell(
                                                                        onTap:
                                                                            () => Navigator.pop(
                                                                              context,
                                                                            ),
                                                                        customBorder:
                                                                            const CircleBorder(),
                                                                        child: Container(
                                                                          width:
                                                                              24,
                                                                          height:
                                                                              24,
                                                                          decoration: BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color:
                                                                                Colors.white,
                                                                            border: Border.all(
                                                                              color:
                                                                                  AppColors.textBlack,
                                                                            ),
                                                                          ),
                                                                          child: const Center(
                                                                            child: Icon(
                                                                              Icons.close,
                                                                              color:
                                                                                  AppColors.textBlack,
                                                                              size:
                                                                                  18,
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
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color:
                                                                          AppColors
                                                                              .textBlack,
                                                                    ),
                                                                  ),
                                                                ),

                                                                const SizedBox(
                                                                  height: 16,
                                                                ),

                                                                // Pilihan bayi
                                                                const Text(
                                                                  'Pilih Profil Bayi',
                                                                  style: TextStyle(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        14,
                                                                    color:
                                                                        AppColors
                                                                            .textGrey,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                      color:
                                                                          babyValidationError !=
                                                                                  null
                                                                              ? Colors.red
                                                                              : AppColors.componentGrey!,
                                                                      width:
                                                                          babyValidationError !=
                                                                                  null
                                                                              ? 1.5
                                                                              : 1.0,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          8,
                                                                        ),
                                                                  ),
                                                                  padding:
                                                                      const EdgeInsets.symmetric(
                                                                        vertical:
                                                                            8,
                                                                      ),
                                                                  child: Column(
                                                                    children:
                                                                        babies.map((
                                                                          baby,
                                                                        ) {
                                                                          return InkWell(
                                                                            onTap: () {
                                                                              setState(
                                                                                () {
                                                                                  selectedBabies[baby.id] =
                                                                                      !(selectedBabies[baby.id] ??
                                                                                          false);
                                                                                  if (selectedBabies[baby.id] ??
                                                                                      false) {
                                                                                    babyValidationError =
                                                                                        null;
                                                                                  }
                                                                                },
                                                                              );
                                                                            },
                                                                            child: Row(
                                                                              children: [
                                                                                Checkbox(
                                                                                  value:
                                                                                      selectedBabies[baby.id] ??
                                                                                      false,
                                                                                  onChanged: (
                                                                                    value,
                                                                                  ) {
                                                                                    setState(
                                                                                      () {
                                                                                        selectedBabies[baby.id] =
                                                                                            value!;
                                                                                        if (value) {
                                                                                          babyValidationError =
                                                                                              null;
                                                                                        }
                                                                                      },
                                                                                    );
                                                                                  },
                                                                                  activeColor:
                                                                                      AppColors.primary,
                                                                                ),
                                                                                Text(
                                                                                  baby.name,
                                                                                  style: const TextStyle(
                                                                                    fontFamily:
                                                                                        'Poppins',
                                                                                    fontSize:
                                                                                        14,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        }).toList(),
                                                                  ),
                                                                ),
                                                                if (babyValidationError !=
                                                                    null)
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.only(
                                                                          top:
                                                                              6,
                                                                          left:
                                                                              12,
                                                                        ),
                                                                    child: Text(
                                                                      babyValidationError!,
                                                                      style: const TextStyle(
                                                                        color:
                                                                            Colors.red,
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            'Poppins',
                                                                      ),
                                                                    ),
                                                                  ),
                                                                const SizedBox(
                                                                  height: 16,
                                                                ),

                                                                // Pilihan tanggal
                                                                const Text(
                                                                  'Pilih Penjadwalan',
                                                                  style: TextStyle(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        14,
                                                                    color:
                                                                        AppColors
                                                                            .textGrey,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 8,
                                                                ),
                                                                InkWell(
                                                                  onTap: () async {
                                                                    // Tanggal hari ini
                                                                    final today =
                                                                        DateTime.now();

                                                                    // Buat 7 hari ke depan (hari ini + 6 hari)
                                                                    final List<
                                                                      DateTime
                                                                    >
                                                                    nextSevenDays = List.generate(
                                                                      7,
                                                                      (
                                                                        index,
                                                                      ) => today.add(
                                                                        Duration(
                                                                          days:
                                                                              index,
                                                                        ),
                                                                      ),
                                                                    );

                                                                    // Format nama hari dalam Bahasa Indonesia
                                                                    final List<
                                                                      String
                                                                    >
                                                                    dayNames =
                                                                        nextSevenDays.map((
                                                                          date,
                                                                        ) {
                                                                          return DateFormat(
                                                                            'EEEE, d MMMM y',
                                                                            'id_ID',
                                                                          ).format(
                                                                            date,
                                                                          );
                                                                        }).toList();

                                                                    // Temukan indeks tanggal yang sesuai dengan yang sudah dipilih sebelumnya
                                                                    int
                                                                    initialIndex =
                                                                        0;
                                                                    if (selectedDate !=
                                                                        null) {
                                                                      // Cari tanggal yang sama dari list nextSevenDays
                                                                      for (
                                                                        int i =
                                                                            0;
                                                                        i <
                                                                            nextSevenDays.length;
                                                                        i++
                                                                      ) {
                                                                        if (isSameDay(
                                                                          nextSevenDays[i],
                                                                          selectedDate!,
                                                                        )) {
                                                                          initialIndex =
                                                                              i;
                                                                          break;
                                                                        }
                                                                      }
                                                                    }

                                                                    BottomPicker(
                                                                      items:
                                                                          dayNames
                                                                              .map(
                                                                                (
                                                                                  day,
                                                                                ) => Text(
                                                                                  day,
                                                                                  style: const TextStyle(
                                                                                    color:
                                                                                        AppColors.textBlack,
                                                                                    fontSize:
                                                                                        28,
                                                                                    fontFamily:
                                                                                        'Poppins',
                                                                                  ),
                                                                                ),
                                                                              )
                                                                              .toList(),
                                                                      pickerTitle: const Text(
                                                                        'Pilih Hari',
                                                                        style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              AppColors.textBlack,
                                                                        ),
                                                                      ),
                                                                      titleAlignment:
                                                                          Alignment
                                                                              .center,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      buttonContent: const Text(
                                                                        'Pilih',
                                                                        style: TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                      buttonSingleColor:
                                                                          AppColors
                                                                              .primary,
                                                                      displayCloseIcon:
                                                                          true,
                                                                      closeIconColor:
                                                                          AppColors
                                                                              .textBlack,
                                                                      closeIconSize:
                                                                          24,
                                                                      displaySubmitButton:
                                                                          true,
                                                                      selectedItemIndex:
                                                                          initialIndex,
                                                                      onSubmit: (
                                                                        index,
                                                                      ) {
                                                                        setState(() {
                                                                          // Simpan tanggal yang dipilih
                                                                          selectedDate =
                                                                              nextSevenDays[index
                                                                                  as int];
                                                                          dateValidationError =
                                                                              null;
                                                                        });
                                                                      },
                                                                      bottomPickerTheme:
                                                                          BottomPickerTheme
                                                                              .plumPlate,
                                                                      height:
                                                                          300,
                                                                    ).show(
                                                                      context,
                                                                    );
                                                                  },
                                                                  child: Container(
                                                                    padding: const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          12,
                                                                      vertical:
                                                                          12,
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                        color:
                                                                            dateValidationError !=
                                                                                    null
                                                                                ? Colors.red
                                                                                : AppColors.componentGrey!,
                                                                        width:
                                                                            dateValidationError !=
                                                                                    null
                                                                                ? 1.5
                                                                                : 1.0,
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
                                                                      children: [
                                                                        Text(
                                                                          selectedDate !=
                                                                                  null
                                                                              ? DateFormat(
                                                                                'EEEE, d MMMM y',
                                                                                'id_ID',
                                                                              ).format(
                                                                                selectedDate!,
                                                                              )
                                                                              : 'Pilih Tanggal',
                                                                          style: TextStyle(
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                selectedDate !=
                                                                                        null
                                                                                    ? AppColors.textBlack
                                                                                    : AppColors.textGrey,
                                                                          ),
                                                                        ),
                                                                        const Icon(
                                                                          Symbols
                                                                              .calendar_month,
                                                                          size:
                                                                              20,
                                                                          color:
                                                                              AppColors.textGrey,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                if (dateValidationError !=
                                                                    null)
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.only(
                                                                          top:
                                                                              6,
                                                                          left:
                                                                              12,
                                                                        ),
                                                                    child: Text(
                                                                      dateValidationError!,
                                                                      style: const TextStyle(
                                                                        color:
                                                                            Colors.red,
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            'Poppins',
                                                                      ),
                                                                    ),
                                                                  ),
                                                                const SizedBox(
                                                                  height: 24,
                                                                ),

                                                                // Tombol simpan jadwal
                                                                SizedBox(
                                                                  width:
                                                                      double
                                                                          .infinity,
                                                                  child: ElevatedButton(
                                                                    onPressed: () {
                                                                      if (!mounted) {
                                                                        return;
                                                                      }

                                                                      bool
                                                                      isValid =
                                                                          true;

                                                                      // Dapatkan list id bayi yang dipilih
                                                                      final selectedBabyIds =
                                                                          selectedBabies
                                                                              .entries
                                                                              .where(
                                                                                (
                                                                                  entry,
                                                                                ) =>
                                                                                    entry.value,
                                                                              )
                                                                              .map(
                                                                                (
                                                                                  entry,
                                                                                ) =>
                                                                                    entry.key.toString(),
                                                                              )
                                                                              .toList();

                                                                      // Validasi bayi
                                                                      if (selectedBabyIds
                                                                          .isEmpty) {
                                                                        setState(() {
                                                                          babyValidationError =
                                                                              'Pilih minimal satu bayi';
                                                                        });
                                                                        isValid =
                                                                            false;
                                                                      } else {
                                                                        setState(() {
                                                                          babyValidationError =
                                                                              null;
                                                                        });
                                                                      }

                                                                      // Validasi tanggal
                                                                      if (selectedDate ==
                                                                          null) {
                                                                        setState(() {
                                                                          dateValidationError =
                                                                              'Pilih tanggal terlebih dahulu';
                                                                        });
                                                                        isValid =
                                                                            false;
                                                                      } else {
                                                                        setState(() {
                                                                          dateValidationError =
                                                                              null;
                                                                        });
                                                                      }

                                                                      // Jika valid, update schedule
                                                                      if (isValid) {
                                                                        context
                                                                            .read<
                                                                              ScheduleBloc
                                                                            >()
                                                                            .add(
                                                                              UpdateSchedules(
                                                                                scheduleId:
                                                                                    item.id,
                                                                                babyId:
                                                                                    selectedBabyIds,
                                                                                date:
                                                                                    selectedDate!,
                                                                              ),
                                                                            );

                                                                        Navigator.pop(
                                                                          context,
                                                                        );
                                                                      }
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor:
                                                                          AppColors
                                                                              .accent,
                                                                      foregroundColor:
                                                                          Colors
                                                                              .white,
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              8,
                                                                            ),
                                                                      ),
                                                                      padding: const EdgeInsets.symmetric(
                                                                        vertical:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                    child: const Text(
                                                                      'Simpan',
                                                                      style: TextStyle(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontSize:
                                                                            14,
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
                                                );
                                              } else {
                                                AppFlushbar.showError(
                                                  context,
                                                  title: 'Error',
                                                  message:
                                                      'Gagal memuat data bayi',
                                                  marginVerticalValue: 8,
                                                );
                                              }
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
                                      margin: const EdgeInsets.only(right: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.error,
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
                                            builder:
                                                (ctx) => ConfirmDialog(
                                                  titleText: 'Konfirmasi Hapus',
                                                  contentText:
                                                      'Anda yakin ingin menghapus Jadwal Memasak "${food!.name}" ini?',
                                                  confirmButtonText: 'Hapus',
                                                  confirmButtonColor:
                                                      AppColors.error,
                                                  onConfirm: () {
                                                    if (!mounted) {
                                                      return;
                                                    }

                                                    context
                                                        .read<ScheduleBloc>()
                                                        .add(
                                                          DeleteSchedules(
                                                            scheduleId: item.id,
                                                          ),
                                                        );
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  // cancelButtonColor: AppColors.componentBlack,
                                                  cancelButtonText: 'Batal',
                                                  onCancel: () {
                                                    Navigator.of(ctx).pop();
                                                  },
                                                ),
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
                                  isOpen ? -180 : 0,
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
                                        // borderRadius: BorderRadius.circular(10),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                        child: Image.network(
                                          storageUrl + food!.image,
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
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            SizedBox(
                                              height: 40,
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Column(
                                                  children:
                                                      babies.map((baby) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                right: 5,
                                                              ),
                                                          child: Text(
                                                            baby.name,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 12,
                                                              color:
                                                                  AppColors
                                                                      .textGrey,
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Tombol opsi
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8.0,
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              "${babies.length.toString()} Set",
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.accent,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (isOpen) {
                                                    _openCardId = null;
                                                  } else {
                                                    _openCardId = itemId;
                                                  }
                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      isOpen
                                                          ? AppColors
                                                              .componentGrey
                                                          : AppColors.accent,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  isOpen
                                                      ? Symbols.close
                                                      : Symbols
                                                          .chevron_backward,
                                                  color:
                                                      isOpen
                                                          ? AppColors.textGrey
                                                          : Colors.white,
                                                  size: 28,
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
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
