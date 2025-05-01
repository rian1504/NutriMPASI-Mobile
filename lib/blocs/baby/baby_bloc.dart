import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/controllers/baby_controller.dart';
import 'package:nutrimpasi/models/baby.dart';
import 'package:nutrimpasi/models/baby_food_recommendation.dart';

part 'baby_event.dart';
part 'baby_state.dart';

class BabyBloc extends Bloc<BabyEvent, BabyState> {
  final BabyController controller;

  BabyBloc({required this.controller}) : super(BabyInitial()) {
    on<ResetBaby>(_onReset);
    on<FetchBabies>(_onFetch);
    on<FetchBabyFoodRecommendation>(_onFetchFoodRecommendation);
  }

  Future<void> _onReset(ResetBaby event, Emitter<BabyState> emit) async {
    emit(BabyInitial());
  }

  Future<void> _onFetch(FetchBabies event, Emitter<BabyState> emit) async {
    emit(BabyLoading());
    try {
      final result = await controller.getBaby();
      emit(BabyLoaded(babies: result));
    } catch (e) {
      emit(BabyError('Fetch Baby gagal: ${e.toString()}'));
    }
  }

  Future<void> _onFetchFoodRecommendation(
    FetchBabyFoodRecommendation event,
    Emitter<BabyState> emit,
  ) async {
    emit(BabyFoodRecommendationLoading());
    try {
      final result = await controller.getBabyFoodRecommendation(
        babyId: event.babyId,
      );
      emit(BabyFoodRecommendationLoaded(babyFoodRecommendation: result));
    } catch (e) {
      emit(BabyError('Fetch Baby gagal: ${e.toString()}'));
    }
  }
}
