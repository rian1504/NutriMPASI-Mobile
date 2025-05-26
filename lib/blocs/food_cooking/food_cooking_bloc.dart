import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/controllers/food_controller.dart';
import 'package:nutrimpasi/models/food_cooking.dart';

part 'food_cooking_event.dart';
part 'food_cooking_state.dart';

class FoodCookingBloc extends Bloc<FoodCookingEvent, FoodCookingState> {
  final FoodController controller;

  FoodCookingBloc({required this.controller}) : super(FoodCookingInitial()) {
    on<FetchFoodCooking>(_onFetch);
    on<CompleteFoodCooking>(_onComplete);
  }

  Future<void> _onFetch(
    FetchFoodCooking event,
    Emitter<FoodCookingState> emit,
  ) async {
    emit(FoodCookingLoading());
    try {
      final result = await controller.showCookingGuide(
        foodId: event.foodId,
        babyId: event.babyId,
      );
      emit(FoodCookingLoaded(foodCooking: result));
    } catch (e) {
      emit(FoodCookingError('Gagal memuat Cooking makanan: ${e.toString()}'));
    }
  }

  Future<void> _onComplete(
    CompleteFoodCooking event,
    Emitter<FoodCookingState> emit,
  ) async {
    emit(FoodCookingCompleteLoading());
    try {
      await controller.completeCookingGuide(
        foodId: event.foodId,
        babyId: event.babyId,
        scheduleId: event.scheduleId,
      );

      emit(FoodCookingComplete());
    } catch (e) {
      emit(FoodCookingError('Gagal complete Cooking makanan: ${e.toString()}'));
    }
  }
}
