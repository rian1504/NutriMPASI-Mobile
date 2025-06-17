import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/blocs/authentication/authentication_bloc.dart';
import 'package:nutrimpasi/blocs/baby/baby_bloc.dart';
import 'package:nutrimpasi/blocs/baby_food_recommendation/baby_food_recommendation_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/main.dart';
import 'package:nutrimpasi/models/baby_food_recommendation.dart';
import 'package:nutrimpasi/models/baby.dart';
import 'package:nutrimpasi/screens/baby/baby_list_screen.dart';
import 'package:nutrimpasi/screens/baby/baby_edit_screen.dart';
import 'package:nutrimpasi/screens/food/cooking_history_screen.dart';
import 'package:nutrimpasi/screens/food/food_detail_screen.dart';
import 'package:nutrimpasi/screens/features/notification_screen.dart';
import 'package:nutrimpasi/screens/features/nutritionist_profile_screen.dart';
import 'package:nutrimpasi/screens/features/feature_list_screen.dart';
import 'package:nutrimpasi/screens/food/food_recommendation_screen.dart';
import 'package:nutrimpasi/screens/features/learning_material_screen.dart';
import 'package:nutrimpasi/screens/setting/favorite_recipes_screen.dart';
import 'package:nutrimpasi/utils/navigation_animation.dart';
import 'package:nutrimpasi/widgets/custom_button.dart';
import 'package:nutrimpasi/widgets/custom_message_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // Controller PageView untuk bayi (vertikal)
  final PageController _babyController = PageController();
  // Controller untuk carousel rekomendasi makanan
  final PageController _foodRecommendationController = PageController();
  int _currentBabyIndex = 0;
  int _currentRecommendationIndex = 0;
  Timer? _autoScrollTimer;

  // Status loading data bayi
  bool _isBabyDataLoading = true;

  // Controller untuk animasi gambar bayi
  late AnimationController _imageAnimationController;
  late Animation<double> _scaleAnimation;
  bool _showFirstImage = true;

  @override
  void initState() {
    super.initState();
    _initAnimationController();
    _initBabyController();
    _startAutoScroll();

    // Load data
    final babyState = context.read<BabyBloc>().state;
    if (babyState is! BabyLoaded) {
      context.read<BabyBloc>().add(FetchBabies());
    } else {
      // Jika data sudah ter-load, perbarui status loading
      setState(() {
        _isBabyDataLoading = false;
        babies = babyState.babies;
      });

      if (babyState.babies.isNotEmpty) {
        context.read<BabyFoodRecommendationBloc>().add(
          FetchBabyFoodRecommendation(babyId: babyState.babies.first.id),
        );
      }
    }
  }

  // Mulai auto scroll untuk rekomendasi
  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted || _recommendedFoods.isEmpty) return;

      if (_foodRecommendationController.hasClients &&
          _foodRecommendationController.positions.isNotEmpty &&
          _foodRecommendationController.position.hasContentDimensions) {
        final nextIndex =
            (_currentRecommendationIndex + 1) % _recommendedFoods.length;

        _foodRecommendationController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );

        setState(() {
          _currentRecommendationIndex = nextIndex;
        });
      }
    });
  }

  // Inisialisasi controller animasi untuk gambar bayi
  void _initAnimationController() {
    _imageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.95,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 40,
      ),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.0), weight: 20),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.95,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
    ]).animate(_imageAnimationController);

    _imageAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {
          _showFirstImage = !_showFirstImage;
        });
        if (mounted) {
          _imageAnimationController.reset();
          _imageAnimationController.forward();
        }
      }
    });

    _imageAnimationController.forward();
  }

  void _initBabyController() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _babyController.addListener(() {
        if (!mounted ||
            !_babyController.hasClients ||
            _babyController.positions.isEmpty) {
          return;
        }

        if (!_babyController.position.hasContentDimensions) {
          return;
        }

        final double currentOffset = _babyController.offset;
        final double maxScrollExtent = _babyController.position.maxScrollExtent;
        final int currentPageFloor =
            _babyController.page?.floor() ?? _currentBabyIndex;
        final int currentPageRound =
            _babyController.page?.round() ?? _currentBabyIndex;
        const double overscrollThreshold = 50.0;

        if (babies.isEmpty) return;

        // Mengatur halaman bayi saat mencapai batas atas atau bawah
        if (currentPageFloor == babies.length - 1 &&
            currentOffset > maxScrollExtent + overscrollThreshold) {
          if (_currentBabyIndex != 0) {
            _babyController.animateToPage(
              0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
            );
            setState(() {
              _currentBabyIndex = 0;
            });
            return;
          }
        }

        // Mengatur halaman bayi saat mencapai batas bawah
        if (currentPageRound != _currentBabyIndex &&
            currentPageRound >= 0 &&
            currentPageRound < babies.length) {
          setState(() {
            _currentBabyIndex = currentPageRound;
          });

          // Fetch rekomendasi untuk bayi yang baru dipilih
          if (babies.isNotEmpty) {
            // Reset index rekomendasi ketika bayi berubah
            setState(() {
              _currentRecommendationIndex = 0;
            });

            // Pastikan carousel rekomendasi kembali ke halaman pertama
            if (_foodRecommendationController.hasClients) {
              _foodRecommendationController.jumpToPage(0);
            }

            context.read<BabyFoodRecommendationBloc>().add(
              FetchBabyFoodRecommendation(babyId: babies[currentPageRound].id),
            );
          }
        }
      });
    });
  }

  @override
  void dispose() {
    if (_imageAnimationController.isAnimating) {
      _imageAnimationController.stop();
    }

    _imageAnimationController.dispose();
    _babyController.dispose();
    _foodRecommendationController.dispose();
    _autoScrollTimer?.cancel();

    super.dispose();
  }

  List<Baby> babies = [];
  List<BabyFoodRecommendation> _recommendedFoods = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.bisque, toolbarHeight: 1),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, authState) {
          if (authState is AuthenticationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (authState is LoginSuccess) {
            // Bungkus konten utama dengan BlocConsumer untuk BabyBloc
            return BlocConsumer<BabyBloc, BabyState>(
              listener: (context, babyState) {
                if (babyState is BabyLoaded) {
                  if (_isBabyDataLoading) {
                    setState(() {
                      babies = babyState.babies;
                      _isBabyDataLoading = false;
                    });
                    // Trigger fetch rekomendasi saat bayi pertama kali load
                    if (babyState.babies.isNotEmpty) {
                      context.read<BabyFoodRecommendationBloc>().add(
                        FetchBabyFoodRecommendation(
                          babyId: babyState.babies.first.id,
                        ),
                      );
                    }
                  }
                }
              },
              builder: (context, babyState) {
                if (babyState is BabyLoaded && babies.isEmpty) {
                  babies = babyState.babies;
                  _isBabyDataLoading = false;
                }
                return _buildHomeContent();
              },
            );
          } else if (authState is AuthenticationUnauthenticated) {
            // langsung arahkan ke login
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/login');
            });
            return const SizedBox();
          } else {
            // langsung arahkan ke login
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/login');
            });
            return const SizedBox(); // Default return to avoid null
          }
        },
      ),
    );
  }

  // Home Content
  Widget _buildHomeContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildFeaturesSection(),
            _buildRecommendationSection(),
          ],
        ),
      ),
    );
  }

  // Header dengan latar belakang banner dan kartu informasi bayi
  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Latar belakang banner
        Container(
          width: double.infinity,
          height: 300,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/banner/beranda.png'),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo dan nama aplikasi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/logo/nutrimpasi.png',
                        height: 55,
                      ),
                      const Text(
                        'NutriMPASI',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                    ],
                  ),
                  // Tombol notifikasi
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CircleButton(
                      // imagePath: 'assets/images/icon/daftar_notifikasi.png',
                      icon: AppIcons.notification,
                      onPressed: () {
                        pushWithSlideTransition(
                          context,
                          const NotificationScreen(),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Pesan sambutan
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, Moms',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    Text(
                      'Dukung perjalanan makan si kecil\ndengan rekomendasi nutrisi terbaik!',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Kartu informasi bayi bertumpuk
        Positioned(
          top: 140,
          left: 24,
          right: 24,
          child: SizedBox(
            height: 160,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Kartu bertumpuk dengan PageView vertikal untuk scrolling snap
                SizedBox(
                  width: MediaQuery.of(context).size.width - 48,
                  height: 200,
                  child: BlocBuilder<BabyBloc, BabyState>(
                    builder: (context, state) {
                      if (state is BabyLoading) {
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (state is BabyLoaded) {
                        babies = state.babies;
                      } else if (state is BabyError) {
                        return Center(child: Text(state.error));
                      }

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Kartu latar belakang bertumpuk
                          ...List.generate(babies.length, (index) {
                            if (index > _currentBabyIndex &&
                                index <= _currentBabyIndex + 2) {
                              final offset = (index - _currentBabyIndex) * 4.0;
                              final cardWidth =
                                  MediaQuery.of(context).size.width -
                                  48 -
                                  ((index - _currentBabyIndex) * 30.0);
                              final horizontalOffset =
                                  (MediaQuery.of(context).size.width -
                                      48 -
                                      cardWidth) /
                                  2;

                              return Positioned(
                                top: offset * 2.5,
                                left: horizontalOffset,
                                right: horizontalOffset,
                                child: Opacity(
                                  opacity:
                                      1.0 - ((index - _currentBabyIndex) * 0.3),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    width: cardWidth,
                                    child: Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: SizedBox(height: 140),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }),

                          // PageView kartu bayi utama
                          PageView.builder(
                            controller: _babyController,
                            scrollDirection: Axis.vertical,
                            itemCount: babies.isEmpty ? 1 : babies.length,
                            physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics(),
                            ),
                            itemBuilder: (context, index) {
                              if (babies.isEmpty) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Belum ada data bayi",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.textGrey,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              final baby = babies[index];
                              final bool isCurrentItem =
                                  index == _currentBabyIndex;

                              return AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: isCurrentItem ? 1.0 : 0.0,
                                child: IgnorePointer(
                                  ignoring: !isCurrentItem,
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          children: [
                                            // Avatar bayi
                                            SizedBox(
                                              width: 120,
                                              height: 120,
                                              child:
                                                  babies[index]
                                                          .isProfileComplete
                                                      ? Image.asset(
                                                        babies[index].gender ==
                                                                'L'
                                                            ? 'assets/images/component/bayi_laki_laki.png'
                                                            : 'assets/images/component/bayi_perempuan.png',
                                                        fit: BoxFit.contain,
                                                      )
                                                      : Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          Opacity(
                                                            opacity: 0,
                                                            child: Image.asset(
                                                              'assets/images/component/bayi_laki_laki_awal.png',
                                                              fit:
                                                                  BoxFit
                                                                      .contain,
                                                              width: 120,
                                                              height: 120,
                                                            ),
                                                          ),
                                                          Opacity(
                                                            opacity: 0,
                                                            child: Image.asset(
                                                              'assets/images/component/bayi_perempuan_awal.png',
                                                              fit:
                                                                  BoxFit
                                                                      .contain,
                                                              width: 120,
                                                              height: 120,
                                                            ),
                                                          ),
                                                          ScaleTransition(
                                                            scale:
                                                                _scaleAnimation,
                                                            child: Image.asset(
                                                              _showFirstImage
                                                                  ? 'assets/images/component/bayi_laki_laki_awal.png'
                                                                  : 'assets/images/component/bayi_perempuan_awal.png',
                                                              fit:
                                                                  BoxFit
                                                                      .contain,
                                                              width: 120,
                                                              height: 120,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                            ),
                                            const SizedBox(width: 16),
                                            // Informasi bayi
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    baby.name,
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          AppColors.textBlack,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  if (baby
                                                      .isProfileComplete) ...[
                                                    // Informasi usia (Age)
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/icon/umur.png',
                                                          width: 12,
                                                          height: 12,
                                                          color:
                                                              AppColors
                                                                  .textGrey,
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          baby.ageInMonths!,
                                                          style: const TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                AppColors
                                                                    .textGrey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),

                                                    // Informasi tinggi (Height)
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/icon/tinggi.png',
                                                          width: 12,
                                                          height: 12,
                                                          color:
                                                              AppColors
                                                                  .textGrey,
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          '${baby.height ?? '-'} cm',
                                                          style: const TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                AppColors
                                                                    .textGrey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),

                                                    // Informasi berat (Weight)
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/icon/berat.png',
                                                          width: 12,
                                                          height: 12,
                                                          color:
                                                              AppColors
                                                                  .textGrey,
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          '${baby.weight ?? '-'} kg',
                                                          style: const TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                AppColors
                                                                    .textGrey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),

                                                    // Informasi alergi (Allergy)
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/icon/alergi.png',
                                                          width: 12,
                                                          height: 12,
                                                          color:
                                                              AppColors
                                                                  .textGrey,
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          baby.condition ??
                                                              'Tidak ada alergi',
                                                          style: const TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                AppColors
                                                                    .textGrey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ] else
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    BabyEditScreen(
                                                                      baby:
                                                                          baby,
                                                                    ),
                                                          ),
                                                        );
                                                      },
                                                      child: Text(
                                                        'Lengkapi Data Bayi',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              AppColors.accent,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
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
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Tombol tambah bayi
                Positioned(
                  right: -24,
                  top: 45,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BabyListScreen(),
                        ),
                      );
                    },
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(20),
                    ),
                    child: Container(
                      width: 80,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(50),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Symbols.add_2_rounded,
                        color: Colors.white,
                        size: 32,
                        weight: 900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Bagian rekomendasi makanan
  Widget _buildRecommendationSection() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul bagian
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: InkWell(
              onTap: () {
                // Navigasi hanya jika memiliki rekomendasi
                if (_recommendedFoods.isNotEmpty &&
                    babies.any((baby) => baby.isProfileComplete)) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => FoodRecommendationScreen(
                            recommendedFoods: _recommendedFoods,
                          ),
                    ),
                  );
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rekomendasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    const Icon(
                      Symbols.arrow_forward_ios_rounded,
                      size: 16,
                      color: AppColors.textBlack,
                      weight: 900,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),

          // Tampilkan konten berdasarkan status saat ini
          BlocBuilder<BabyFoodRecommendationBloc, BabyFoodRecommendationState>(
            builder: (context, state) {
              if (state is BabyFoodRecommendationLoading) {
                return Center(child: CircularProgressIndicator());
              }

              if (state is BabyFoodRecommendationError) {
                // Periksa apakah ada profil yang belum lengkap
                if (!babies.any((baby) => baby.isProfileComplete)) {
                  return _buildLockedRecommendation();
                }
                return Center(
                  child: Text(
                    state.error,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textBlack,
                    ),
                  ),
                );
              }

              if (state is BabyFoodRecommendationLoaded) {
                _recommendedFoods = state.foods;

                // Reset index rekomendasi dan posisi carousel ketika makanan baru dimuat
                if (_recommendedFoods.isNotEmpty &&
                    (_currentRecommendationIndex >= _recommendedFoods.length ||
                        (_recommendedFoods.isNotEmpty &&
                            _recommendedFoods.first.food.id !=
                                state.foods.first.food.id))) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _currentRecommendationIndex = 0;
                      });
                      if (_foodRecommendationController.hasClients) {
                        _foodRecommendationController.jumpToPage(0);
                      }
                    }
                  });
                }
              }

              return _isBabyDataLoading
                  ? _buildLoadingRecommendation()
                  : _buildRecommendationContent();
            },
          ),
        ],
      ),
    );
  }

  // Indikator loading untuk rekomendasi
  Widget _buildLoadingRecommendation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          height: 132,
          child: Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          ),
        ),
      ),
    );
  }

  // Konten untuk rekomendasi (terkunci atau carousel)
  Widget _buildRecommendationContent() {
    // Periksa apakah ada bayi yang profilnya lengkap
    bool hasCompleteBabyProfile = babies.any((baby) {
      return baby.isProfileComplete == true;
    });

    // Tampilkan rekomendasi terkunci jika profil tidak lengkap
    if (!hasCompleteBabyProfile) {
      return _buildLockedRecommendation();
    }
    // Tampilkan carousel jika kita memiliki data makanan dan profil lengkap
    else if (_recommendedFoods.isNotEmpty) {
      return _buildRecommendationCarousel();
    }
    // Tampilkan status kosong untuk kasus lainnya (profil lengkap tapi tidak ada makanan)
    else {
      return _buildEmptyRecommendation();
    }
  }

  // Widget untuk menampilkan status kosong ketika tidak ada rekomendasi
  Widget _buildEmptyRecommendation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: EmptyMessage(
        title: 'Belum ada rekomendasi makanan',
        subtitle:
            'Tidak ada rekomendasi makanan yang sesuai untuk bayi kamu saat ini',
        iconName: Symbols.restaurant_menu,
      ),
    );
  }

  // Kartu rekomendasi terkunci
  Widget _buildLockedRecommendation() {
    return SizedBox(
      height: 180,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: GestureDetector(
          onTap:
              babies.isNotEmpty
                  ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                BabyEditScreen(baby: babies[_currentBabyIndex]),
                      ),
                    );
                  }
                  : null,
          child: Stack(
            children: [
              // Gambar latar belakang
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  "assets/images/component/rekomendasi_terkunci.png",
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 40),
                      ),
                ),
              ),

              // Overlay gelap
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(150),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),

              // Icon gembok
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Symbols.lock, color: Colors.white, size: 40),
                    const SizedBox(height: 12),
                    const Text(
                      'Fitur ini terkunci',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Gradient overlay
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 70,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withAlpha(200)],
                    ),
                  ),
                ),
              ),

              // Teks informasi
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Lengkapi profil bayi untuk melihat rekomendasi',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Carousel untuk rekomendasi
  Widget _buildRecommendationCarousel() {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _foodRecommendationController,
        itemCount:
            _recommendedFoods.isEmpty ? 1 : _recommendedFoods.length * 1000,
        onPageChanged: (index) {
          if (mounted) {
            setState(() {
              _currentRecommendationIndex =
                  _recommendedFoods.isEmpty
                      ? 0
                      : index % _recommendedFoods.length;
            });
          }
        },
        itemBuilder: (context, index) {
          if (_recommendedFoods.isEmpty) {
            return _buildLoadingRecommendation();
          }
          final food = _recommendedFoods[index % _recommendedFoods.length];
          return _buildFoodRecommendationCard(food);
        },
      ),
    );
  }

  // Card untuk rekomendasi makanan
  Widget _buildFoodRecommendationCard(
    BabyFoodRecommendation babyFoodRecommendation,
  ) {
    final food = babyFoodRecommendation.food;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodDetailScreen(foodId: food.id),
            ),
          );
        },
        child: Stack(
          children: [
            // Gambar makanan
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                storageUrl + food.image,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),

            // Gradient overlay
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 70,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withAlpha(175)],
                  ),
                ),
              ),
            ),

            // Informasi makanan
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Food name
                  Expanded(
                    child: Text(
                      food.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Sumber makanan
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      food.source ?? "PENGGUNA",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Indikator halaman
            Positioned(
              top: 12,
              right: 12,
              child: Row(
                children: List.generate(_recommendedFoods.length, (i) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          i == _currentRecommendationIndex
                              ? AppColors.accent
                              : Colors.white.withAlpha(125),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bagian carousel fitur lainnya
  Widget _buildFeaturesSection() {
    // Data fitur
    final List<Map<String, dynamic>> features = [
      {
        'title': 'Materi Pembelajaran',
        'image': 'assets/images/card/materi_pembelajaran.png',
        'navigate': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LearningMaterialScreen(),
            ),
          );
        },
      },
      {
        'title': 'Konsultasi Ahli Gizi',
        'image': 'assets/images/card/konsultasi_ahli_gizi.png',
        'navigate': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NutritionistProfileScreen(),
            ),
          );
        },
      },
      {
        'title': 'Riwayat Memasak',
        'image': 'assets/images/card/riwayat_memasak.png',
        'navigate': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CookingHistoryScreen(),
            ),
          );
        },
      },
      {
        'title': 'Usulan Makanan',
        'image': 'assets/images/card/usulan_makanan.png',
        'navigate': (BuildContext context) {
          _navigateToFoodList(showUserSuggestions: true);
        },
      },
      {
        'title': 'Makanan Favorit',
        'image': 'assets/images/card/makanan_favorit.png',
        'navigate': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FavoriteRecipeScreen(),
            ),
          );
        },
      },
    ];

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul bagian
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeatureListScreen(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Fitur Lainnya',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    const Icon(
                      Symbols.arrow_forward_ios_rounded,
                      size: 16,
                      color: AppColors.textBlack,
                      weight: 900,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Carousel kartu fitur
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: features.length,
              itemBuilder: (context, index) {
                final feature = features[index];
                final cardColor =
                    index % 2 == 0 ? AppColors.bisque : AppColors.lavenderBlue;

                return Column(
                  children: [
                    // Kartu fitur dengan InkWell
                    InkWell(
                      onTap: () {
                        if (feature['navigate'] != null) {
                          feature['navigate'](context);
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 140,
                        height: 140,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(50),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            feature['image'],
                            width: 120,
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Judul fitur
                    SizedBox(
                      width: 140,
                      child: Text(
                        feature['title'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
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
    );
  }

  void _navigateToFoodList({bool showUserSuggestions = false}) {
    // Fungsi untuk navigasi ke FoodListScreen
    final MainPageState? mainPage =
        context.findAncestorStateOfType<MainPageState>();
    if (mainPage != null) {
      mainPage.changePage(
        1,
        additionalParams: {'showUserSuggestions': showUserSuggestions},
      );
    }
  }
}
