import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

enum NotificationType { comment, like, announcement }

class NotificationModel {
  final String id;
  final String message;
  final DateTime time;
  final NotificationType type;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
  });

  IconData get icon {
    switch (type) {
      case NotificationType.comment:
        return Symbols.chat_bubble;
      case NotificationType.like:
        return Symbols.favorite;
      case NotificationType.announcement:
        return Symbols.book;
    }
  }

  String get timeFormatted {
    // Format time to be displayed in the notification
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }

  // Helper method to get notification category label
  String get categoryLabel {
    switch (type) {
      case NotificationType.comment:
        return 'Komentar';
      case NotificationType.like:
        return 'Postingan';
      case NotificationType.announcement:
        return 'Ulasan';
    }
  }

  // Dummy notifications for testing
  static List<NotificationModel> get dummyNotifications {
    return [
      NotificationModel(
        id: '1',
        message: 'Umi Pipik telah mengomentari postinganmu.',
        time: DateTime.now().subtract(const Duration(minutes: 30)),
        type: NotificationType.comment,
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        message: 'Umi Pipik menyukai postinganmu di forum.',
        time: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.like,
        isRead: false,
      ),
      NotificationModel(
        id: '3',
        message: 'Usulan Makananmu berhasil ditambahkan!',
        time: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.announcement,
        isRead: false,
      ),
    ];
  }
}
