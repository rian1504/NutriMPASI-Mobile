import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/controllers/favorite_controller.dart';
import 'package:nutrimpasi/controllers/food_controller.dart';
import 'package:nutrimpasi/models/food.dart';

part 'food_detail_event.dart';
part 'food_detail_state.dart';

class FoodDetailBloc extends Bloc<FoodDetailEvent, FoodDetailState> {
  final FoodController controller;
  final FavoriteController favoriteController;

  FoodDetailBloc({required this.controller, required this.favoriteController})
    : super(FoodDetailInitial()) {
    on<FetchFoodDetail>(_onFetch);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onFetch(
    FetchFoodDetail event,
    Emitter<FoodDetailState> emit,
  ) async {
    emit(FoodDetailLoading());
    try {
      final result = await controller.showFood(foodId: event.foodId);
      emit(FoodDetailLoaded(food: result));
    } catch (e) {
      emit(FoodDetailError('Gagal memuat detail makanan: ${e.toString()}'));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FoodDetailState> emit,
  ) async {
    if (state is! FoodDetailLoaded) return;

    final currentState = state as FoodDetailLoaded;
    final currentFood = currentState.food;

    try {
      // Optimistic update
      emit(
        FoodDetailLoaded(
          food: currentFood.copyWith(
            isFavorite: !currentFood.isFavorite,
            favoritesCount:
                currentFood.isFavorite
                    ? currentFood.favoritesCount - 1
                    : currentFood.favoritesCount + 1,
          ),
        ),
      );

      // API call
      await favoriteController.toggleFavorite(foodId: event.foodId);
    } catch (e) {
      // Rollback jika error
      emit(FoodDetailLoaded(food: currentFood));
    }
  }
}
