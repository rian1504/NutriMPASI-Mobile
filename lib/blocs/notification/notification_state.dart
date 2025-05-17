part of 'notification_bloc.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class NotificationLoading extends NotificationState {}

final class NotificationLoaded extends NotificationState {
  final List<model.Notification> notifications;

  NotificationLoaded({required this.notifications});
}

final class NotificationError extends NotificationState {
  final String error;
  NotificationError(this.error);
}
