// Nama File: icons.dart
// Deskripsi: File ini adalah file yang berisi ikon-ikon yang digunakan dalam aplikasi Nutrimpasi.
// Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// Tanggal: 13 Mei 2025

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AppIcons {
  // Ikon untuk aplikasi Nutrimpasi
  static IconData get like =>
      PhosphorIcons.thumbsUp(PhosphorIconsStyle.regular);
  static IconData get notification =>
      PhosphorIcons.bellRinging(PhosphorIconsStyle.regular);
  static IconData get favoriteRegular =>
      PhosphorIcons.heart(PhosphorIconsStyle.regular);
  static IconData get reportRegular =>
      PhosphorIcons.warningCircle(PhosphorIconsStyle.regular);

  static IconData get favorite => PhosphorIcons.heart(PhosphorIconsStyle.bold);
  static IconData get comment => PhosphorIcons.chat(PhosphorIconsStyle.bold);
  static IconData get info => PhosphorIcons.info(PhosphorIconsStyle.bold);
  static IconData get report =>
      PhosphorIcons.warningCircle(PhosphorIconsStyle.bold);
  static IconData get back => PhosphorIcons.caretLeft(PhosphorIconsStyle.bold);
  static IconData get exit => PhosphorIcons.x(PhosphorIconsStyle.bold);
  static IconData get arrowRight =>
      PhosphorIcons.caretRight(PhosphorIconsStyle.bold);
  static IconData get arrowDown =>
      PhosphorIcons.caretDown(PhosphorIconsStyle.bold);
  static IconData get arrowUp => PhosphorIcons.caretUp(PhosphorIconsStyle.bold);
  static IconData get home => PhosphorIcons.house(PhosphorIconsStyle.fill);
  static IconData get logout => PhosphorIcons.signOut(PhosphorIconsStyle.fill);
  static IconData get notificationFill =>
      PhosphorIcons.bellRinging(PhosphorIconsStyle.fill);
  // static IconData get loveFill => PhosphorIcons.heart(PhosphorIconsStyle.fill);
  static IconData get commentFill =>
      PhosphorIcons.chat(PhosphorIconsStyle.fill);
  static IconData get editFill =>
      PhosphorIcons.pencilSimple(PhosphorIconsStyle.fill);
  static IconData get baby =>
      PhosphorIcons.babyCarriage(PhosphorIconsStyle.fill);
  static IconData get likeFill =>
      PhosphorIcons.thumbsUp(PhosphorIconsStyle.fill);
  static IconData get favoriteFill =>
      PhosphorIcons.heart(PhosphorIconsStyle.fill);
  static IconData get userFill => PhosphorIcons.user(PhosphorIconsStyle.fill);
  static IconData get avatarFill =>
      PhosphorIcons.userCircle(PhosphorIconsStyle.fill);
  static IconData get menu =>
      PhosphorIcons.dotsThreeOutlineVertical(PhosphorIconsStyle.fill);
  static IconData get deleteFill =>
      PhosphorIcons.trash(PhosphorIconsStyle.fill);
  // static IconData get lockFill => PhosphorIcons.lock(PhosphorIconsStyle.fill);
  static IconData get send =>
      PhosphorIcons.paperPlaneTilt(PhosphorIconsStyle.fill);
  static IconData get setting => PhosphorIcons.gearSix(PhosphorIconsStyle.fill);
  static IconData get calendar =>
      PhosphorIcons.calendarDots(PhosphorIconsStyle.regular);
  // static const like = PhosphorIcons.thumbsUp;
  // static const profile = PhosphorIcons.thumbsUp;

  static const IconData nutrition = Icons.food_bank;
  static const IconData schedule = Icons.calendar_today;
  static const IconData forum = Icons.forum;
  // static const IconData baby = Icons.child_care;
  static const IconData search = Icons.search;
  static const IconData add = Icons.add;
  static const IconData edit = Icons.edit;
  // static const IconData delete = Icons.delete;
  static const IconData check = Icons.check_circle;
  static const IconData uncheck = Icons.radio_button_unchecked;
  static const IconData lockFill = Icons.lock_rounded;
  static const IconData food = Symbols.restaurant_menu;

  //  Symbols.restaurant_menu,
  //  Symbols.home_rounded,
  // Symbols.forum,
  // Symbols.settings,
}
