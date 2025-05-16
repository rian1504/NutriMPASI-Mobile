import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/blocs/food/food_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';

class FoodRecipeSuccessScreen extends StatelessWidget {
  const FoodRecipeSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pearl,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 36),
          child: Column(
            children: [
              // Judul halaman
              const Text(
                'Resep Tersimpan',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Indikator progress (3 langkah)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Langkah 1 - Isi Form (sudah selesai)
                  _buildProgressStep(1, 'Isi Form', false, true),

                  // Garis penghubung
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15, left: 10),
                      child: Container(height: 4, color: AppColors.secondary),
                    ),
                  ),

                  // Langkah 2 - Kalkulator Gizi (sudah selesai)
                  _buildProgressStep(2, 'Kalkulator Gizi', false, true),

                  // Garis penghubung
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15, right: 10),
                      child: Container(height: 4, color: AppColors.secondary),
                    ),
                  ),

                  // Langkah 3 - Selesai (langkah aktif)
                  _buildProgressStep(3, 'Selesai', true, false),
                ],
              ),

              const Expanded(child: SizedBox()),

              // Container utama dengan efek bayangan
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Gambar ilustrasi resep
                    Image.asset(
                      'assets/images/component/resep.png',
                      height: 200,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 24),

                    // Teks status keberhasilan (2 baris)
                    const Text(
                      'Berhasil Menambahkan',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),

                    const Text(
                      'Usulan Resep',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),

              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
      // Bottom navigation bar dengan tombol Selesai
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        decoration: const BoxDecoration(color: Colors.white),
        child: ElevatedButton(
          onPressed: () {
            // Navigasi kembali ke halaman awal
            context.read<FoodBloc>().add(FetchFoods());
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text(
            'Selesai',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // Widget helper untuk membuat indikator langkah
  Widget _buildProgressStep(
    int number,
    String label,
    bool isActive,
    bool isCompleted,
  ) {
    Color circleColor;
    Color textColor;

    // Menentukan warna berdasarkan status langkah
    if (isActive) {
      // Langkah aktif (sedang dikerjakan)
      circleColor = AppColors.primary;
      textColor = Colors.white;
    } else if (isCompleted) {
      // Langkah sudah selesai
      circleColor = AppColors.buff;
      textColor = Colors.white;
    } else {
      // Langkah belum aktif/belum dikerjakan
      circleColor = AppColors.componentGrey!;
      textColor = Colors.white;
    }

    return Column(
      children: [
        // Lingkaran indikator dengan nomor
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(shape: BoxShape.circle, color: circleColor),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        // Label langkah
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: isActive ? AppColors.textBlack : Colors.grey,
          ),
        ),
      ],
    );
  }
}
