import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/blocs/favorite/favorite_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/favorite.dart';
import 'package:nutrimpasi/screens/food/food_detail_screen.dart';
import 'package:nutrimpasi/widgets/custom_app_bar.dart';
import 'package:nutrimpasi/widgets/custom_button.dart';
import 'package:nutrimpasi/widgets/custom_message_dialog.dart';

class FavoriteRecipeScreen extends StatefulWidget {
  const FavoriteRecipeScreen({super.key});

  @override
  State<FavoriteRecipeScreen> createState() => _FavoriteRecipeScreenState();
}

class _FavoriteRecipeScreenState extends State<FavoriteRecipeScreen> {
  List<Favorite> favorites = [];

  @override
  void initState() {
    super.initState();
    context.read<FavoriteBloc>().add(FetchFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: 'Resep Favorit',
      appBarContent: true,
      icon: AppIcons.favoriteFill,
      content: Column(
        children: [
          const SizedBox(height: 80),

          // Daftar makanan favorite
          BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              if (state is FavoriteLoading) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                );
              }

              if (state is FavoriteLoaded) {
                favorites = state.favorites;
              }

              if (favorites.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: EmptyMessage(
                    title: 'Anda belum menyukai resep makanan',
                    subtitle:
                        'Belum ada resep yang Anda tandai sebagai favorit. Coba cari resep yang Anda suka dan tandai sebagai favorit. ',
                    iconName: AppIcons.food,
                  ),
                );
              }

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final recipe = favorites[index].food;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      FoodDetailScreen(foodId: recipe.id),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Stack(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    flex: 0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                      ),
                                      child: Image.network(
                                        storageUrl + recipe.image,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.broken_image,
                                                  size: 70,
                                                ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(8, 8, 48, 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            recipe.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            recipe.description,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                            maxLines: 3,
                                            textAlign: TextAlign.justify,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              //tombol unlike
                              Positioned(
                                top: 4,
                                right: 4,
                                child: IconButton(
                                  onPressed: () {
                                    context.read<FavoriteBloc>().add(
                                      ToggleFavorite(foodId: recipe.id),
                                    );
                                  },
                                  icon: Icon(
                                    AppIcons.favoriteFill,
                                    color: AppColors.error,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
    // return Scaffold(
    //   backgroundColor: AppColors.background,
    //   appBar: AppBar(
    //     backgroundColor: AppColors.primary,
    //     elevation: 0,
    //     leading: IconButton(
    //       icon: const Icon(Icons.arrow_back_ios_new_rounded),
    //       onPressed: () => Navigator.pop(context),
    //       style: IconButton.styleFrom(
    //         backgroundColor: Colors.white,
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(10),
    //         ),
    //         padding: const EdgeInsets.all(8),
    //       ),
    //     ),
    //     title: const Text(
    //       'Resep Favorit',
    //       style: TextStyle(
    //         fontSize: 24,
    //         fontWeight: FontWeight.bold,
    //         color: Colors.white,
    //       ),
    //     ),
    //     centerTitle: true,
    //   ),
    //   body:    );
  }
}
