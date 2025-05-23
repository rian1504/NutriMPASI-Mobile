part of 'schedule_bloc.dart';

@immutable
sealed class ScheduleState {}

final class ScheduleInitial extends ScheduleState {}

final class ScheduleLoading extends ScheduleState {}

final class ScheduleStored extends ScheduleState {}

final class ScheduleUpdated extends ScheduleState {}

final class ScheduleDeleted extends ScheduleState {}

final class ScheduleLoaded extends ScheduleState {
  final List<Schedule> schedules;

  ScheduleLoaded({required this.schedules});
}

class ScheduleError extends ScheduleState {
  final String error;
  ScheduleError(this.error);
}
