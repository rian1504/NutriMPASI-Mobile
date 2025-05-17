import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/controllers/notification_controller.dart';
import 'package:nutrimpasi/models/notification.dart' as model;

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationController controller;

  NotificationBloc({required this.controller}) : super(NotificationInitial()) {
    on<FetchNotifications>(_onFetch);
    on<ReadNotification>(_onRead);
    on<ReadAllNotifications>(_onReadAll);
  }

  Future<void> _onFetch(
    FetchNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    try {
      final result = await controller.getNotification();
      emit(NotificationLoaded(notifications: result));
    } catch (e) {
      emit(NotificationError('Fetch Notification gagal: ${e.toString()}'));
    }
  }

  Future<void> _onRead(
    ReadNotification event,
    Emitter<NotificationState> emit,
  ) async {
    if (state is NotificationLoaded) {
      try {
        await controller.readNotification(notificationId: event.notificationId);
        final updatedNotifications = await controller.getNotification();
        emit(NotificationLoaded(notifications: updatedNotifications));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    }
  }

  Future<void> _onReadAll(
    ReadAllNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    if (state is NotificationLoaded) {
      try {
        await controller.readAllNotification();
        final updatedNotifications = await controller.getNotification();
        emit(NotificationLoaded(notifications: updatedNotifications));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    }
  }
}
