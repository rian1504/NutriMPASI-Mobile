import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/controllers/food_record_controller.dart';
import 'package:nutrimpasi/models/food_record.dart';

part 'food_record_event.dart';
part 'food_record_state.dart';

class FoodRecordBloc extends Bloc<FoodRecordEvent, FoodRecordState> {
  final FoodRecordController controller;

  FoodRecordBloc({required this.controller}) : super(FoodRecordInitial()) {
    on<FetchFoodRecords>(_onFetch);
  }

  Future<void> _onFetch(
    FetchFoodRecords event,
    Emitter<FoodRecordState> emit,
  ) async {
    emit(FoodRecordLoading());
    try {
      final result = await controller.getFoodRecord();
      emit(FoodRecordLoaded(foodRecords: result));
    } catch (e) {
      emit(FoodRecordError('Fetch Food Record gagal: ${e.toString()}'));
    }
  }
}
