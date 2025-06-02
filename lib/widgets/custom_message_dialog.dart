// Nama File: message_dialog.dart
// Deskripsi: File ini adalah widget untuk menampilkan dialog pesan dengan gambar dan teks.
// Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// Tanggal: 18 Mei 2025

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart';
import 'package:nutrimpasi/widgets/custom_button.dart';

class MessageDialog extends StatelessWidget {
  final String imagePath;
  final String message;

  const MessageDialog({super.key, required this.imagePath, required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(44, 0, 8, 0),
                child: Image.asset(imagePath, width: double.infinity, fit: BoxFit.contain),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyMessage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback? onPressed;
  final IconData? iconName;

  const EmptyMessage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.onPressed,
    this.iconName = Symbols.child_care,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        // margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),

        // child: AnimatedContainer(
        //   duration: const Duration(milliseconds: 300),
        //   curve: Curves.easeInOut,
        //   margin: EdgeInsets.symmetric(
        //     horizontal: 8,
        //     vertical: isCurrentItem ? 0 : 20,
        //   ),
        // child: Container(
        padding: EdgeInsets.fromLTRB(16, 24, 16, MediaQuery.of(context).viewInsets.bottom + 24),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(200),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ikon dan judul
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.bisque, shape: BoxShape.circle),
              child: Icon(iconName, size: 60, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textGrey),
              ),
            ),
            const SizedBox(height: 16),
            // Tombol tambah
            // ElevatedButton.icon(
            //   onPressed: onPressed,
            //   icon: const Icon(Symbols.add),
            //   label: Text(buttonText),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: AppColors.accent,
            //     foregroundColor: Colors.white,
            //     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            //   ),
            // ),
            MediumButton(icon: AppIcons.add, text: buttonText, onPressed: onPressed),
          ],
        ),
        // ),
      ),
    );
  }
}
