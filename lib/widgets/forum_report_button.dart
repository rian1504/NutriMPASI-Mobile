// Nama File: forum_report_button.dart
// Deskripsi: Widget untuk menampilkan tombol info dengan opsi laporan
// Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// Tanggal: 15 Mei 2025

// Widget untuk menampilkan tombol info dengan opsi laporan
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/blocs/report/report_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart';
import 'package:nutrimpasi/widgets/message_dialog.dart';

class ReportButton extends StatefulWidget {
  final String category;
  final int refersId;

  const ReportButton({
    super.key,
    required this.category,
    required this.refersId,
  });

  // Method untuk mengubah tampilan category
  String get displayCategory {
    switch (category) {
      case 'thread':
        return 'postingan';
      case 'comment':
        return 'Komentar';
      case 'food':
        return 'makanan';
      default:
        return "konten";
    }
  }

  @override
  State<ReportButton> createState() => _ReportButtonState();
}

class _ReportButtonState extends State<ReportButton> {
  final formKey = GlobalKey<FormState>();
  String reportReason = '';

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(AppIcons.report, size: 24),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return BlocConsumer<ReportBloc, ReportState>(
              listener: (context, state) {
                if (state is ReportSuccess) {
                  _showDialogReportSuccess(context);
                } else if (state is ReportError) {
                  Navigator.of(context, rootNavigator: true).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return AlertDialog(
                  contentPadding: const EdgeInsets.all(24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  title: Text(
                    'Anda yakin ingin melaporkan ${widget.displayCategory} ini?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  content: Form(
                    key: formKey,
                    child: TextFormField(
                      onChanged: (value) {
                        reportReason = value;
                      },
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textBlack,
                      ),
                      minLines: 3,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText:
                            'Masukkan alasan Anda melaporkan ${widget.displayCategory} ini...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: AppColors.textGrey,
                        ),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Alasan laporan tidak boleh kosong';
                        }
                        if (value.trim().length < 4) {
                          return 'Alasan laporan minimal 4 karakter';
                        }
                        return null;
                      },
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
                          onPressed:
                              state is ReportLoading
                                  ? null
                                  : () =>
                                      Navigator.pop(context), // tutup dialog
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
                          onPressed:
                              state is ReportLoading
                                  ? null
                                  : () async {
                                    if (formKey.currentState!.validate()) {
                                      context.read<ReportBloc>().add(
                                        Report(
                                          category: widget.category,
                                          refersId: widget.refersId,
                                          content: reportReason,
                                        ),
                                      );
                                    }
                                  },
                          child:
                              state is ReportLoading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                  : Text('Kirim'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  void _showDialogReportSuccess(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();

    // Tampilkan dialog popup berhasil
    showDialog(
      context: context, // gunakan context yang valid
      barrierDismissible: false,
      useRootNavigator: true, // <-- ini penting
      builder: (context) {
        // Mulai timer saat dialog muncul
        Future.delayed(const Duration(seconds: 3)).then((_) {
          if (context.mounted) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        });

        return MessageDialog(
          imagePath: "assets/images/card/lapor_konten.png",
          message: "Berhasil melaporkan ${widget.displayCategory} ini",
        );
      },
    );
  }
}
