// lib/utils/app_flushbar.dart
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

// Enum untuk menentukan tipe notifikasi (sukses, error, info)
enum FlushbarType { success, error, info, warning }

class AppFlushbar {
  // Metode statis untuk menampilkan Flushbar
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    FlushbarType type = FlushbarType.info, // Default ke info
    Duration duration = const Duration(seconds: 3),
    FlushbarPosition position = FlushbarPosition.BOTTOM,
    bool isDismissible = true,
    FlushbarDismissDirection dismissDirection =
        FlushbarDismissDirection.HORIZONTAL,
    Widget? mainButton,
  }) {
    Color backgroundColor;
    IconData iconData;
    Color iconColor = Colors.white; // Default icon color

    switch (type) {
      case FlushbarType.success:
        backgroundColor = Colors.green.shade700;
        iconData = Icons.check_circle_outline;
        break;
      case FlushbarType.error:
        backgroundColor = Colors.red.shade700;
        iconData = Icons.error_outline;
        break;
      case FlushbarType.warning:
        backgroundColor = Colors.orange.shade700;
        iconData = Icons.warning_amber_outlined;
        break;
      case FlushbarType.info:
      default:
        backgroundColor = Colors.blue.shade700;
        iconData = Icons.info_outline;
        break;
    }

    Flushbar(
      title: title,
      message: message,
      icon: Icon(iconData, size: 28.0, color: iconColor),
      duration: duration,
      backgroundColor: backgroundColor,
      flushbarPosition: position,
      borderRadius: BorderRadius.circular(8),
      margin: const EdgeInsets.all(8),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          offset: const Offset(0.0, 2.0),
          blurRadius: 3.0,
        ),
      ],
      isDismissible: isDismissible,
      dismissDirection: dismissDirection,
      mainButton: mainButton,
    ).show(context);
  }

  // Metode khusus untuk tipe tertentu agar lebih mudah dipanggil
  static void showSuccess(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    FlushbarPosition position = FlushbarPosition.BOTTOM,
    FlushbarStatusCallback? onStatusChanged,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: FlushbarType.success,
      duration: duration,
      position: position,
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 5),
    FlushbarPosition position = FlushbarPosition.TOP,
    bool isDismissible = true,
    FlushbarStatusCallback? onStatusChanged,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: FlushbarType.error,
      duration: duration,
      position: position,
      isDismissible: isDismissible,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    FlushbarPosition position = FlushbarPosition.BOTTOM,
    FlushbarStatusCallback? onStatusChanged,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: FlushbarType.info,
      duration: duration,
      position: position,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
    FlushbarPosition position = FlushbarPosition.TOP,
    FlushbarStatusCallback? onStatusChanged,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: FlushbarType.warning,
      duration: duration,
      position: position,
    );
  }
}
