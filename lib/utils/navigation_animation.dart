// Nama File: forum_report_button.dart
// Deskripsi: Fungsi untuk animasi transisi halaman dengan efek slide
// Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// Tanggal: 15 Mei 2025

import 'package:flutter/material.dart';

void pushWithSlideTransition(BuildContext context, Widget page) {
  Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween<Offset>(
          begin: Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation);

        // final secondaryOffset = Tween<Offset>(
        //   begin: Offset.zero,
        //   end: Offset(-0.3, 0.0),
        // ).animate(secondaryAnimation);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    ),
  );
}