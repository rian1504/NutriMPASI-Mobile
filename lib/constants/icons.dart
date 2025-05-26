// Nama File: icons.dart
// Deskripsi: File ini adalah file yang berisi ikon-ikon yang digunakan dalam aplikasi Nutrimpasi.
// Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// Tanggal: 13 Mei 2025

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AppIcons {
  // Ikon untuk aplikasi Nutrimpasi
  static IconData get like => PhosphorIcons.thumbsUp(PhosphorIconsStyle.regular);
  static IconData get likeFill => PhosphorIcons.thumbsUp(PhosphorIconsStyle.fill);
  static IconData get favorite => PhosphorIcons.heart(PhosphorIconsStyle.bold);
  static IconData get favoriteFill => PhosphorIcons.heart(PhosphorIconsStyle.fill);
  static IconData get userFill => PhosphorIcons.user(PhosphorIconsStyle.fill);
  static IconData get comment => PhosphorIcons.chat(PhosphorIconsStyle.bold);
  static IconData get info => PhosphorIcons.info(PhosphorIconsStyle.bold);
  static IconData get report => PhosphorIcons.warningCircle(PhosphorIconsStyle.bold);
  static IconData get back => PhosphorIcons.caretLeft(PhosphorIconsStyle.bold);
  static IconData get exit => PhosphorIcons.x(PhosphorIconsStyle.bold);
  static IconData get menu => PhosphorIcons.dotsThreeOutlineVertical(PhosphorIconsStyle.fill);
  static IconData get delete => PhosphorIcons.trash(PhosphorIconsStyle.fill);
  // static const like = PhosphorIcons.thumbsUp;
  // static const profile = PhosphorIcons.thumbsUp;

  static const IconData nutrition = Icons.food_bank;
  static const IconData schedule = Icons.calendar_today;
  static const IconData forum = Icons.forum;
  static const IconData home = Icons.home;
  static const IconData baby = Icons.child_care;
  static const IconData search = Icons.search;
  static const IconData add = Icons.add;
  static const IconData edit = Icons.edit;
  // static const IconData delete = Icons.delete;
  static const IconData check = Icons.check_circle;
  static const IconData uncheck = Icons.radio_button_unchecked;
}
