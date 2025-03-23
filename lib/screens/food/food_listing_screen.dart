import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/screens/food/food_detail_screen.dart';
import 'package:nutrimpasi/models/food_model.dart';

class FoodListingScreen extends StatefulWidget {
  const FoodListingScreen({super.key});

  @override
  State<FoodListingScreen> createState() => _FoodListingScreenState();
}

class _FoodListingScreenState extends State<FoodListingScreen> {
  // Controller pencarian
  final TextEditingController _searchController = TextEditingController();
  // Controller scroll untuk mendeteksi posisi scroll
  final ScrollController _scrollController = ScrollController();
  // Variable untuk menampilkan/menyembunyikan tombol scroll ke atas
  bool _showScrollToTop = false;
  // Variable untuk toggle antara semua makanan dan usulan user
  bool _showUserSuggestionsOnly = false;
  // Variable untuk lazy loading
  int _displayedItemCount = 5;
  bool _isLoadingMore = false;

  // Filter bottom sheet
  final Map<String, bool> _foodAgeFilters = {
    'Tekstur Halus': false,
    'Tekstur Kasar': false,
    'Finger Food': false,
  };
  final Map<String, bool> _foodCategoryFilters = {
    'Karbohidrat': false,
    'Bubur & Puree': false,
    'Sup & Kuah': false,
    'Finger Food': false,
  };
  final Map<String, bool> _recipeSourceFilters = {
    'KEMENKES': false,
    'WHO': false,
    'Rekomendasi User': false,
  };

  // Data makanan dari model
  final List<Food> _foodItems = Food.dummyFoods;

  @override
  void initState() {
    super.initState();
    // listener untuk mendeteksi posisi scroll
    _scrollController.addListener(_scrollListener);
  }

  // Fungsi untuk mendeteksi posisi scroll
  void _scrollListener() {
    // Jika posisi scroll lebih dari filter, tampilkan tombol scroll ke atas
    if (_scrollController.offset >= 300 && !_showScrollToTop) {
      setState(() {
        _showScrollToTop = true;
      });
    } else if (_scrollController.offset < 300 && _showScrollToTop) {
      setState(() {
        _showScrollToTop = false;
      });
    }

    // Deteksi scroll ke bawah untuk lazy loading
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _displayedItemCount < _getFilteredFoodItems().length) {
      _loadMoreItems();
    }
  }

  // Fungsi untuk memuat lebih banyak item
  void _loadMoreItems() {
    setState(() {
      _isLoadingMore = true;
    });

    // Simulasi loading dengan delay
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

  // Fungsi untuk mendapatkan item makanan yang difilter
  List<Food> _getFilteredFoodItems() {
    if (_showUserSuggestionsOnly) {
      return _foodItems.where((item) => item.source == 'Pengguna').toList();
    }
    return _foodItems;
  }

  @override
  // Fungsi dispose untuk membersihkan controller
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Menampilkan bottom sheet filter
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
                  // Indikator bottom sheet
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
                  // Area yang dapat di-scroll
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Bagian tekstur
                          const Text(
                            'Konsistensi atau tekstur',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondary,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Wrap(
                            spacing: 8,
                            runSpacing: 0,
                            children:
                                _foodAgeFilters.keys.map((age) {
                                  return FilterChip(
                                    label: Text(age),
                                    selected: _foodAgeFilters[age]!,
                                    selectedColor: AppColors.primary.withAlpha(
                                      50,
                                    ),
                                    checkmarkColor: AppColors.primary,
                                    backgroundColor: Colors.white,
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

                          const SizedBox(height: 12),

                          // Bagian kategori makanan
                          const Text(
                            'Kategori Makanan',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondary,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Wrap(
                            spacing: 8,
                            runSpacing: 0,
                            children:
                                _foodCategoryFilters.keys.map((category) {
                                  return FilterChip(
                                    label: Text(category),
                                    selected: _foodCategoryFilters[category]!,
                                    selectedColor: AppColors.primary.withAlpha(
                                      50,
                                    ),
                                    checkmarkColor: AppColors.primary,
                                    backgroundColor: Colors.white,
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

                          const SizedBox(height: 12),

                          // Bagian sumber resep
                          const Text(
                            'Sumber Resep',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondary,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Wrap(
                            spacing: 8,
                            runSpacing: 0,
                            children:
                                _recipeSourceFilters.keys.map((source) {
                                  return FilterChip(
                                    label: Text(source),
                                    selected: _recipeSourceFilters[source]!,
                                    selectedColor: AppColors.primary.withAlpha(
                                      50,
                                    ),
                                    checkmarkColor: AppColors.primary,
                                    backgroundColor: Colors.white,
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
                                        _recipeSourceFilters[source] = selected;
                                      });
                                    },
                                  );
                                }).toList(),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),

                  // Tombol terapkan filter
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/Logo.png'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Symbols.bookmark_heart, color: AppColors.primary),
            onPressed: () {
              // TODO: Navigasi ke halaman favorit
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pesan halaman
              const Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sudah kepikiran',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textGrey,
                      ),
                    ),
                    Text(
                      'Masak apa hari ini?',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Search bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.componentGrey!),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Cari Resep...',
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.secondary,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Tombol filter
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.componentGrey!),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune, color: AppColors.secondary),
                      onPressed: () {
                        // Fungsi menampilkan bottom sheet filter
                        _showFilterBottomSheet(context);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Bagian tambah usulan
              Container(
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
                    // Gambar background
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://picsum.photos/800/600',
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: double.infinity,
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.image,
                              color: Colors.grey,
                              size: 40,
                            ),
                          );
                        },
                      ),
                    ),
                    // Card konten
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(225),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Text konten
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Tambah Usulan',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tambahkan usulan resep dari kreasi kamu!',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Tombol tambah usulan
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
                                  size: 20,
                                ),
                                onPressed: () {
                                  // TODO: Navigasi ke halaman tambah usulan
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

              const SizedBox(height: 16),

              // Toggle switch untuk mengganti antara semua makanan dan usulan user
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showUserSuggestionsOnly = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color:
                                !_showUserSuggestionsOnly
                                    ? AppColors.primary
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Semua',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color:
                                  !_showUserSuggestionsOnly
                                      ? Colors.white
                                      : AppColors.textGrey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showUserSuggestionsOnly = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color:
                                _showUserSuggestionsOnly
                                    ? AppColors.primary
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Usulan User',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color:
                                  _showUserSuggestionsOnly
                                      ? Colors.white
                                      : AppColors.textGrey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Daftar makanan
              Column(
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
                                (context) => FoodDetailScreen(foodId: item.id),
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
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: Image.network(
                                  item.image,
                                  fit: BoxFit.cover,
                                ),
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
                                            // Judul makanan
                                            Text(
                                              item.name,
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.secondary,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            // Deskripsi makanan
                                            Text(
                                              item.description,
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                              textAlign: TextAlign.justify,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Sumber makanan
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: AppColors.secondary
                                                .withAlpha(25),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            item.source == 'WHO' ||
                                                    item.source == 'KEMENKES'
                                                ? Symbols.verified
                                                : Symbols.person,
                                            color: AppColors.secondary,
                                            size: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 32),
                                        // Jumlah favorite
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              item.isFavorite
                                                  ? Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.favorite,
                                                        color: Colors.white,
                                                        size: 12,
                                                      ),
                                                      Icon(
                                                        Icons.favorite,
                                                        color: AppColors.buff,
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
                                                '24',
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
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      // FloatingActionButton untuk scroll ke atas
      floatingActionButton:
          _showScrollToTop
              ? FloatingActionButton(
                backgroundColor: AppColors.primary,
                onPressed: () {
                  // Fungsi scroll ke posisi paling atas
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
