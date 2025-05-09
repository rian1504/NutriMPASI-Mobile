import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/controllers/food_recommendation_controller.dart';
import 'package:nutrimpasi/models/food_recommendation.dart';

part 'food_recommendation_event.dart';
part 'food_recommendation_state.dart';

class FoodRecommendationBloc
    extends Bloc<FoodRecommendationEvent, FoodRecommendationState> {
  final FoodRecommendationController controller;

  FoodRecommendationBloc({required this.controller})
    : super(FoodRecommendationInitial()) {
    on<FetchFoodRecommendation>(_onFetch);
    on<DeleteFoodRecommendation>(_onDelete);
  }

  Future<void> _onFetch(
    FetchFoodRecommendation event,
    Emitter<FoodRecommendationState> emit,
  ) async {
    emit(FoodRecommendationLoading());
    try {
      final result = await controller.showFood(foodId: event.foodId);
      emit(FoodRecommendationLoaded(food: result));
    } catch (e) {
      emit(
        FoodRecommendationError(
          'Gagal memuat recommendation makanan: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onDelete(
    DeleteFoodRecommendation event,
    Emitter<FoodRecommendationState> emit,
  ) async {
    emit(FoodRecommendationLoading());
    try {
      await controller.deleteFood(foodId: event.foodId);

      emit(FoodRecommendationDeleted());
    } catch (e) {
      emit(
        FoodRecommendationError(
          'Delete Food Recommendation gagal: ${e.toString()}',
        ),
      );
    }
  }
}
