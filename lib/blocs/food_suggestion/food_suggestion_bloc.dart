import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/controllers/food_suggestion_controller.dart';
import 'package:nutrimpasi/models/food_suggestion.dart';

part 'food_suggestion_event.dart';
part 'food_suggestion_state.dart';

class FoodSuggestionBloc
    extends Bloc<FoodSuggestionEvent, FoodSuggestionState> {
  final FoodSuggestionController controller;

  FoodSuggestionBloc({required this.controller})
    : super(FoodSuggestionInitial()) {
    on<FetchFoodSuggestion>(_onFetch);
    on<StoreFoodSuggestion>(_onStore);
    on<UpdateFoodSuggestion>(_onUpdate);
    on<DeleteFoodSuggestion>(_onDelete);
  }

  Future<void> _onFetch(
    FetchFoodSuggestion event,
    Emitter<FoodSuggestionState> emit,
  ) async {
    emit(FoodSuggestionLoading());
    try {
      final result = await controller.showFood(foodId: event.foodId);
      emit(FoodSuggestionLoaded(food: result));
    } catch (e) {
      emit(
        FoodSuggestionError('Gagal memuat suggestion makanan: ${e.toString()}'),
      );
    }
  }

  Future<void> _onStore(
    StoreFoodSuggestion event,
    Emitter<FoodSuggestionState> emit,
  ) async {
    emit(FoodSuggestionLoading());
    try {
      await controller.storeFood(
        foodCategoryId: event.foodCategoryId,
        name: event.name,
        image: event.image,
        age: event.age,
        energy: event.energy,
        protein: event.protein,
        fat: event.fat,
        portion: event.portion,
        recipe: event.recipe,
        fruit: event.fruit,
        step: event.step,
        description: event.description,
      );
      emit(FoodSuggestionStored());
    } catch (e) {
      emit(FoodSuggestionError('Store Food Suggestion gagal: ${e.toString()}'));
    }
  }

  Future<void> _onUpdate(
    UpdateFoodSuggestion event,
    Emitter<FoodSuggestionState> emit,
  ) async {
    emit(FoodSuggestionLoading());
    try {
      await controller.updateFood(
        foodId: event.foodId,
        foodCategoryId: event.foodCategoryId,
        name: event.name,
        image: event.image,
        age: event.age,
        energy: event.energy,
        protein: event.protein,
        fat: event.fat,
        portion: event.portion,
        recipe: event.recipe,
        fruit: event.fruit,
        step: event.step,
        description: event.description,
      );
      emit(FoodSuggestionUpdated());
    } catch (e) {
      emit(
        FoodSuggestionError('Update Food Suggestion gagal: ${e.toString()}'),
      );
    }
  }

  Future<void> _onDelete(
    DeleteFoodSuggestion event,
    Emitter<FoodSuggestionState> emit,
  ) async {
    emit(FoodSuggestionLoading());
    try {
      await controller.deleteFood(foodId: event.foodId);

      emit(FoodSuggestionDeleted());
    } catch (e) {
      emit(
        FoodSuggestionError('Delete Food suggestion gagal: ${e.toString()}'),
      );
    }
  }
}
