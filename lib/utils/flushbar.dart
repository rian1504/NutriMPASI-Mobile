// lib/utils/app_flushbar.dart
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/colors.dart';

// Enum untuk menentukan tipe notifikasi (sukses, error, info)
enum FlushbarType { success, error, info, warning, normal }

class AppFlushbar {
  // Metode statis untuk menampilkan Flushbar
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    FlushbarType type = FlushbarType.info,
    Duration duration = const Duration(seconds: 3),
    FlushbarPosition position = FlushbarPosition.BOTTOM,
    bool isDismissible = true,
    FlushbarDismissDirection dismissDirection =
        FlushbarDismissDirection.HORIZONTAL,
    Widget? mainButton,
    double? marginVertical,
  }) {
    double marginVerticalValue = marginVertical ?? 88;
    Color backgroundColor;
    IconData? iconData;
    Color iconColor = Colors.white;

    switch (type) {
      case FlushbarType.success:
        backgroundColor = AppColors.success;
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
        backgroundColor = AppColors.accent;
        iconData = Icons.info_outline;
        break;
      case FlushbarType.normal:
        backgroundColor = Colors.black;
        // iconData = Icons.info_outline;
        break;
    }

    Flushbar(
      title: title,
      message: message,
      icon: Icon(iconData, size: 28.0, color: iconColor),
      duration: duration,
      backgroundColor: backgroundColor,
      flushbarPosition: position,
      borderRadius: BorderRadius.circular(12),
      margin: EdgeInsets.fromLTRB(
        8,
        // MediaQuery.of(context).padding.top,
        8,
        8,
        marginVerticalValue,
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withAlpha(75),
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
    Duration duration = const Duration(seconds: 2),
    FlushbarPosition position = FlushbarPosition.BOTTOM,
    FlushbarStatusCallback? onStatusChanged,
    double? marginVerticalValue,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: FlushbarType.success,
      duration: duration,
      position: position,
      marginVertical: marginVerticalValue,
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    FlushbarPosition position = FlushbarPosition.TOP,
    bool isDismissible = true,
    FlushbarStatusCallback? onStatusChanged,
    double? marginVerticalValue,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: FlushbarType.error,
      duration: duration,
      position: position,
      isDismissible: isDismissible,
      marginVertical: marginVerticalValue,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 2),
    FlushbarPosition position = FlushbarPosition.BOTTOM,
    FlushbarStatusCallback? onStatusChanged,
    double? marginVerticalValue,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: FlushbarType.info,
      duration: duration,
      position: position,
      marginVertical: marginVerticalValue,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 2),
    FlushbarPosition position = FlushbarPosition.TOP,
    FlushbarStatusCallback? onStatusChanged,
    double? marginVerticalValue,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: FlushbarType.warning,
      duration: duration,
      position: position,
      marginVertical: marginVerticalValue,
    );
  }

  static void showNormal(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 2),
    FlushbarPosition position = FlushbarPosition.BOTTOM,
    FlushbarStatusCallback? onStatusChanged,
    double? marginVerticalValue,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: FlushbarType.normal,
      duration: duration,
      position: position,
      marginVertical: marginVerticalValue,
    );
  }
}
