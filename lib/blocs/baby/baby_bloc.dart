import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/controllers/baby_controller.dart';
import 'package:nutrimpasi/models/baby.dart';

part 'baby_event.dart';
part 'baby_state.dart';

class BabyBloc extends Bloc<BabyEvent, BabyState> {
  final BabyController controller;

  BabyBloc({required this.controller}) : super(BabyInitial()) {
    on<ResetBaby>(_onReset);
    on<FetchBabies>(_onFetch);
    on<StoreBabies>(_onStore);
    on<UpdateBabies>(_onUpdate);
    on<DeleteBabies>(_onDelete);
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

  Future<void> _onStore(StoreBabies event, Emitter<BabyState> emit) async {
    emit(BabyLoading());
    try {
      await controller.storeBaby(
        name: event.name,
        dob: event.dob,
        gender: event.gender,
        weight: event.weight,
        height: event.height,
        condition: event.condition,
      );
      emit(BabyStored());
    } catch (e) {
      emit(BabyError('Store Baby gagal: ${e.toString()}'));
    }
  }

  Future<void> _onUpdate(UpdateBabies event, Emitter<BabyState> emit) async {
    emit(BabyLoading());
    try {
      await controller.updateBaby(
        babyId: event.babyId,
        name: event.name,
        dob: event.dob,
        gender: event.gender,
        weight: event.weight,
        height: event.height,
        condition: event.condition,
      );
      emit(BabyUpdated());
    } catch (e) {
      emit(BabyError('Update Baby gagal: ${e.toString()}'));
    }
  }

  Future<void> _onDelete(DeleteBabies event, Emitter<BabyState> emit) async {
    emit(BabyLoading());
    try {
      await controller.deleteBaby(babyId: event.babyId);
      emit(BabyDeleted());
    } catch (e) {
      emit(BabyError('Delete Baby gagal: ${e.toString()}'));
    }
  }
}
