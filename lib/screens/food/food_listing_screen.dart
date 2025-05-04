import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/blocs/authentication/authentication_bloc.dart';
import 'package:nutrimpasi/blocs/food/food_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/screens/food/food_detail_screen.dart';
import 'package:nutrimpasi/models/food.dart';
import 'package:nutrimpasi/screens/food/food_add_suggestion_screen.dart';

class FoodListingScreen extends StatefulWidget {
  final bool showUserSuggestions;

  const FoodListingScreen({super.key, this.showUserSuggestions = false});

  @override
  State<FoodListingScreen> createState() => _FoodListingScreenState();
}

class _FoodListingScreenState extends State<FoodListingScreen>
    with SingleTickerProviderStateMixin {
  // Controller untuk pencarian
  final TextEditingController _searchController = TextEditingController();
  // Controller scroll
  final ScrollController _scrollController = ScrollController();
  // Status tombol scroll ke atas
  bool _showScrollToTop = false;
  // Status search bar pada AppBar
  bool _showSearchInAppBar = false;
  // Toggle tampilan usulan pengguna
  bool _showUserSuggestionsOnly = false;
  // Variable lazy loading
  int _displayedItemCount = 5;
  bool _isLoadingMore = false;

  // Animasi untuk transisi AppBar
  late AnimationController _animationController;
  late Animation<double> _appBarAnimation;

  // Filter data
  final Map<String, bool> _foodAgeFilters = {
    'Tekstur Halus': false,
    'Tekstur Kasar': false,
    'Finger Food': false,
  };
  late Map<String, bool> _foodCategoryFilters;
  final Map<String, bool> _recipeSourceFilters = {
    'KEMENKES': false,
    'WHO': false,
    'Rekomendasi Pengguna': false,
  };

  // Data makanan
  List<Food> get _foodItems {
    final state = context.read<FoodBloc>().state;
    return state is FoodLoaded ? state.foods : [];
  }

  bool _initialLoadCompleted = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    // menetapkan toggle
    _showUserSuggestionsOnly = widget.showUserSuggestions;

    // Inisialisasi animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Animasi untuk AppBar transition
    _appBarAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // if (foodState is! FoodLoaded) {
    //   context.read<FoodBloc>().add(FetchFoods());
    // }

    if (!_initialLoadCompleted) {
      context.read<FoodBloc>().add(FetchFoods());
      _initialLoadCompleted = true;
    }
  }

  // Deteksi posisi scroll
  void _scrollListener() {
    // Untuk deteksi scroll to top button
    if (_scrollController.offset >= 300 && !_showScrollToTop) {
      setState(() {
        _showScrollToTop = true;
      });
    } else if (_scrollController.offset < 300 && _showScrollToTop) {
      setState(() {
        _showScrollToTop = false;
      });
    }

    // Untuk deteksi search bar di AppBar dengan animasi
    if (_scrollController.offset >= 120 && !_showSearchInAppBar) {
      setState(() {
        _showSearchInAppBar = true;
      });
      _animationController.forward();
    } else if (_scrollController.offset < 120 && _showSearchInAppBar) {
      setState(() {
        _showSearchInAppBar = false;
      });
      _animationController.reverse();
    }

    // Deteksi untuk lazy loading
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _displayedItemCount < _getFilteredFoodItems().length) {
      _loadMoreItems();
    }
  }

  // Muat lebih banyak item
  void _loadMoreItems() {
    setState(() {
      _isLoadingMore = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _displayedItemCount =
            _displayedItemCount + 5 > _getFilteredFoodItems().length
                ? _getFilteredFoodItems().length
                : _displayedItemCount + 5;
        _isLoadingMore = false;
      });
    });
  }

  // Filter makanan berdasarkan sumber
  List<Food> _getFilteredFoodItems() {
    final authState = context.read<AuthenticationBloc>().state;

    int? userId;
    if (authState is LoginSuccess) {
      userId = authState.user.id;
    }

    if (_showUserSuggestionsOnly && userId != null) {
      return _foodItems.where((item) => item.userId == userId).toList();
    }

    return _foodItems;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Dialog bottom sheet filter
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.only(left: 28, right: 28, top: 28),
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                children: [
                  // Indikator panel
                  Center(
                    child: Container(
                      height: 8,
                      width: 75,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppColors.componentGrey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  // Area konten filter yang dapat di-scroll
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Filter kategori makanan
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Kategori Makanan',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBlack,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 8,
                              runSpacing: 0,
                              children:
                                  _foodCategoryFilters.keys.map((category) {
                                    return FilterChip(
                                      label: Text(category),
                                      selected: _foodCategoryFilters[category]!,
                                      selectedColor: AppColors.primary
                                          .withAlpha(50),
                                      checkmarkColor: AppColors.primary,
                                      backgroundColor: AppColors.cream
                                          .withAlpha(50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                          color:
                                              _foodCategoryFilters[category]!
                                                  ? AppColors.primary
                                                  : AppColors.componentGrey!,
                                        ),
                                      ),
                                      onSelected: (selected) {
                                        setState(() {
                                          _foodCategoryFilters[category] =
                                              selected;
                                        });
                                      },
                                    );
                                  }).toList(),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Filter usia konsumsi
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Usia Konsumsi',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBlack,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 8,
                              runSpacing: 0,
                              children:
                                  _foodAgeFilters.keys.map((age) {
                                    return FilterChip(
                                      label: Text(age),
                                      selected: _foodAgeFilters[age]!,
                                      selectedColor: AppColors.primary
                                          .withAlpha(50),
                                      checkmarkColor: AppColors.primary,
                                      backgroundColor: AppColors.cream
                                          .withAlpha(50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                          color:
                                              _foodAgeFilters[age]!
                                                  ? AppColors.primary
                                                  : AppColors.componentGrey!,
                                        ),
                                      ),
                                      onSelected: (selected) {
                                        setState(() {
                                          _foodAgeFilters[age] = selected;
                                        });
                                      },
                                    );
                                  }).toList(),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Filter sumber resep
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Sumber Resep',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBlack,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 8,
                              runSpacing: 0,
                              children:
                                  _recipeSourceFilters.keys.map((source) {
                                    return FilterChip(
                                      label: Text(source),
                                      selected: _recipeSourceFilters[source]!,
                                      selectedColor: AppColors.primary
                                          .withAlpha(50),
                                      checkmarkColor: AppColors.primary,
                                      backgroundColor: AppColors.cream
                                          .withAlpha(50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                          color:
                                              _recipeSourceFilters[source]!
                                                  ? AppColors.primary
                                                  : AppColors.componentGrey!,
                                        ),
                                      ),
                                      onSelected: (selected) {
                                        setState(() {
                                          _recipeSourceFilters[source] =
                                              selected;
                                        });
                                      },
                                    );
                                  }).toList(),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),

                  // Tombol terapkan
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // TODO: Logika filter
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Terapkan',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Widget pencarian
  Widget _buildSearchBar({bool inAppBar = false}) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.componentGrey!),
      ),
      child: TextField(
        controller: _searchController,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Cari Resep...',
          hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Icon(Icons.search, color: AppColors.textBlack, size: 22),
          ),
          // Tombol filter pencarian
          suffixIcon: Padding(
            padding: const EdgeInsets.all(6),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                _showFilterBottomSheet(context);
              },
              child: const Icon(Icons.tune, color: Colors.white, size: 18),
            ),
          ),
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pearl,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AnimatedBuilder(
          animation: _appBarAnimation,
          builder: (context, child) {
            return AppBar(
              backgroundColor: AppColors.pearl,
              elevation: 0,
              leadingWidth: Tween<double>(
                begin: 56.0,
                end: 0.0,
              ).evaluate(_appBarAnimation),
              titleSpacing: Tween<double>(
                begin: NavigationToolbar.kMiddleSpacing,
                end: 0.0,
              ).evaluate(_appBarAnimation),
              leading: Opacity(
                opacity: 1 - _appBarAnimation.value,
                child: Image.asset(
                  'assets/images/logo/nutrimpasi.png',
                  height: 40,
                ),
              ),
              title:
                  _showSearchInAppBar
                      ? Opacity(
                        opacity: _appBarAnimation.value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: _buildSearchBar(inAppBar: true),
                        ),
                      )
                      : null,
              actions:
                  _showSearchInAppBar
                      ? []
                      : [
                        // Tombol favorit
                        Opacity(
                          opacity: 1 - _appBarAnimation.value,
                          child: ElevatedButton(
                            onPressed:
                                _appBarAnimation.value < 0.5
                                    ? () {
                                      // TODO: Navigasi ke halaman favorit
                                    }
                                    : null,
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(4),
                              backgroundColor: Colors.white,
                              elevation: 2,
                            ),
                            child: Image.asset(
                              'assets/images/icon/daftar_favorit.png',
                              width: 24,
                              height: 24,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul halaman
              const Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Masak apa hari ini?',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBlack,
                      ),
                    ),
                  ],
                ),
              ),

              // Kotak pencarian
              AnimatedOpacity(
                opacity: _showSearchInAppBar ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _showSearchInAppBar ? 0 : 48,
                  child:
                      _showSearchInAppBar
                          ? const SizedBox()
                          : _buildSearchBar(),
                ),
              ),

              const SizedBox(height: 16),

              // Banner berdasarkan toggle dengan animasi fade
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child:
                    !_showUserSuggestionsOnly
                        // Banner daftar makanan untuk "Semua"
                        ? Container(
                          key: const ValueKey('daftar_makanan'),
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.componentGrey!),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(10),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/images/banner/daftar_makanan.png',
                              width: double.infinity,
                              height: 180,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: double.infinity,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    color: AppColors.componentGrey,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.image,
                                    color: AppColors.textGrey,
                                    size: 40,
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                        // Banner tambah usulan untuk "Usulan Saya"
                        : Container(
                          key: const ValueKey('tambah_usulan'),
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.componentGrey!),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(10),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Gambar latar belakang
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/banner/tambah_usulan_makanan.png',
                                  width: double.infinity,
                                  height: 180,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: double.infinity,
                                      height: 180,
                                      decoration: BoxDecoration(
                                        color: AppColors.componentGrey,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.image,
                                        color: AppColors.textGrey,
                                        size: 40,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // Panel konten
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  margin: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(225),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Informasi usulan
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              'Tambah Usulan',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.textBlack,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Tambahkan usulan resep dari kreasi kamu!',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                color: AppColors.textGrey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Tombol tambah
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: const BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 36,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        const FoodAddSuggestionScreen(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
              ),

              const SizedBox(height: 16),

              // Toggle pilihan tampilan dengan animasi slide
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(4),
                child: Stack(
                  children: [
                    // Animasi background slider
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      left:
                          _showUserSuggestionsOnly
                              ? MediaQuery.of(context).size.width / 2 - 24
                              : 4,
                      right:
                          _showUserSuggestionsOnly
                              ? 4
                              : MediaQuery.of(context).size.width / 2 - 24,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // Row untuk text
                    Row(
                      children: [
                        // Text "Semua"
                        Expanded(
                          child: AnimatedDefaultTextStyle(
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color:
                                  !_showUserSuggestionsOnly
                                      ? AppColors.textBlack
                                      : Colors.white,
                            ),
                            duration: const Duration(milliseconds: 300),
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text('Semua'),
                              ),
                            ),
                          ),
                        ),
                        // Text "Usulan Saya"
                        Expanded(
                          child: AnimatedDefaultTextStyle(
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color:
                                  _showUserSuggestionsOnly
                                      ? AppColors.textBlack
                                      : Colors.white,
                            ),
                            duration: const Duration(milliseconds: 300),
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text('Usulan Saya'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Area klik
                    Row(
                      children: [
                        // Area klik "Semua"
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                setState(() {
                                  _showUserSuggestionsOnly = false;
                                });
                              },
                              child: const SizedBox(height: double.infinity),
                            ),
                          ),
                        ),
                        // Area klik "Usulan Saya"
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                setState(() {
                                  _showUserSuggestionsOnly = true;
                                });
                              },
                              child: const SizedBox(height: double.infinity),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Daftar kartu makanan
              BlocBuilder<FoodBloc, FoodState>(
                builder: (context, state) {
                  if (state is FoodLoading) {
                    return const Center(
                      child: Column(
                        children: [
                          SizedBox(height: 100),
                          CircularProgressIndicator(),
                        ],
                      ),
                    );
                  }

                  if (state is FoodError) {
                    return Center(child: Text(state.error));
                  }

                  if (state is FoodLoaded) {
                    final categories = state.categories;
                    _foodCategoryFilters = {
                      for (var category in categories) category.name: false,
                    };

                    // Cek jika data kosong
                    if (_getFilteredFoodItems().isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            Icon(
                              Symbols.fastfood,
                              size: 60,
                              color: AppColors.textGrey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _showUserSuggestionsOnly
                                  ? 'Belum ada usulan makanan dari Anda'
                                  : 'Tidak ada makanan tersedia',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Jika ada data, tampilkan daftar makanan
                    return Column(
                      children: [
                        ..._getFilteredFoodItems().take(_displayedItemCount).map((
                          item,
                        ) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => FoodDetailScreen(
                                        foodId: item.id.toString(),
                                      ),
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  // Gambar makanan
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      storageUrl + item.image,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 8.0,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  // Nama makanan
                                                  Text(
                                                    item.name,
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          AppColors.textBlack,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  // Deskripsi singkat
                                                  Text(
                                                    item.description,
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 12,
                                                      color: AppColors.textGrey,
                                                    ),
                                                    textAlign:
                                                        TextAlign.justify,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Indikator sumber
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.secondary
                                                      .withAlpha(25),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.asset(
                                                  item.source == 'WHO'
                                                      ? 'assets/images/icon/source_who.png'
                                                      : item.source ==
                                                          'KEMENKES'
                                                      ? 'assets/images/icon/source_kemenkes.png'
                                                      : 'assets/images/icon/source_pengguna.png',
                                                  width: 16,
                                                  height: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 32),
                                              // Indikator favorit
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 3,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    item.isFavorite
                                                        ? Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            Icon(
                                                              Icons.favorite,
                                                              color:
                                                                  Colors.white,
                                                              size: 12,
                                                            ),
                                                            Icon(
                                                              Icons.favorite,
                                                              color:
                                                                  AppColors
                                                                      .buff,
                                                              size: 12,
                                                            ),
                                                          ],
                                                        )
                                                        : Icon(
                                                          Icons.favorite_border,
                                                          color: Colors.white,
                                                          size: 12,
                                                        ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      item.favoritesCount
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 8,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),

                        // Indikator loading
                        if (_isLoadingMore)
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                      ],
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
              const SizedBox(height: 76),
            ],
          ),
        ),
      ),

      // Tombol kembali ke atas
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
