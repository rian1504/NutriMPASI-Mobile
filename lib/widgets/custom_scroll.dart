import 'package:flutter/material.dart';

class SlowPageScrollPhysics extends PageScrollPhysics {
  const SlowPageScrollPhysics({super.parent});

  // Override properti ini untuk mengurangi sensitivitas
  @override
  double get minFlingDistance => 120.0; // Jarak minimum geser yang harus ditempuh (default 1.0)

  @override
  double get minFlingVelocity => 800.0; // Kecepatan minimum geser untuk memicu perpindahan (default 800.0)
}
