part of 'schedule_detail_bloc.dart';

@immutable
sealed class ScheduleDetailEvent {}

class EditSchedules extends ScheduleDetailEvent {
  final int scheduleId;

  EditSchedules({required this.scheduleId});
}

class UpdateSchedule extends ScheduleDetailEvent {
  final int scheduleId;
  final List<String> babyId;
  final DateTime date;

  UpdateSchedule({
    required this.scheduleId,
    required this.babyId,
    required this.date,
  });
}
