import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/controllers/schedule_controller.dart';
import 'package:nutrimpasi/models/schedule.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ScheduleController controller;

  ScheduleBloc({required this.controller}) : super(ScheduleInitial()) {
    on<FetchSchedules>(_onFetch);
    on<StoreSchedules>(_onStore);
    on<DeleteSchedules>(_onDelete);
  }

  Future<void> _onFetch(
    FetchSchedules event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());
    try {
      final result = await controller.getSchedule();
      emit(ScheduleLoaded(schedules: result));
    } catch (e) {
      emit(ScheduleError('Fetch Schedule gagal: ${e.toString()}'));
    }
  }

  Future<void> _onStore(
    StoreSchedules event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());
    try {
      await controller.storeSchedule(
        foodId: event.foodId,
        babyId: event.babyId,
        date: event.date,
      );

      emit(ScheduleStored());
    } catch (e) {
      emit(ScheduleError('Store Schedule gagal: ${e.toString()}'));
    }
  }

  Future<void> _onDelete(
    DeleteSchedules event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());
    try {
      await controller.deleteSchedule(scheduleId: event.scheduleId);

      emit(ScheduleDeleted());
    } catch (e) {
      emit(ScheduleError('Delete Schedule gagal: ${e.toString()}'));
    }
  }
}
