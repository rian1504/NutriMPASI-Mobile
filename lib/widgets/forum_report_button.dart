// Nama File: forum_report_button.dart
// Deskripsi: Widget untuk menampilkan tombol info dengan opsi laporan
// Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// Tanggal: 15 Mei 2025


// Widget untuk menampilkan tombol info dengan opsi laporan
import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/colors.dart';

import '../constants/icons.dart' show AppIcons;

class ButtonWithReport extends StatelessWidget {
  final String content;
  const ButtonWithReport({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(AppIcons.report, size: 20, color: Colors.black,),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            final TextEditingController _controller = TextEditingController();

            return AlertDialog(
              contentPadding: const EdgeInsets.all(24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              title: Text(
                'Anda yakin ingin melaporkan $content ini?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              content: TextFormField(
                style: TextStyle(fontSize: 14, color: AppColors.textBlack),
                minLines: 3,
                maxLines: 5,
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Masukkan alasan Anda melaporkan $content ini...',
                  hintStyle: TextStyle(fontSize: 14, color: AppColors.textGrey),
                  border: InputBorder.none,
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColors.textBlack,
                        backgroundColor: AppColors.greyLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        fixedSize: const Size(120, 40),
                      ),
                      onPressed: () => Navigator.pop(context), // tutup dialog
                      child: Text('Batal'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColors.textWhite,
                        backgroundColor: AppColors.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        fixedSize: const Size(120, 40),
                      ),
                      onPressed: () {
                        final input = _controller.text;
                        // Lakukan sesuatu dengan input

                        Navigator.pop(context);
                      },
                      child: Text('Simpan'),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
