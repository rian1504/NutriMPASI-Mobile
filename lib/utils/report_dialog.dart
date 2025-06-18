// lib/utils/report_dialogs.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/blocs/report/report_bloc.dart'; // Impor ReportBloc, ReportEvent, ReportState
import 'package:nutrimpasi/constants/colors.dart'; // Impor AppColors
import 'package:nutrimpasi/utils/flushbar.dart';
import 'package:nutrimpasi/widgets/custom_message_dialog.dart'; // Impor MessageDialog
import 'dart:async'; // Untuk Future.delayed

// --- FUNGSI HELPER UNTUK MENAMPILKAN DIALOG SUKSES ---
// Ini adalah versi statik dari _showDialogReportSuccess yang ada di ReportButtonState
void _showReportSuccessDialog({
  required BuildContext context,
  required String displayCategory, // Misal: "postingan", "komentar"
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (dialogContext) {
      Future.delayed(const Duration(seconds: 3)).then((_) {
        if (dialogContext.mounted) {
          Navigator.of(dialogContext, rootNavigator: true).pop();
        }
      });
      return MessageDialog(
        imagePath: "assets/images/card/lapor_konten.png", // Pastikan path benar
        message: "Berhasil melaporkan $displayCategory ini",
      );
    },
  );
}

// --- FUNGSI UTAMA UNTUK MENAMPILKAN DIALOG LAPORAN ---
Future<void> showReportDialog({
  // Menggunakan Future<void> karena showGeneralDialog
  required BuildContext context, // Context dari tempat fungsi ini dipanggil
  required String category,
  required int refersId,
}) async {
  String _reportReason =
      ''; // Variabel lokal untuk input, tidak ada _formKey yang diakses dari luar
  final _formKey = GlobalKey<FormState>(); // Key lokal untuk form

  await showGeneralDialog(
    // Gunakan await agar bisa menangani pop dialog dengan benar
    context: context,
    transitionBuilder:
        (dialogContext, animation, _, child) => ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        ),
    barrierDismissible: true,
    barrierLabel: 'Tutup',
    barrierColor: Colors.black87,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (dialogContext, _, __) {
      // Menggunakan Builder untuk mendapatkan BuildContext yang tepat untuk BlocConsumer
      return Builder(
        builder: (innerContext) {
          // innerContext untuk BlocConsumer
          return BlocConsumer<ReportBloc, ReportState>(
            listener: (blocConsumerContext, state) {
              // Menggunakan blocConsumerContext untuk listener
              if (state is ReportSuccess) {
                Navigator.of(
                  blocConsumerContext,
                  rootNavigator: true,
                ).pop(); // Tutup dialog laporan ini
                _showReportSuccessDialog(
                  context: context, // Gunakan context asli dari pemanggil
                  displayCategory: _getDisplayCategory(
                    category,
                  ), // Ambil displayCategory dari fungsi helper
                );
              } else if (state is ReportError) {
                Navigator.of(
                  blocConsumerContext,
                  rootNavigator: true,
                ).pop(); // Tutup dialog laporan ini
                AppFlushbar.showError(
                  context,
                  title: 'Error',
                  message: state.error,
                );
              }
            },
            builder: (blocConsumerContext, state) {
              // blocConsumerContext untuk builder
              final bool isLoading = state is ReportLoading;
              return AlertDialog(
                contentPadding: const EdgeInsets.all(24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                title: Text(
                  'Anda yakin ingin melaporkan ${_getDisplayCategory(category)} ini?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                content: Form(
                  key: _formKey,
                  child: TextFormField(
                    onChanged: (value) {
                      _reportReason =
                          value; // Update _reportReason lokal dialog
                    },
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textBlack,
                    ),
                    minLines: 3,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText:
                          'Masukkan alasan Anda melaporkan ${_getDisplayCategory(category)} ini...',
                      hintStyle: const TextStyle(
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
                            isLoading
                                ? null
                                : () =>
                                    Navigator.of(
                                      blocConsumerContext,
                                    ).pop(), // Tutup dialog saat batal
                        child: const Text('Batal'),
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
                            isLoading
                                ? null
                                : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<ReportBloc>().add(
                                      Report(
                                        category: category,
                                        refersId: refersId,
                                        content: _reportReason,
                                      ),
                                    );
                                  }
                                },
                        child:
                            isLoading
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text('Kirim'),
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

// --- FUNGSI HELPER UNTUK MENGAMBIL DISPLAY CATEGORY ---
String _getDisplayCategory(String category) {
  switch (category) {
    case 'thread':
      return 'postingan';
    case 'comment':
      return 'komentar';
    case 'food':
      return 'makanan';
    default:
      return "konten";
  }
}

// --- FUNGSI HELPER UNTUK MENGECEK LOADING STATE ---
bool isLoading(ReportState state) => state is ReportLoading;
