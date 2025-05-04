import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/controllers/baby_controller.dart';
import 'package:nutrimpasi/models/baby_food_recommendation.dart';

part 'baby_food_recommendation_event.dart';
part 'baby_food_recommendation_state.dart';

class BabyFoodRecommendationBloc
    extends Bloc<BabyFoodRecommendationEvent, BabyFoodRecommendationState> {
  final BabyController controller;

  BabyFoodRecommendationBloc({required this.controller})
    : super(BabyFoodRecommendationInitial()) {
    on<FetchBabyFoodRecommendation>(_onFetch);
  }

  Future<void> _onFetch(
    FetchBabyFoodRecommendation event,
    Emitter<BabyFoodRecommendationState> emit,
  ) async {
    emit(BabyFoodRecommendationLoading());
    try {
      final result = await controller.getBabyFoodRecommendation(
        babyId: event.babyId,
      );
      emit(BabyFoodRecommendationLoaded(foods: result));
    } catch (e) {
      emit(
        BabyFoodRecommendationError(
          'Fetch baby food recommendation gagal: ${e.toString()}',
        ),
      );
    }
  }
}
