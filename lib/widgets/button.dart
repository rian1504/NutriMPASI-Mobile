import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/colors.dart';

class MediumButton extends StatelessWidget {
  final Widget text;
  final VoidCallback? onPressed;

  const MediumButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        elevation: 6,
      ),
      onPressed: onPressed,
      child: text,
    );
  }
}
