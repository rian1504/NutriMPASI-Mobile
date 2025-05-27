// Nama File: message_dialog.dart
// Deskripsi: File ini adalah widget untuk menampilkan dialog pesan dengan gambar dan teks.
// Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// Tanggal: 18 Mei 2025

import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/colors.dart';

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
