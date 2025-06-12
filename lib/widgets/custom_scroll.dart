import 'package:flutter/material.dart';

class SlowPageScrollPhysics extends PageScrollPhysics {
  const SlowPageScrollPhysics({super.parent});

  // Override properti ini untuk mengurangi sensitivitas
  @override
  double get minFlingDistance => 120.0; // Jarak minimum geser yang harus ditempuh (default 1.0)
  // Semakin tinggi nilai ini, semakin jauh geseran yang dibutuhkan
  // untuk memicu perpindahan halaman.

  @override
  double get minFlingVelocity => 800.0; // Kecepatan minimum geser untuk memicu perpindahan (default 800.0)
  // Semakin rendah nilai ini, semakin pelan geseran yang dibutuhkan.
  // Namun, karena Anda ingin sensitivitas kecil, kita bisa membuatnya
  // mendekati default, atau bahkan lebih tinggi jika ingin sangat sulit.
  // Saya set 200 agar butuh sedikit lebih cepat dari sekadar "tarikan" kecil.

  // Override applyBoundaryConditions jika Anda ingin mengontrol perilaku overscroll
  // (misalnya untuk menghilangkan efek overscroll)
  // @override
  // ScrollPhysics applyBoundaryConditions(ScrollMetrics position, double value) {
  //   if (value < position.pixels && position.pixels < position.maxScrollExtent) {
  //     // Jika mencoba scroll ke atas saat sudah di atas, dan scroll ke bawah saat sudah di bawah
  //     return const ClampingScrollPhysics(parent: parent); // Menghentikan overscroll bounce
  //   }
  //   return super.applyBoundaryConditions(position, value);
  // }
}
