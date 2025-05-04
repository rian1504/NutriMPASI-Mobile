import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/controllers/nutritionist_controller.dart';
import 'package:nutrimpasi/models/nutritionist.dart';

part 'nutritionist_event.dart';
part 'nutritionist_state.dart';

class NutritionistBloc extends Bloc<NutritionistEvent, NutritionistState> {
  final NutritionistController controller;

  NutritionistBloc({required this.controller}) : super(NutritionistInitial()) {
    on<FetchNutritionists>(_onFetch);
  }

  Future<void> _onFetch(
    FetchNutritionists event,
    Emitter<NutritionistState> emit,
  ) async {
    emit(NutritionistLoading());
    try {
      final result = await controller.getNutritionist();
      emit(NutritionistLoaded(nutritionists: result));
    } catch (e) {
      emit(NutritionistError('Fetch Nutritionist gagal: ${e.toString()}'));
    }
  }
}
