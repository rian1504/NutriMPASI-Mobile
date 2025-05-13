import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/controllers/food_suggestion_controller.dart';
import 'package:nutrimpasi/models/food_suggestion.dart';

part 'food_category_event.dart';
part 'food_category_state.dart';

class FoodCategoryBloc extends Bloc<FoodCategoryEvent, FoodCategoryState> {
  final FoodSuggestionController controller;

  FoodCategoryBloc({required this.controller}) : super(FoodCategoryInitial()) {
    on<FetchFoodCategories>(_onFetch);
  }

  Future<void> _onFetch(
    FetchFoodCategories event,
    Emitter<FoodCategoryState> emit,
  ) async {
    emit(FoodCategoryLoading());
    try {
      final result = await controller.getFoodCategory();
      emit(FoodCategoryLoaded(categories: result));
    } catch (e) {
      emit(FoodCategoryError('Fetch FoodCategory gagal: ${e.toString()}'));
    }
  }
}
