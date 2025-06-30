import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nutrimpasi/main.dart';
import 'package:nutrimpasi/screens/features/notification_screen.dart';
import 'package:nutrimpasi/screens/forum/thread_screen.dart';

// Inisialisasi notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // _showNotification(message);
}

Future<void> setupPushNotifications() async {
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Request permission
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(alert: true, badge: true, sound: true);

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'notification', // ID channel Anda
    'Notifikasi Baru!', // Nama channel yang terlihat oleh pengguna
    description: 'Notifikasi umum untuk aplikasi Anda.', // Deskripsi
    importance: Importance.max,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  // Setup local notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      if (response.payload != null) {
        final Map<String, dynamic> data = jsonDecode(response.payload!);
        handleNotificationNavigation(data);
      }
    },
  );

  // Handle notifications when app is in foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    _showNotification(message);
  });

  // Handle when notification is tapped
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // Panggil fungsi untuk menangani navigasi
    handleNotificationNavigation(message.data);
  });
}

void _showNotification(RemoteMessage message) {
  // Dapatkan title dan body dari payload data
  final String? title = message.data['notification_title'];
  final String? body = message.data['notification_body'];

  // Ambil channel ID dari payload data jika dikirim dari Laravel, jika tidak gunakan default
  final String channelId = message.data['android_channel_id'] ?? 'notification';
  // Anda bisa menentukan nama channel dari sini juga, atau biarkan statis jika hanya 1 channel
  final String channelName = 'Notifikasi Baru!';

  if (title != null && title.isNotEmpty && body != null && body.isNotEmpty) {
    flutterLocalNotificationsPlugin.show(
      message.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }
}

void handleNotificationNavigation(Map<String, dynamic> data) {
  final String? category = data['category'];
  final String? threadId = data['thread_id'];
  final String? commentId = data['comment_id'];

  // Pastikan navigatorKey.currentState tidak null
  if (navigatorKey.currentState != null) {
    if (category == 'thread' && threadId != null) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder:
              (context) => ThreadScreen(
                threadId: int.parse(threadId),
                screenCategory: 'forum',
              ),
        ),
      );
    } else if (category == 'comment' && threadId != null && commentId != null) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder:
              (context) => ThreadScreen(
                threadId: int.parse(threadId),
                highlightCommentId: int.parse(commentId),
                screenCategory: 'forum',
              ),
        ),
      );
    } else if (category == 'schedule') {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => MainPage(initialPage: 2, targetDate: tomorrow),
        ),
      );
    } else if (category == 'report') {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => NotificationScreen()),
      );
    }
  } else {
    debugPrint('NavigatorKey.currentState is null. Cannot navigate.');
  }
}
