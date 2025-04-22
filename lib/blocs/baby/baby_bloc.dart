import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/controllers/baby_controller.dart';
import 'package:nutrimpasi/models/baby.dart';

part 'baby_event.dart';
part 'baby_state.dart';

class BabyBloc extends Bloc<BabyEvent, BabyState> {
  final BabyController controller;

  BabyBloc({required this.controller}) : super(BabyInitial()) {
    on<FetchBabies>(_onFetch);
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
}
