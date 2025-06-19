import 'package:flutter/material.dart';

class AppColors {
  // Primary color
  static const Color primary = Color(0xFFFC8207);

  //accent color
  static const Color accent = Color(0xFF5966B1);

  // Background color
  static const Color background = Color(0xFFF9F9F9);

  // BW color
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  // Semantic color
  static const Color error = Color(0xFFFE2323);
  static const Color success = Color(0xFF14AE5C);
  static const Color warning = Color(0xFFFFCD29);

  // Transparent color
  static Color primaryHighTransparent = Color(0xFFFC8207).withAlpha(25);
  static Color accentHighTransparent = Color(0xFF5966B1).withAlpha(25);
  static Color errorHighTranparent = Color(0xFFFE2323).withAlpha(25);
  static Color primaryLowTransparent = Color(0xFFFC8207).withAlpha(175);
  static Color errorLowTranparent = Color(0xFFFE2323).withAlpha(175);

  // Grey color
  static const Color grey = Color(0xFFD9D9D9);
  static const Color greyDark = Color(0xFF808080);
  static const Color greyLight = Color(0xFFE5E5E5);

  // Color pallete
  static const Color lavenderBlue = Color(0xFFBABAEE);
  static const Color champagne = Color(0xFFFFF9EB);
  static const Color cream = Color(0xFFEBDDC5);
  static const Color porcelain = Color(0xFFFDEFC0);
  static const Color bisque = Color(0xFFFFE1BE);
  static const Color buff = Color(0xFFF3D58D);
  static const Color lightAmber = Color(0xFFFFC16B);
  static const Color amber = Color(0xFFFEAC3B);
  static Color red = Color(0xFFF54242);
  static Color green = Color(0xFF14AE5C);

  // Text color
  static const Color textBlack = Color(0xFF323232);
  static const Color textGrey = Color(0xFF808080);
  static const Color textWhite = Color(0xFFFFFFFF);

  // item color
  static Color? componentGrey = Colors.grey[300];
  static Color? componentBlack = Color(0xFF4F4E4E);
}
