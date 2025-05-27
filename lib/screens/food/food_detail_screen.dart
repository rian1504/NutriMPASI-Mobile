import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/blocs/authentication/authentication_bloc.dart';
import 'package:nutrimpasi/blocs/baby/baby_bloc.dart';
import 'package:nutrimpasi/blocs/food/food_bloc.dart';
import 'package:nutrimpasi/blocs/food_detail/food_detail_bloc.dart';
import 'package:nutrimpasi/blocs/report/report_bloc.dart';
import 'package:nutrimpasi/blocs/schedule/schedule_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/screens/food/cooking_guide_screen.dart';

class FoodDetailScreen extends StatefulWidget {
  final int foodId;
  const FoodDetailScreen({super.key, required this.foodId});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  final formKey = GlobalKey<FormState>();
  String reportReason = '';

  @override
  void initState() {
    super.initState();

    // Ambil data detail makanan
    context.read<FoodDetailBloc>().add(FetchFoodDetail(foodId: widget.foodId));
  }

  @override
  Widget build(BuildContext context) {
    // Dapatkan data user dari authentication bloc
    final authState = context.watch<AuthenticationBloc>().state;
    final loggedInUser = authState is LoginSuccess ? authState.user : null;

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
                            Padding(
                              padding: const EdgeInsets.only(bottom: 64.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).padding.top + 225,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.elliptical(200, 70),
                                    bottomRight: Radius.elliptical(200, 70),
                                  ),
                                ),
                              ),
                            ),

                            // Tombol kembali
                            Positioned(
                              top: MediaQuery.of(context).padding.top + 16,
                              left: 16,
                              child: Padding(
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
                                      onPressed: () {
                                        context.read<FoodBloc>().add(
                                          FetchFoods(),
                                        );
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Tombol lapor
                            if (food.source == null &&
                                food.userId != loggedInUser?.id)
                              Positioned(
                                top: MediaQuery.of(context).padding.top + 24,
                                right: 24,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Material(
                                    elevation: 3,
                                    shadowColor: Colors.black54,
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Symbols.error_outline_rounded,
                                          color: AppColors.primary,
                                          size: 36,
                                        ),
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          // Menampilkan dialog laporan
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return BlocConsumer<
                                                ReportBloc,
                                                ReportState
                                              >(
                                                listener: (context, state) {
                                                  if (state is ReportSuccess) {
                                                    Navigator.pop(context);

                                                    _showDialogReportSuccess();
                                                  } else if (state
                                                      is ReportError) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          state.error,
                                                        ),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    );
                                                  }
                                                },
                                                builder: (context, state) {
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
                                                      child: Form(
                                                        key: formKey,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  'Laporkan Resep',
                                                                  style: TextStyle(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color:
                                                                        AppColors
                                                                            .textBlack,
                                                                  ),
                                                                ),

                                                                Material(
                                                                  color:
                                                                      Colors
                                                                          .transparent,
                                                                  child: InkWell(
                                                                    onTap:
                                                                        state
                                                                                is ReportLoading
                                                                            ? null
                                                                            : () => Navigator.pop(
                                                                              context,
                                                                            ),
                                                                    customBorder:
                                                                        const CircleBorder(),
                                                                    child: Container(
                                                                      width: 24,
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
                                                                          Icons
                                                                              .close,
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

                                                            const SizedBox(
                                                              height: 16,
                                                            ),

                                                            const Text(
                                                              'Alasan laporan:',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 14,
                                                                color:
                                                                    AppColors
                                                                        .textGrey,
                                                              ),
                                                            ),

                                                            const SizedBox(
                                                              height: 8,
                                                            ),

                                                            TextFormField(
                                                              onChanged: (
                                                                value,
                                                              ) {
                                                                reportReason =
                                                                    value;
                                                              },
                                                              maxLines: 5,
                                                              decoration: InputDecoration(
                                                                hintText:
                                                                    'Tuliskan alasan laporan...',
                                                                border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        8,
                                                                      ),
                                                                ),
                                                                contentPadding:
                                                                    const EdgeInsets.all(
                                                                      12,
                                                                    ),
                                                              ),
                                                              validator: (
                                                                value,
                                                              ) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .trim()
                                                                        .isEmpty) {
                                                                  return 'Alasan laporan tidak boleh kosong';
                                                                }
                                                                if (value
                                                                        .trim()
                                                                        .length <
                                                                    4) {
                                                                  return 'Alasan laporan minimal 4 karakter';
                                                                }
                                                                return null;
                                                              },
                                                            ),

                                                            const SizedBox(
                                                              height: 24,
                                                            ),

                                                            // Tombol Kirim Laporan
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: ElevatedButton(
                                                                onPressed:
                                                                    state
                                                                            is ReportLoading
                                                                        ? null
                                                                        : () {
                                                                          if (formKey
                                                                              .currentState!
                                                                              .validate()) {
                                                                            context
                                                                                .read<
                                                                                  ReportBloc
                                                                                >()
                                                                                .add(
                                                                                  Report(
                                                                                    category:
                                                                                        "food",
                                                                                    refersId:
                                                                                        food.id,
                                                                                    content:
                                                                                        reportReason,
                                                                                  ),
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
                                                                  padding:
                                                                      const EdgeInsets.symmetric(
                                                                        vertical:
                                                                            12,
                                                                        horizontal:
                                                                            24,
                                                                      ),
                                                                ),
                                                                child:
                                                                    state
                                                                            is ReportLoading
                                                                        ? const CircularProgressIndicator(
                                                                          color:
                                                                              Colors.white,
                                                                          strokeWidth:
                                                                              2,
                                                                        )
                                                                        : const Text(
                                                                          'Kirim Laporan',
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
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
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
                              top: MediaQuery.of(context).padding.top + 175,
                              right: 24,
                              child: GestureDetector(
                                onTap: () {
                                  context.read<FoodDetailBloc>().add(
                                    ToggleFavorite(foodId: food.id),
                                  );
                                },
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
                                      Positioned(
                                        top: 12,
                                        child: Icon(
                                          food.isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: AppColors.red,
                                          size: 20,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 4,
                                        child: Text(
                                          food.favoritesCount.toString(),
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                            color: AppColors.textBlack,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                                      color: AppColors.accent.withAlpha(25),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      food.age!,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        color: AppColors.accent,
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
                                          color: AppColors.accent,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          food.user!.name,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.accent,
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

                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                          0.075,
                                    ),
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
                      vertical: 24.0,
                      horizontal: 36.0,
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
                                  DateTime? selectedDate;
                                  String? babyValidationError;
                                  String? dateValidationError;

                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return BlocListener<
                                        ScheduleBloc,
                                        ScheduleState
                                      >(
                                        listener: (context, state) {
                                          if (state is ScheduleStored) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Jadwal berhasil disimpan',
                                                ),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                            Navigator.pop(context);
                                          } else if (state is ScheduleError) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(state.error),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        },
                                        child: Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
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
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors.white,
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
                                                    'Atur Jadwal Memasak',
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          AppColors.textBlack,
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
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          babyValidationError !=
                                                                  null
                                                              ? Colors.red
                                                              : AppColors
                                                                  .componentGrey!,
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
                                                        vertical: 8,
                                                      ),
                                                  child: Column(
                                                    children:
                                                        babies.map((baby) {
                                                          return Row(
                                                            children: [
                                                              Checkbox(
                                                                value:
                                                                    selectedBabies[baby
                                                                        .id] ??
                                                                    false,
                                                                onChanged: (
                                                                  value,
                                                                ) {
                                                                  setState(() {
                                                                    selectedBabies[baby
                                                                            .id] =
                                                                        value!;
                                                                    if (value) {
                                                                      babyValidationError =
                                                                          null;
                                                                    }
                                                                  });
                                                                },
                                                                activeColor:
                                                                    AppColors
                                                                        .primary,
                                                              ),
                                                              Text(
                                                                baby.name,
                                                                style: const TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }).toList(),
                                                  ),
                                                ),
                                                if (babyValidationError != null)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 6,
                                                          left: 12,
                                                        ),
                                                    child: Text(
                                                      babyValidationError!,
                                                      style: const TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 12,
                                                        fontFamily: 'Poppins',
                                                      ),
                                                    ),
                                                  ),
                                                const SizedBox(height: 16),

                                                // Pilihan tanggal
                                                const Text(
                                                  'Pilih Tanggal',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                    color: AppColors.textGrey,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                InkWell(
                                                  onTap: () async {
                                                    final DateTime? pickedDate =
                                                        await showDatePicker(
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
                                                          locale: const Locale(
                                                            'id',
                                                            'ID',
                                                          ),
                                                        );
                                                    if (pickedDate != null) {
                                                      setState(() {
                                                        selectedDate =
                                                            pickedDate;
                                                        dateValidationError =
                                                            null;
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 12,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color:
                                                            dateValidationError !=
                                                                    null
                                                                ? Colors.red
                                                                : AppColors
                                                                    .componentGrey!,
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
                                                          selectedDate != null
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
                                                            fontSize: 14,
                                                            color:
                                                                selectedDate !=
                                                                        null
                                                                    ? AppColors
                                                                        .textBlack
                                                                    : AppColors
                                                                        .textGrey,
                                                          ),
                                                        ),
                                                        const Icon(
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
                                                if (dateValidationError != null)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 6,
                                                          left: 12,
                                                        ),
                                                    child: Text(
                                                      dateValidationError!,
                                                      style: const TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 12,
                                                        fontFamily: 'Poppins',
                                                      ),
                                                    ),
                                                  ),
                                                const SizedBox(height: 24),

                                                // Tombol simpan jadwal
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: BlocBuilder<
                                                    ScheduleBloc,
                                                    ScheduleState
                                                  >(
                                                    builder: (
                                                      context,
                                                      blocState,
                                                    ) {
                                                      final isLoading =
                                                          blocState
                                                              is ScheduleLoading;

                                                      return ElevatedButton(
                                                        onPressed:
                                                            isLoading
                                                                ? null
                                                                : () {
                                                                  bool isValid =
                                                                      true;

                                                                  // Validasi bayi
                                                                  final selectedBabyId =
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

                                                                  if (selectedBabyId
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

                                                                  // Jika valid, simpan jadwal
                                                                  if (isValid) {
                                                                    context
                                                                        .read<
                                                                          ScheduleBloc
                                                                        >()
                                                                        .add(
                                                                          StoreSchedules(
                                                                            foodId:
                                                                                food.id.toString(),
                                                                            babyId:
                                                                                selectedBabyId,
                                                                            date:
                                                                                selectedDate!,
                                                                          ),
                                                                        );
                                                                  }
                                                                },
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              AppColors.accent,
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
                                                        child:
                                                            isLoading
                                                                ? const SizedBox(
                                                                  width: 20,
                                                                  height: 20,
                                                                  child: CircularProgressIndicator(
                                                                    color:
                                                                        Colors
                                                                            .white,
                                                                    strokeWidth:
                                                                        2.0,
                                                                  ),
                                                                )
                                                                : const Text(
                                                                  'Simpan',
                                                                  style: TextStyle(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
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
                                  String? babyValidationError;

                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
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
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white,
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

                                              // Pilihan bayi dengan validasi visual
                                              const Text(
                                                'Pilih Profil Bayi',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 14,
                                                  color: AppColors.textGrey,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        babyValidationError !=
                                                                null
                                                            ? Colors.red
                                                            : AppColors
                                                                .componentGrey!,
                                                    width:
                                                        babyValidationError !=
                                                                null
                                                            ? 1.5
                                                            : 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                child: Column(
                                                  children:
                                                      babies.map((baby) {
                                                        return Row(
                                                          children: [
                                                            Checkbox(
                                                              value:
                                                                  selectedBabies[baby
                                                                      .id] ??
                                                                  false,
                                                              onChanged: (
                                                                value,
                                                              ) {
                                                                setState(() {
                                                                  selectedBabies[baby
                                                                          .id] =
                                                                      value!;
                                                                  if (value) {
                                                                    babyValidationError =
                                                                        null;
                                                                  }
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
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                            ),
                                                          ],
                                                        );
                                                      }).toList(),
                                                ),
                                              ),
                                              if (babyValidationError != null)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        top: 6,
                                                        left: 12,
                                                      ),
                                                  child: Text(
                                                    babyValidationError!,
                                                    style: const TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                ),

                                              const SizedBox(height: 24),

                                              // Tombol lanjutkan
                                              SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    // Validasi apakah minimal satu bayi dipilih
                                                    final isAnyBabySelected =
                                                        selectedBabies.values
                                                            .any(
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
                                                                        .toList(),
                                                              ),
                                                        ),
                                                      );
                                                    } else {
                                                      setState(() {
                                                        babyValidationError =
                                                            'Pilih minimal 1 bayi';
                                                      });
                                                    }
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.accent,
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
                                                    'Lanjutkan',
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
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
                    color: AppColors.accent,
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

  void _showDialogReportSuccess() {
    // Tampilkan dialog sukses
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        Future.delayed(Duration(seconds: 2), () {
          // Cek apakah dialogContext masih terpasang
          if (dialogContext.mounted && Navigator.canPop(dialogContext)) {
            Navigator.of(dialogContext).pop();
          }
        });

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Gambar sukses
                Image.asset(
                  'assets/images/component/berhasil_melaporkan_makanan.png',
                  height: 200,
                  width: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                // Teks berhasil
                const Text(
                  'Berhasil Melaporkan Resep',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Usulan Makanan',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
