import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/blocs/baby/baby_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart';
import 'package:nutrimpasi/models/baby.dart';
import 'package:nutrimpasi/screens/baby/baby_edit_screen.dart';
import 'package:nutrimpasi/screens/baby/baby_add_screen.dart';
import 'package:nutrimpasi/screens/food/cooking_history_screen.dart';
import 'package:nutrimpasi/utils/flushbar.dart';
import 'package:nutrimpasi/widgets/custom_dialog.dart';

class BabyListScreen extends StatefulWidget {
  const BabyListScreen({super.key});

  @override
  State<BabyListScreen> createState() => _BabyListScreenState();
}

class _BabyListScreenState extends State<BabyListScreen> {
  // Controller untuk carousel bayi
  late PageController _carouselController;
  int _currentCarouselPage = 0;

  // Data bayi
  List<Baby> _babies = [];

  @override
  void initState() {
    super.initState();
    // Inisialisasi PageController
    _initPageController();

    // Ambil data bayi dari Bloc
    final babyState = context.read<BabyBloc>().state;
    if (babyState is! BabyLoaded) {
      context.read<BabyBloc>().add(FetchBabies());
    }
  }

  // Inisialisasi PageController untuk carousel
  void _initPageController() {
    _carouselController = PageController(
      viewportFraction: 0.85,
      initialPage: 0,
    );

    _currentCarouselPage = 0;

    // Listener untuk update halaman carousel yang aktif
    _carouselController.addListener(() {
      int page = _carouselController.page?.round() ?? 0;
      if (_currentCarouselPage != page) {
        setState(() {
          _currentCarouselPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 5,
            shadowColor: Colors.black54,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(AppIcons.back, color: AppColors.textBlack, size: 24),
                padding: EdgeInsets.zero,
                onPressed: () {
                  context.read<BabyBloc>().add(FetchBabies());
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian utama dengan latar belakang gradient
          Expanded(
            child: Stack(
              children: [
                // Background dengan dua bagian: gradient 50% di atas, putih 50% di bawah
                Column(
                  children: [
                    // Bagian gradient (50% atas)
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.2, 0.7, 0.9],
                            colors: [
                              AppColors.primary,
                              AppColors.bisque,
                              AppColors.background,
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    // Bagian putih (50% bawah)
                    Expanded(flex: 1, child: Container(color: Colors.white)),
                  ],
                ),

                // Konten utama (overlay di atas background)
                Column(
                  children: [
                    const SizedBox(height: 24),
                    // Judul halaman
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Kelola Profil Bayi Anda',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tambahkan atau edit data bayi untuk mendapatkan rekomendasi makanan yang lebih sesuai.',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 48),
                    // PageView untuk carousel bayi
                    Expanded(
                      child: BlocConsumer<BabyBloc, BabyState>(
                        listener: (context, state) {
                          if (state is BabyError) {
                            AppFlushbar.showError(
                              context,
                              title: 'Error',
                              message: state.error,
                            );
                          }

                          if (state is BabyDeleted) {
                            AppFlushbar.showSuccess(
                              context,
                              title: 'Berhasil',
                              message: 'Profil bayi berhasil dihapus',
                              marginVerticalValue: 8,
                            );

                            context.read<BabyBloc>().add(FetchBabies());
                          }
                        },
                        builder: (context, state) {
                          // Handle loading state
                          if (state is BabyLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          // Handle loaded state
                          if (state is BabyLoaded) {
                            _babies = state.babies;

                            // Jika ada bayi yang sudah ada, set carousel ke halaman pertama
                            if (!_carouselController.hasClients) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (_carouselController.hasClients) {
                                  setState(() {
                                    _currentCarouselPage = 0;
                                  });
                                  _carouselController.jumpToPage(0);
                                }
                              });
                            }
                          }

                          return Column(
                            children: [
                              SizedBox(
                                height: 420,
                                child: PageView.builder(
                                  controller: _carouselController,
                                  itemCount: _babies.length + 1,
                                  itemBuilder: (context, index) {
                                    final bool isCurrentItem =
                                        _currentCarouselPage == index;

                                    // Kartu tambah bayi baru
                                    if (index == _babies.length) {
                                      return _buildAddBabyCard(isCurrentItem);
                                    }

                                    // Kartu profil bayi
                                    final baby = _babies[index];
                                    return _buildBabyCard(baby, isCurrentItem);
                                  },
                                ),
                              ),
                              // Memberikan jarak yang cukup agar shadow tidak terpotong
                              const SizedBox(height: 24),
                              // Indikator dot untuk carousel (pagination)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  _babies.length + 1,
                                  (index) => Container(
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          _currentCarouselPage == index
                                              ? AppColors.primary
                                              : AppColors.componentGrey!
                                                  .withAlpha(125),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      // Tombol tambah bayi floating
      floatingActionButton:
          _currentCarouselPage == _babies.length
              ? null
              : FloatingActionButton(
                onPressed: () {
                  // Navigasi ke kartu tambah bayi
                  _carouselController.animateToPage(
                    _babies.length,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                backgroundColor: AppColors.accent,
                child: const Icon(Symbols.add, color: Colors.white),
              ),
    );
  }

  // Widget untuk kartu profil bayi
  Widget _buildBabyCard(Baby baby, bool isCurrentItem) {
    return Container(
      // Menambahkan padding di luar container utama untuk shadow
      padding: const EdgeInsets.only(bottom: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: isCurrentItem ? 0 : 15,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(200),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header dengan nama dan tombol edit
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      baby.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tombol edit
                      IconButton(
                        icon: const Icon(Symbols.edit_rounded),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BabyEditScreen(baby: baby),
                            ),
                          ).then((_) {
                            setState(() {});
                          });
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.warning,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                      // Tombol hapus
                      IconButton(
                        icon: const Icon(Symbols.delete),
                        onPressed: () {
                          _showDeleteConfirmation(baby);
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Konten utama dengan gambar dan informasi
              Expanded(
                child: Row(
                  children: [
                    // Gambar bayi
                    Container(
                      width: 125,
                      height: 200,
                      decoration: BoxDecoration(
                        color:
                            baby.gender == 'L'
                                ? AppColors.lavenderBlue.withAlpha(125)
                                : AppColors.bisque.withAlpha(125),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child:
                            baby.isProfileComplete
                                ? Image.asset(
                                  baby.gender == 'L'
                                      ? 'assets/images/component/bayi_laki_laki.png'
                                      : 'assets/images/component/bayi_perempuan.png',
                                  fit: BoxFit.contain,
                                  height: 150,
                                )
                                : Image.asset(
                                  'assets/images/component/bayi_laki_laki_awal.png',
                                  height: 150,
                                ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Informasi bayi
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildInfoRow(
                            Symbols.cake,
                            'Usia',
                            baby.ageInMonths!,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Symbols.height_rounded,
                            'Tinggi Badan',
                            '${baby.height ?? '-'} cm',
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Symbols.scale_rounded,
                            'Berat Badan',
                            '${baby.weight ?? '-'} kg',
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Symbols.no_meals,
                            'Alergi',
                            baby.condition ?? 'Tidak ada',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Tombol aksi di bagian bawah
              const SizedBox(height: 16),
              Row(
                children: [
                  // Tombol lihat riwayat
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navigasi ke halaman riwayat memasak dengan bayi terpilih
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => CookingHistoryScreen(
                                  babyId: baby.id.toString(),
                                ),
                          ),
                        ).then((value) {
                          if (mounted) {
                            context.read<BabyBloc>().add(FetchBabies());
                          }
                        });
                      },
                      icon: const Icon(Symbols.history, size: 16),
                      label: const Text(
                        'Riwayat',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk kartu tambah bayi baru
  Widget _buildAddBabyCard(bool isCurrentItem) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: isCurrentItem ? 0 : 15,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(200),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ikon dan judul
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.bisque,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Symbols.child_care,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Tambah Profil Bayi Baru',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Tambahkan data bayi untuk mendapatkan rekomendasi makanan yang sesuai dengan kebutuhan si kecil',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                ),
              ),
              const SizedBox(height: 32),
              // Tombol tambah
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BabyAddScreen(),
                    ),
                  ).then((_) {
                    setState(() {});
                  });
                },
                icon: const Icon(Symbols.add),
                label: const Text('Tambah Bayi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk baris informasi bayi
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textGrey),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textGrey.withAlpha(200),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textBlack,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Dialog konfirmasi hapus bayi
  void _showDeleteConfirmation(Baby baby) {
    showDialog(
      context: context,
      builder:
          (context) => ConfirmDialog(
            titleText: 'Konfirmasi Hapus',
            contentText: 'Anda yakin ingin menghapus Profil Bayi ini?',
            confirmButtonText: 'Hapus',
            cancelButtonText: 'Batal',
            confirmButtonColor: AppColors.error,
            onConfirm: () {
              Navigator.pop(context);
              context.read<BabyBloc>().add(DeleteBabies(babyId: baby.id));
            },
            onCancel: () => Navigator.pop(context, false),
          ),
    );
  }
}
