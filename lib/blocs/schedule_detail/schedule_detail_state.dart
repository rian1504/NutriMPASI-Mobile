part of 'schedule_detail_bloc.dart';

@immutable
sealed class ScheduleDetailState {}

final class ScheduleDetailInitial extends ScheduleDetailState {}

final class ScheduleDetailLoading extends ScheduleDetailState {}

final class ScheduleUpdated extends ScheduleDetailState {}

final class ScheduleDetailLoaded extends ScheduleDetailState {
  final Schedule schedule;

  ScheduleDetailLoaded({required this.schedule});
}

class ScheduleDetailError extends ScheduleDetailState {
  final String error;
  ScheduleDetailError(this.error);
}
