import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/blocs/baby/baby_bloc.dart';
import 'package:nutrimpasi/blocs/food/food_bloc.dart';
import 'package:nutrimpasi/blocs/food_detail/food_detail_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/screens/food/cooking_guide_screen.dart';

class FoodDetailScreen extends StatefulWidget {
  final String foodId;
  const FoodDetailScreen({super.key, required this.foodId});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  @override
  void initState() {
    super.initState();

    // Ambil data detail makanan
    context.read<FoodDetailBloc>().add(FetchFoodDetail(foodId: widget.foodId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodDetailBloc, FoodDetailState>(
      builder: (context, state) {
        if (state is FoodDetailLoading) {
          return Scaffold(
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator()],
              ),
            ),
          );
        }

        if (state is FoodDetailError) {
          return Center(child: Text(state.error));
        }

        if (state is FoodDetailLoaded) {
          final food = state.food;

          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                // Bagian konten utama
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Bagian header
                        Stack(
                          children: [
                            // Latar belakang gradien
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
                                onPressed: () {
                                  context.read<FoodBloc>().add(FetchFoods());
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(12),
                                  elevation: 2,
                                ),
                                child: const Icon(
                                  Symbols.arrow_back_ios_new,
                                  color: AppColors.textBlack,
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
                                    // Gambar makanan
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
                                          storageUrl + food.image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Tombol favorit
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
                                        food.isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: AppColors.primary,
                                        size: 24,
                                      ),
                                      onPressed: () {
                                        context.read<FoodDetailBloc>().add(
                                          ToggleFavorite(
                                            foodId: food.id.toString(),
                                          ),
                                        );
                                      },
                                      padding: EdgeInsets.zero,
                                    ),
                                    Positioned(
                                      bottom: 4,
                                      child: Text(
                                        food.favoritesCount.toString(),
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

                        // Informasi makanan
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nama makanan
                              Text(
                                food.name,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textBlack,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Row(
                                children: [
                                  // Tag usia
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
                                      food.age!,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  // Tag kategori
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
                                      food.foodCategory!.name,
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

                              // Informasi sumber resep
                              const Text(
                                'Resep oleh: ',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: AppColors.textBlack,
                                ),
                              ),
                              Row(
                                children: [
                                  if (food.source == 'WHO')
                                    Image.asset(
                                      'assets/images/logo/who.png',
                                      width: 100,
                                      height: 30,
                                    )
                                  else if (food.source == 'KEMENKES')
                                    Image.asset(
                                      'assets/images/logo/kemenkes.png',
                                      width: 100,
                                      height: 30,
                                    )
                                  else if (food.source == null)
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

                              // Bagian deskripsi
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Deskripsi',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textBlack,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.075,
                                    child: SingleChildScrollView(
                                      child: Text(
                                        food.description,
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

                              // Bagian informasi nutrisi
                              Text(
                                'Nutrisi Per Set (${food.portion} Porsi)',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textBlack,
                                ),
                              ),

                              const SizedBox(height: 12),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Kartu energi
                                  _buildNutritionCard(
                                    'Energi',
                                    '${food.energy}',
                                    'kkal',
                                  ),
                                  Container(
                                    height: 40,
                                    width: 1,
                                    color: AppColors.textBlack.withAlpha(75),
                                  ),
                                  // Kartu protein
                                  _buildNutritionCard(
                                    'Protein',
                                    '${food.protein}',
                                    'g',
                                  ),
                                  Container(
                                    height: 40,
                                    width: 1,
                                    color: AppColors.textBlack.withAlpha(75),
                                  ),
                                  // Kartu lemak
                                  _buildNutritionCard(
                                    'Lemak',
                                    '${food.fat}',
                                    'g',
                                  ),
                                ],
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

                // Panel tombol aksi
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
                        color: Colors.black.withAlpha(75),
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
                        // Tombol jadwalkan
                        ElevatedButton(
                          onPressed: () {
                            // Ambil data bayi
                            final babyState = context.read<BabyBloc>().state;

                            if (babyState is BabyLoaded) {
                              final babies = babyState.babies;
                              // Dialog jadwal
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // Map untuk checkbox bayi (gunakan ID bayi sebagai key)
                                  Map<int, bool> selectedBabies = {
                                    for (var baby in babies) baby.id: false,
                                  };
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap:
                                                      () => Navigator.pop(
                                                        context,
                                                      ),
                                                  customBorder:
                                                      const CircleBorder(),
                                                  child: Container(
                                                    width: 24,
                                                    height: 24,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
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
                                                color: AppColors.textBlack,
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
                                              color: AppColors.textGrey,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          StatefulBuilder(
                                            builder: (context, setState) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children:
                                                    babies.map((baby) {
                                                      return Row(
                                                        children: [
                                                          Checkbox(
                                                            value:
                                                                selectedBabies[baby
                                                                    .id] ??
                                                                false,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                selectedBabies[baby
                                                                        .id] =
                                                                    value!;
                                                              });
                                                            },
                                                            activeColor:
                                                                AppColors
                                                                    .primary,
                                                          ),
                                                          Text(
                                                            baby.name,
                                                            style:
                                                                const TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 14,
                                                                ),
                                                          ),
                                                        ],
                                                      );
                                                    }).toList(),
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
                                              color: AppColors.textGrey,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          InkWell(
                                            onTap: () async {
                                              final DateTime?
                                              picked = await showDatePicker(
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color:
                                                      AppColors.componentGrey!,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
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

                                          // Tombol simpan jadwal
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                // TODO: Logika untuk menyimpan jadwal
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.secondary,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Gagal memuat data bayi'),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.textBlack,
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
                            // Ambil data bayi
                            final babyState = context.read<BabyBloc>().state;

                            if (babyState is BabyLoaded) {
                              final babies = babyState.babies;

                              // Dialog masak sekarang
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // Map untuk checkbox bayi (gunakan ID bayi sebagai key)
                                  Map<int, bool> selectedBabies = {
                                    for (var baby in babies) baby.id: false,
                                  };

                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap:
                                                      () => Navigator.pop(
                                                        context,
                                                      ),
                                                  customBorder:
                                                      const CircleBorder(),
                                                  child: Container(
                                                    width: 24,
                                                    height: 24,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
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
                                                color: AppColors.textBlack,
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
                                              color: AppColors.textGrey,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          StatefulBuilder(
                                            builder: (context, setState) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children:
                                                    babies.map((baby) {
                                                      return Row(
                                                        children: [
                                                          Checkbox(
                                                            value:
                                                                selectedBabies[baby
                                                                    .id] ??
                                                                false,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                selectedBabies[baby
                                                                        .id] =
                                                                    value!;
                                                              });
                                                            },
                                                            activeColor:
                                                                AppColors
                                                                    .primary,
                                                          ),
                                                          Text(
                                                            baby.name,
                                                            style:
                                                                const TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 14,
                                                                ),
                                                          ),
                                                        ],
                                                      );
                                                    }).toList(),
                                              );
                                            },
                                          ),

                                          const SizedBox(height: 24),

                                          // Tombol lanjutkan
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                // Validasi apakah minimal satu bayi dipilih
                                                final isAnyBabySelected =
                                                    selectedBabies.values.any(
                                                      (isSelected) =>
                                                          isSelected,
                                                    );

                                                if (isAnyBabySelected) {
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (
                                                            context,
                                                          ) => CookingGuideScreen(
                                                            foodId:
                                                                food.id
                                                                    .toString(),
                                                            babyId:
                                                                selectedBabies
                                                                    .entries
                                                                    .where(
                                                                      (entry) =>
                                                                          entry
                                                                              .value,
                                                                    )
                                                                    .map(
                                                                      (entry) =>
                                                                          entry
                                                                              .key
                                                                              .toString(),
                                                                    )
                                                                    .toList(),
                                                          ),
                                                    ),
                                                  );
                                                } else {
                                                  // Tampilkan pesan error
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Pilih minimal 1 bayi',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.secondary,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Gagal memuat data bayi'),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.textBlack,
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
        return const SizedBox.shrink();
      },
    );
  }

  // Widget untuk kartu nutrisi
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
