import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/controllers/food_controller.dart';
import 'package:nutrimpasi/models/food.dart';

part 'food_detail_event.dart';
part 'food_detail_state.dart';

class FoodDetailBloc extends Bloc<FoodDetailEvent, FoodDetailState> {
  final FoodController controller;

  FoodDetailBloc({required this.controller}) : super(FoodDetailInitial()) {
    on<FetchFoodDetail>(_onFetch);
  }

  Future<void> _onFetch(
    FetchFoodDetail event,
    Emitter<FoodDetailState> emit,
  ) async {
    emit(FoodDetailLoading());
    try {
      final result = await controller.showFood(id: event.foodId);
      emit(FoodDetailLoaded(food: result));
    } catch (e) {
      emit(FoodDetailError('Gagal memuat detail makanan: ${e.toString()}'));
    }
  }
}
