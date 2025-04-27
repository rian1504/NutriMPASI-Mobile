part of 'schedule_bloc.dart';

@immutable
sealed class ScheduleEvent {}

class FetchSchedules extends ScheduleEvent {}
