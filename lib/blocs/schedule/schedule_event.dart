part of 'schedule_bloc.dart';

@immutable
sealed class ScheduleEvent {}

class FetchSchedules extends ScheduleEvent {}

class StoreSchedules extends ScheduleEvent {
  final String foodId;
  final List<String> babyId;
  final DateTime date;

  StoreSchedules({
    required this.foodId,
    required this.babyId,
    required this.date,
  });
}

class UpdateSchedules extends ScheduleEvent {
  final int scheduleId;
  final List<String> babyId;
  final DateTime date;

  UpdateSchedules({
    required this.scheduleId,
    required this.babyId,
    required this.date,
  });
}

class DeleteSchedules extends ScheduleEvent {
  final int scheduleId;

  DeleteSchedules({required this.scheduleId});
}
