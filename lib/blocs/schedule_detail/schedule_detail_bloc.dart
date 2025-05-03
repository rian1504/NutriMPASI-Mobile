import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/controllers/schedule_controller.dart';
import 'package:nutrimpasi/models/schedule.dart';

part 'schedule_detail_event.dart';
part 'schedule_detail_state.dart';

class ScheduleDetailBloc
    extends Bloc<ScheduleDetailEvent, ScheduleDetailState> {
  final ScheduleController controller;

  ScheduleDetailBloc({required this.controller})
    : super(ScheduleDetailInitial()) {
    on<EditSchedules>(_onEdit);
    on<UpdateSchedule>(_onUpdate);
  }

  Future<void> _onEdit(
    EditSchedules event,
    Emitter<ScheduleDetailState> emit,
  ) async {
    emit(ScheduleDetailLoading());
    try {
      final result = await controller.editSchedule(
        scheduleId: event.scheduleId,
      );
      emit(ScheduleDetailLoaded(schedule: result));
    } catch (e) {
      emit(ScheduleDetailError('Edit Schedule gagal: ${e.toString()}'));
    }
  }

  Future<void> _onUpdate(
    UpdateSchedule event,
    Emitter<ScheduleDetailState> emit,
  ) async {
    emit(ScheduleDetailLoading());
    try {
      await controller.updateSchedule(
        scheduleId: event.scheduleId,
        babyId: event.babyId,
        date: event.date,
      );
      emit(ScheduleUpdated());
    } catch (e) {
      emit(ScheduleDetailError('Update Schedule gagal: ${e.toString()}'));
    }
  }
}
