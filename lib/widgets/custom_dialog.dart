import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/colors.dart';

class ConfirmDialog extends StatelessWidget { // Ubah menjadi StatelessWidget karena tidak ada state form
  final String titleText;
  final String contentText; // Properti baru untuk teks konten
  final String confirmButtonText;
  final String cancelButtonText;
  final VoidCallback onConfirm; // Mengubah tipe callback onConfirm
  final VoidCallback onCancel;
  final bool isConfirming; // Status loading untuk tombol Kirim (namanya diganti agar lebih umum)

  // Properti untuk kustomisasi tampilan umum AlertDialog
  final EdgeInsetsGeometry contentPadding;
  final BorderRadiusGeometry borderRadius;
  final double elevation;
  final Color? backgroundColor;
  final Color? confirmButtonColor; // Warna kustom untuk tombol konfirmasi
  final Color? cancelButtonColor; // Warna kustom untuk tombol batal
  final Color? confirmButtonTextColor; // Warna teks kustom tombol konfirmasi
  final Color? cancelButtonTextColor; // Warna teks kustom tombol batal


  const ConfirmDialog({
    super.key,
    required this.titleText,
    required this.contentText, // Properti baru
    required this.onConfirm,
    required this.onCancel,
    this.confirmButtonText = 'Ya', // Default menjadi 'Ya'
    this.cancelButtonText = 'Tidak', // Default menjadi 'Tidak'
    this.isConfirming = false, // Status loading
    this.contentPadding = const EdgeInsets.all(24),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.elevation = 24.0,
    this.backgroundColor,
    this.confirmButtonColor, // Nullable
    this.cancelButtonColor, // Nullable
    this.confirmButtonTextColor,
    this.cancelButtonTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor,
      contentPadding: contentPadding,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      elevation: elevation,
      // Judul dialog
      title: Text(
        titleText,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textBlack,
        ),
      ),
      // Konten dialog (sekarang hanya teks, bukan form)
      content: Text(
        contentText,
        textAlign: TextAlign.center, // Pusatkan teks konten
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textBlack,
        ),
      ),
      // Aksi tombol (Batal dan Konfirmasi)
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Tombol Batal
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: cancelButtonTextColor ?? AppColors.textBlack, // Kustom warna teks
                backgroundColor: cancelButtonColor ?? AppColors.greyLight, // Kustom warna background
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                fixedSize: const Size(120, 40),
              ),
              onPressed: isConfirming ? null : onCancel, // Menonaktifkan saat isConfirming
              child: Text(cancelButtonText),
            ),
            // Tombol Konfirmasi
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: confirmButtonTextColor ?? AppColors.textWhite, // Kustom warna teks
                backgroundColor: confirmButtonColor ?? AppColors.accent, // Kustom warna background
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                fixedSize: const Size(120, 40),
              ),
              onPressed: isConfirming
                  ? null
                  : onConfirm, // Panggil callback onConfirm
              child: isConfirming
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(confirmButtonText),
            ),
          ],
        ),
      ],
    );
  }
}