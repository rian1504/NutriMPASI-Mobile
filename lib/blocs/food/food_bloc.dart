import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/controllers/food_controller.dart';
import 'package:nutrimpasi/models/food.dart';

part 'food_event.dart';
part 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final FoodController controller;
  List<FoodCategory> _categories = [];

  FoodBloc({required this.controller}) : super(FoodInitial()) {
    on<FetchFoods>(_onFetch);
    on<FilterFoods>(_onFilter);
    on<FetchCategories>(_onFetchCategories);
  }

  List<FoodCategory> get categories => _categories;

  Future<void> _onFetch(FetchFoods event, Emitter<FoodState> emit) async {
    emit(FoodLoading());
    try {
      final result = await controller.getFood();
      emit(FoodLoaded(foods: result, categories: _categories));
    } catch (e) {
      emit(FoodError('Fetch Food gagal: ${e.toString()}'));
    }
  }

  Future<void> _onFilter(FilterFoods event, Emitter<FoodState> emit) async {
    emit(FoodLoading());
    try {
      final result = await controller.filterFood(
        search: event.search,
        foodCategoryId: event.foodCategoryId,
        source: event.source,
        age: event.age,
      );
      emit(FoodLoaded(foods: result, categories: _categories));
    } catch (e) {
      emit(FoodError('Filter Food gagal: ${e.toString()}'));
    }
  }

  Future<void> _onFetchCategories(
    FetchCategories event,
    Emitter<FoodState> emit,
  ) async {
    try {
      _categories = await controller.getFoodCategory();
      if (state is FoodLoaded) {
        emit(
          FoodLoaded(
            foods: (state as FoodLoaded).foods,
            categories: _categories,
          ),
        );
      }
    } catch (e) {
      debugPrint('Gagal memuat kategori: $e');
    }
  }
}
