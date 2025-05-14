// Widget untuk menampilkan tombol info dengan opsi laporan
import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/colors.dart';

import '../constants/icons.dart' show AppIcons;

class InfoButtonWithReport extends StatelessWidget {
  const InfoButtonWithReport({super.key});

  void _showReportDialog(BuildContext context) {
    final TextEditingController _reasonController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Laporkan Konten'),
            content: TextField(
              controller: _reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Masukkan alasan pelaporan...',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                },
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  final reason = _reasonController.text.trim();
                  if (reason.isNotEmpty) {
                    // TODO: Kirim alasan pelaporan ke backend
                    print("Laporan dikirim: $reason");
                    Navigator.pop(context);
                  }
                },
                child: const Text('Kirim'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(AppIcons.info, size: 20),
      onSelected: (value) {
        if (value == 'copy') {
          // TODO: aksi copy
          print('Copy selected');
        } else if (value == 'report') {
          _showReportDialog(context);
        }
      },
      itemBuilder:
          (BuildContext context) => [
            const PopupMenuItem<String>(value: 'copy', child: Text('Copy')),
            const PopupMenuItem<String>(value: 'report', child: Text('Report')),
          ],
    );
  }
}
