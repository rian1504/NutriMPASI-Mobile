import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:nutrimpasi/blocs/authentication/authentication_bloc.dart';
import 'package:nutrimpasi/blocs/food/food_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/screens/food/food_detail_screen.dart';
import 'package:nutrimpasi/models/food.dart';
import 'package:nutrimpasi/screens/food/food_add_suggestion_screen.dart';
import 'package:nutrimpasi/screens/food/food_suggestion_detail_screen.dart';
import 'package:nutrimpasi/screens/setting/favorite_recipes_screen.dart';
import 'package:nutrimpasi/utils/flushbar.dart';
import 'package:nutrimpasi/utils/navigation_animation.dart';
import 'package:nutrimpasi/widgets/custom_button.dart';
import 'package:nutrimpasi/widgets/custom_message_dialog.dart';

class FoodListScreen extends StatefulWidget {
  final bool showUserSuggestions;

  const FoodListScreen({super.key, this.showUserSuggestions = false});

  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen>
    with SingleTickerProviderStateMixin {
  // Controller untuk pencarian
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  // Controller untuk scroll
  final ScrollController _scrollController = ScrollController();
  // Status tombol scroll ke atas
  bool _showScrollToTop = false;
  // Status search bar pada AppBar
  bool _showSearchInAppBar = false;
  // Toggle tampilan usulan pengguna
  bool _showUserSuggestionsOnly = false;
  // Variabel untuk lazy loading
  int _displayedItemCount = 5;
  bool _isLoadingMore = false;
  // Kueri pencarian yang aktif
  String _activeSearchQuery = '';
  // Status pencarian otomatis
  bool _isSearching = false;
  // Daftar saran pencarian
  List<String> _searchSuggestions = [];

  // Opsi pengurutan makanan
  String _sortOption = 'Terpopuler';
  final List<String> _sortOptions = ['Terpopuler', 'Terbaru', 'Terlama'];

  // Animasi untuk transisi AppBar
  late AnimationController _animationController;
  late Animation<double> _appBarAnimation;

  // Data filter
  Map<String, bool> _foodAgeFilters = {
    'Tekstur Halus': false,
    'Tekstur Kasar': false,
    'Finger Food': false,
  };
  late Map<String, bool> _foodCategoryFilters;
  Map<String, bool> _recipeSourceFilters = {
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
    _searchFocusNode.addListener(_onSearchFocusChange);

    // Inisialisasi filter makanan kategori
    _foodCategoryFilters = {};

    // Menetapkan toggle sesuai parameter
    _showUserSuggestionsOnly = widget.showUserSuggestions;

    // Inisialisasi controller animasi
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Animasi untuk transisi AppBar
    _appBarAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // if (foodState is! FoodLoaded) {
    //   context.read<FoodBloc>().add(FetchFoods());
    // }

    if (!_initialLoadCompleted) {
      context.read<FoodBloc>().add(FetchFoods());
      context.read<FoodBloc>().add(FetchCategories());
      _initialLoadCompleted = true;
    }
  }

  // Menangani perubahan fokus pada search bar
  void _onSearchFocusChange() {
    setState(() {
      _isSearching = _searchFocusNode.hasFocus;
      if (!_isSearching) {
        // Ketika fokus hilang, tutup saran
        _searchSuggestions = [];
      } else {
        // Perbarui saran ketika fokus didapat
        _updateSearchSuggestions();
      }
    });
  }

  // Memperbarui daftar saran berdasarkan input
  void _updateSearchSuggestions() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchSuggestions = [];
      });
      return;
    }

    // Dapatkan semua nama makanan dari data
    final allFoodNames = _foodItems.map((food) => food.name).toList();

    // Filter berdasarkan input
    final query = _searchController.text.toLowerCase();
    final filteredSuggestions =
        allFoodNames
            .where((name) => name.toLowerCase().contains(query))
            .toList();

    // Batasi jumlah saran yang ditampilkan
    final limitedSuggestions = filteredSuggestions.take(5).toList();

    setState(() {
      _searchSuggestions = limitedSuggestions;
    });
  }

  // Mendeteksi posisi scroll
  void _scrollListener() {
    // Untuk deteksi tombol scroll ke atas
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
        // Hilangkan fokus saat transisi ke AppBar
        _searchFocusNode.unfocus();
      });
      _animationController.forward();
    } else if (_scrollController.offset < 120 && _showSearchInAppBar) {
      setState(() {
        _showSearchInAppBar = false;
        // Hilangkan fokus saat transisi ke body
        _searchFocusNode.unfocus();
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

  // Memuat lebih banyak item
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

  // Memfilter makanan berdasarkan kriteria
  List<Food> _getFilteredFoodItems() {
    final authState = context.read<AuthenticationBloc>().state;

    int? userId;
    if (authState is LoginSuccess) {
      userId = authState.user.id;
    }

    // Filter berdasarkan usulan pengguna
    List<Food> filteredItems = _foodItems;
    if (_showUserSuggestionsOnly && userId != null) {
      filteredItems =
          filteredItems.where((item) => item.userId == userId).toList();
    }

    // Terapkan pencarian jika ada
    if (_activeSearchQuery.isNotEmpty) {
      final query = _activeSearchQuery.toLowerCase();
      filteredItems =
          filteredItems
              .where(
                (food) =>
                    food.name.toLowerCase().contains(query) ||
                    food.description.toLowerCase().contains(query),
              )
              .toList();
    }

    // Terapkan filter kategori
    bool hasCategoryFilter = _foodCategoryFilters.values.any(
      (isSelected) => isSelected,
    );
    if (hasCategoryFilter) {
      // Dapatkan ID dari kategori yang dipilih
      final Map<int, String> categoryIdToNameMap = {};
      final state = context.read<FoodBloc>().state;
      if (state is FoodLoaded) {
        for (var category in state.categories) {
          categoryIdToNameMap[category.id] = category.name;
        }
      }

      // Petakan nama yang dipilih ke ID
      final Set<int> selectedCategoryIds = {};
      _foodCategoryFilters.forEach((name, isSelected) {
        if (isSelected) {
          // Cari ID untuk nama kategori ini
          categoryIdToNameMap.forEach((id, catName) {
            if (catName == name) {
              selectedCategoryIds.add(id);
            }
          });
        }
      });

      // Filter berdasarkan ID Kategori yang dipilih
      filteredItems =
          filteredItems.where((food) {
            return food.foodCategoryId != null &&
                selectedCategoryIds.contains(food.foodCategoryId);
          }).toList();
    }

    // Terapkan filter usia
    bool hasAgeFilter = _foodAgeFilters.values.any((isSelected) => isSelected);
    if (hasAgeFilter) {
      filteredItems =
          filteredItems.where((food) {
            if (food.age == null) return false;

            // Periksa apakah makanan memiliki rentang usia yang sesuai
            String? ageRange = food.age;

            if (_foodAgeFilters['Tekstur Halus']! &&
                (ageRange == '6-8' || ageRange?.contains('6-8') == true)) {
              return true;
            }

            if (_foodAgeFilters['Tekstur Kasar']! &&
                (ageRange == '9-11' || ageRange?.contains('9-11') == true)) {
              return true;
            }

            if (_foodAgeFilters['Finger Food']! &&
                (ageRange == '12-23' || ageRange?.contains('12-23') == true)) {
              return true;
            }

            return false;
          }).toList();
    }

    // Terapkan filter sumber
    bool hasSourceFilter = _recipeSourceFilters.values.any(
      (isSelected) => isSelected,
    );
    if (hasSourceFilter) {
      filteredItems =
          filteredItems.where((food) {
            if (_recipeSourceFilters['KEMENKES']! &&
                food.source == 'KEMENKES') {
              return true;
            }

            if (_recipeSourceFilters['WHO']! && food.source == 'WHO') {
              return true;
            }

            if (_recipeSourceFilters['Rekomendasi Pengguna']! &&
                food.source == null) {
              return true;
            }

            return false;
          }).toList();
    }

    // Terapkan pengurutan
    filteredItems = _sortFoodItems(filteredItems);

    return filteredItems;
  }

  // Mengurutkan makanan berdasarkan opsi yang dipilih
  List<Food> _sortFoodItems(List<Food> items) {
    // Untuk tab "Usulan Saya", selalu urutkan dari yang terbaru
    if (_showUserSuggestionsOnly) {
      return items..sort((a, b) {
        if (a.createdAt == null && b.createdAt == null) return 0;
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;

        return b.createdAt!.compareTo(a.createdAt!);
      });
    }

    // Untuk tab "Semua", urutkan berdasarkan pilihan pengguna
    switch (_sortOption) {
      case 'Terpopuler':
        return items
          ..sort((a, b) => b.favoritesCount.compareTo(a.favoritesCount));
      case 'Terbaru':
        return items..sort((a, b) {
          if (a.createdAt == null && b.createdAt == null) return 0;
          if (a.createdAt == null) return 1;
          if (b.createdAt == null) return -1;

          return b.createdAt!.compareTo(a.createdAt!);
        });
      case 'Terlama':
        return items..sort((a, b) {
          if (a.createdAt == null && b.createdAt == null) return 0;
          if (a.createdAt == null) return 1;
          if (b.createdAt == null) return -1;

          return a.createdAt!.compareTo(b.createdAt!);
        });
      default:
        return items;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Dialog bottom sheet filter
  void _showFilterBottomSheet(BuildContext context) {
    // Pastikan filter sudah terisi sebelum menampilkan sheet
    if (_foodCategoryFilters.isEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        },
      );
      return;
    }

    // Membuat salinan filter untuk penggunaan sementara
    Map<String, bool> tempFoodCategoryFilters = Map.from(_foodCategoryFilters);
    Map<String, bool> tempFoodAgeFilters = Map.from(_foodAgeFilters);
    Map<String, bool> tempRecipeSourceFilters = Map.from(_recipeSourceFilters);

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
                              // Gunakan variabel state tempFoodCategoryFilters
                              children:
                                  tempFoodCategoryFilters.keys.map((category) {
                                    return FilterChip(
                                      label: Text(category),
                                      selected:
                                          tempFoodCategoryFilters[category]!,
                                      selectedColor: AppColors.primary
                                          .withAlpha(50),
                                      checkmarkColor: AppColors.primary,
                                      backgroundColor: AppColors.cream
                                          .withAlpha(50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                          color:
                                              tempFoodCategoryFilters[category]!
                                                  ? AppColors.primary
                                                  : AppColors.componentGrey!,
                                        ),
                                      ),
                                      onSelected: (selected) {
                                        setState(() {
                                          tempFoodCategoryFilters[category] =
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
                                  tempFoodAgeFilters.keys.map((age) {
                                    return FilterChip(
                                      label: Text(age),
                                      selected: tempFoodAgeFilters[age]!,
                                      selectedColor: AppColors.primary
                                          .withAlpha(50),
                                      checkmarkColor: AppColors.primary,
                                      backgroundColor: AppColors.cream
                                          .withAlpha(50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                          color:
                                              tempFoodAgeFilters[age]!
                                                  ? AppColors.primary
                                                  : AppColors.componentGrey!,
                                        ),
                                      ),
                                      onSelected: (selected) {
                                        setState(() {
                                          tempFoodAgeFilters[age] = selected;
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
                                  tempRecipeSourceFilters.keys.map((source) {
                                    return FilterChip(
                                      label: Text(source),
                                      selected:
                                          tempRecipeSourceFilters[source]!,
                                      selectedColor: AppColors.primary
                                          .withAlpha(50),
                                      checkmarkColor: AppColors.primary,
                                      backgroundColor: AppColors.cream
                                          .withAlpha(50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                          color:
                                              tempRecipeSourceFilters[source]!
                                                  ? AppColors.primary
                                                  : AppColors.componentGrey!,
                                        ),
                                      ),
                                      onSelected: (selected) {
                                        setState(() {
                                          tempRecipeSourceFilters[source] =
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
                          // Terapkan filter yang dipilih
                          this.setState(() {
                            _foodCategoryFilters = Map.from(
                              tempFoodCategoryFilters,
                            );
                            _foodAgeFilters = Map.from(tempFoodAgeFilters);
                            _recipeSourceFilters = Map.from(
                              tempRecipeSourceFilters,
                            );

                            // Mengatur ulang tampilan item yang ditampilkan
                            _displayedItemCount = 5;

                            // Tampilkan flushbar dengan jumlah filter yang diterapkan
                            int totalFilters =
                                (_foodCategoryFilters.values
                                    .where((v) => v)
                                    .length) +
                                (_foodAgeFilters.values
                                    .where((v) => v)
                                    .length) +
                                (_recipeSourceFilters.values
                                    .where((v) => v)
                                    .length);

                            if (totalFilters > 0) {
                              AppFlushbar.showNormal(
                                context,
                                message: '$totalFilters filter diterapkan',
                                marginVerticalValue: 16,
                              );
                            }
                          });
                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pop(context);
                          });
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

  // Fungsi untuk memastikan searchbar kembali ke body
  void _forceSearchBarToBody() {
    setState(() {
      _showSearchInAppBar = false;
      _animationController.reverse();
    });

    // Paksa scroll untuk memastikan posisi diperbarui
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Widget pencarian
  Widget _buildSearchBar({bool inAppBar = false}) {
    return RawAutocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }

        // Dapatkan nama makanan dari data yang tersedia
        final allFoodNames = _foodItems.map((food) => food.name).toList();

        // Filter berdasarkan input
        return allFoodNames
            .where((option) {
              return option.toLowerCase().contains(
                textEditingValue.text.toLowerCase(),
              );
            })
            .take(5);
      },
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController textEditingController,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted,
      ) {
        // Pertahankan nilai controller saat berpindah posisi
        if (_searchController.text != textEditingController.text) {
          textEditingController.text = _searchController.text;
          textEditingController.selection = TextSelection.fromPosition(
            TextPosition(offset: textEditingController.text.length),
          );
        }

        return Container(
          margin: EdgeInsets.all(1),
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(50),
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: textEditingController,
            focusNode: focusNode,
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
            onChanged: (value) {
              // Perbarui nilai controller utama
              _searchController.text = value;
            },
            onSubmitted: (value) {
              // Terapkan pencarian saat disubmit
              setState(() {
                _activeSearchQuery = value.trim();
                _displayedItemCount = 5;
              });
              focusNode.unfocus();

              // Jika kueri pencarian kosong dan search bar di AppBar, pindahkan ke body
              if (value.trim().isEmpty && inAppBar) {
                _forceSearchBarToBody();
              }
            },
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Cari Resep...',
              hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
              prefixIcon: InkWell(
                onTap: () {
                  setState(() {
                    _activeSearchQuery = textEditingController.text.trim();
                    _displayedItemCount = 5;
                  });
                  focusNode.unfocus();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Icon(
                    Icons.search,
                    color: AppColors.textBlack,
                    size: 22,
                  ),
                ),
              ),
              // Tombol filter pencarian
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (textEditingController.text.isNotEmpty)
                    InkWell(
                      onTap: () {
                        textEditingController.clear();
                        _searchController.clear();
                        setState(() {
                          _activeSearchQuery = '';
                          _displayedItemCount = 5;
                        });

                        // Ketika menghapus teks pencarian di AppBar, paksa pindahkan ke body
                        if (inAppBar) {
                          _forceSearchBarToBody();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(
                          Icons.clear,
                          size: 22,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 6.0,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.all(6.0),
                        minimumSize: const Size(36, 36),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        focusNode.unfocus();
                        _showFilterBottomSheet(context);
                      },
                      child: const Icon(
                        Icons.tune,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
          ),
        );
      },
      optionsViewBuilder: (
        BuildContext context,
        AutocompleteOnSelected<String> onSelected,
        Iterable<String> options,
      ) {
        return Align(
          alignment: inAppBar ? Alignment.topLeft : Alignment.topLeft,
          child: Material(
            elevation: 0,
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              width:
                  inAppBar
                      ? MediaQuery.of(context).size.width - 16
                      : MediaQuery.of(context).size.width - 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.componentGrey!),
              ),
              constraints: BoxConstraints(maxHeight: 200),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String option = options.elementAt(index);
                    return InkWell(
                      onTap: () {
                        onSelected(option);

                        _searchController.text = option;
                        setState(() {
                          _activeSearchQuery = option;
                          _displayedItemCount = 5;
                        });

                        // Hilangkan fokus setelah pemilihan
                        FocusScope.of(context).unfocus();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          border:
                              index < options.length - 1
                                  ? Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.withAlpha(25),
                                    ),
                                  )
                                  : null,
                        ),
                        child: Text(
                          option,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Tutup keyboard dan saran ketika tap di luar
        _searchFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AnimatedBuilder(
            animation: _appBarAnimation,
            builder: (context, child) {
              return AppBar(
                backgroundColor: AppColors.background,
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
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            alignment: Alignment.centerLeft,
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
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CircleButton(
                                onPressed:
                                    _appBarAnimation.value < 0.5
                                        ? () {
                                          pushWithSlideTransition(
                                            context,
                                            FavoriteRecipeScreen(),
                                          );
                                        }
                                        : null,
                                imagePath:
                                    'assets/images/icon/daftar_favorit.png',
                              ),
                            ),
                          ),
                        ],
              );
            },
          ),
        ),
        body: BlocListener<FoodBloc, FoodState>(
          listener: (context, state) {
            if (state is FoodLoaded && state.categories.isNotEmpty) {
              // Periksa apakah filter perlu diisi atau diperbarui
              bool needsUpdate =
                  _foodCategoryFilters.isEmpty ||
                  _foodCategoryFilters.keys.length != state.categories.length;

              if (needsUpdate) {
                setState(() {
                  // Pertahankan pilihan yang ada jika keys cocok, jika tidak default ke false
                  _foodCategoryFilters = {
                    for (var category in state.categories)
                      category.name:
                          _foodCategoryFilters[category.name] ?? false,
                  };
                });
              }
            } else if (state is FoodError) {
              AppFlushbar.showError(
                context,
                title: 'Error',
                message: 'Gagal memuat data: ${state.error}',
              );
            }
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul halaman
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 8.0,
                        bottom: 16.0,
                        left: 16.0,
                        right: 16.0,
                      ),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: AnimatedOpacity(
                        opacity: _showSearchInAppBar ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height:
                              _showSearchInAppBar
                                  ? 0
                                  : (_isSearching &&
                                          _searchSuggestions.isNotEmpty
                                      ? 48 + (_searchSuggestions.length * 44)
                                      : 48),
                          child:
                              _showSearchInAppBar
                                  ? const SizedBox()
                                  : _buildSearchBar(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Banner berdasarkan toggle dengan animasi fade
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (
                          Widget child,
                          Animation<double> animation,
                        ) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child:
                            !_showUserSuggestionsOnly
                                // Banner daftar makanan untuk "Semua"
                                ? Container(
                                  key: const ValueKey('daftar_makanan'),
                                  height: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    // border: Border.all(color: AppColors.componentGrey!),
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
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Container(
                                          width: double.infinity,
                                          height: 180,
                                          decoration: BoxDecoration(
                                            color: AppColors.componentGrey,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
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
                                    // border: Border.all(color: AppColors.componentGrey!),
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
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Container(
                                              width: double.infinity,
                                              height: 180,
                                              decoration: BoxDecoration(
                                                color: AppColors.componentGrey,
                                                borderRadius:
                                                    BorderRadius.circular(12),
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
                                        child: GestureDetector(
                                          onTap: () {
                                            pushWithSlideTransition(
                                              context,
                                              FoodAddSuggestionScreen(),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(16),
                                            // margin: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                    Radius.circular(12),
                                                  ),
                                            ),
                                            child: Row(
                                              children: [
                                                // Informasi usulan
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Text(
                                                        'Tambah Usulan',
                                                        style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              AppColors
                                                                  .textBlack,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        'Tambahkan usulan resep dari kreasi kamu!',
                                                        style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 12,
                                                          color:
                                                              AppColors
                                                                  .textGrey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Tombol tambah
                                                Container(
                                                  width: 48,
                                                  height: 48,
                                                  decoration:
                                                      const BoxDecoration(
                                                        color:
                                                            AppColors.primary,
                                                        shape: BoxShape.circle,
                                                      ),
                                                  child: const Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                    size: 36,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Toggle pilihan tampilan dengan animasi slide
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
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
                                      ? MediaQuery.of(context).size.width / 2 -
                                          24
                                      : 4,
                              right:
                                  _showUserSuggestionsOnly
                                      ? 4
                                      : MediaQuery.of(context).size.width / 2 -
                                          24,
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
                                        padding: EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
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
                                        padding: EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
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
                                      child: const SizedBox(
                                        height: double.infinity,
                                      ),
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
                                      child: const SizedBox(
                                        height: double.infinity,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Dropdown untuk pengurutan
                    if (!_showUserSuggestionsOnly)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(25),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _sortOption,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColors.textBlack,
                                ),
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textBlack,
                                ),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _sortOption = newValue;
                                      _displayedItemCount = 5;
                                    });
                                  }
                                },
                                items:
                                    _sortOptions.map<DropdownMenuItem<String>>((
                                      String value,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0,
                                          ),
                                          child: Text(value),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Add space only if dropdown is shown
                    if (!_showUserSuggestionsOnly && _foodItems.isNotEmpty)
                      const SizedBox(height: 12),

                    // Info pencarian aktif
                    if (_activeSearchQuery.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 12.0,
                          left: 16.0,
                          right: 16.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withAlpha(25),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.search,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Pencarian: $_activeSearchQuery',
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _activeSearchQuery = '';
                                          _searchController.clear();
                                          _displayedItemCount = 5;
                                        });

                                        // Jika searchbar di appbar, force pindahkan ke body
                                        if (_showSearchInAppBar) {
                                          _forceSearchBarToBody();
                                        }
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Daftar kartu makanan
                    BlocBuilder<FoodBloc, FoodState>(
                      builder: (context, state) {
                        if (state is FoodLoading && _foodItems.isEmpty) {
                          // Tampilkan loading hanya pada muatan awal
                          return const Center(
                            child: Column(
                              children: [
                                SizedBox(height: 100),
                                CircularProgressIndicator(),
                              ],
                            ),
                          );
                        }

                        // Dapatkan item yang difilter
                        final filteredItems = _getFilteredFoodItems();

                        if (filteredItems.isEmpty && state is! FoodLoading) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: EmptyMessage(
                              title:
                                  _showUserSuggestionsOnly
                                      ? 'Anda belum mengusulkan resep'
                                      : 'Belum ada resep makanan ',
                              subtitle:
                                  _activeSearchQuery.isNotEmpty
                                      ? 'Tidak ada resep yang sesuai dengan pencarian Anda'
                                      : 'Coba ubah filter atau tambahkan usulan resep baru',
                              iconName: Symbols.restaurant_menu,
                              buttonText: 'Tambah Usulan',
                              onPressed:
                                  _showUserSuggestionsOnly
                                      ? () => pushWithSlideTransition(
                                        context,
                                        FoodAddSuggestionScreen(),
                                      )
                                      : null, // Jika isMyPosts false, set onPressed ke null,
                            ),
                          );
                        }

                        return Column(
                          children: [
                            ...filteredItems.take(_displayedItemCount).map((
                              item,
                            ) {
                              if (_showUserSuggestionsOnly) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                FoodSuggestionDetailScreen(
                                                  foodId: item.id,
                                                ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    child: _buildFoodCard(item, context),
                                  ),
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => FoodDetailScreen(
                                              foodId: item.id,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    child: _buildFoodCard(item, context),
                                  ),
                                );
                              }
                            }),

                            // Indikator loading
                            if (_isLoadingMore)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 76),
                  ],
                ),
              ),

              // Overlay backdrop untuk saran ketika aktif
              if (_isSearching &&
                  _searchSuggestions.isNotEmpty &&
                  !_showSearchInAppBar)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      _searchFocusNode.unfocus();
                    },
                    child: Container(
                      color: Colors.black.withAlpha(25),
                      margin: EdgeInsets.only(
                        top: 100 + (_searchSuggestions.length * 44),
                      ),
                    ),
                  ),
                ),
            ],
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
      ),
    );
  }

  // Widget kartu makanan
  Widget _buildFoodCard(Food item, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            // Gambar makanan
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: Image.network(
                storageUrl + item.image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Nama makanan
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBlack,
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
                              textAlign: TextAlign.justify,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Indikator sumber (tidak ditampilkan dalam mode usulan saya)
                        if (!_showUserSuggestionsOnly)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withAlpha(25),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              item.source == 'WHO'
                                  ? 'assets/images/icon/source_who.png'
                                  : item.source == 'KEMENKES'
                                  ? 'assets/images/icon/source_kemenkes.png'
                                  : 'assets/images/icon/source_pengguna.png',
                              width: 16,
                              height: 16,
                            ),
                          ),
                        if (_showUserSuggestionsOnly)
                          const SizedBox(height: 24),
                        const SizedBox(height: 32),
                        // Indikator favorit
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              item.isFavorite
                                  ? Stack(
                                    alignment: Alignment.center,
                                    children: const [
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
                                  : const Icon(
                                    Icons.favorite_border,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                              const SizedBox(width: 4),
                              Text(
                                item.favoritesCount.toString(),
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
  }
}
