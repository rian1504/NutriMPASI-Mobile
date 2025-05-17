part of 'notification_bloc.dart';

@immutable
sealed class NotificationEvent {}

class FetchNotifications extends NotificationEvent {}

class ReadNotification extends NotificationEvent {
  final int notificationId;

  ReadNotification({required this.notificationId});
}

class ReadAllNotifications extends NotificationEvent {}
