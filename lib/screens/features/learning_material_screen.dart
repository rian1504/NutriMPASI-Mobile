import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart';
import 'package:nutrimpasi/widgets/custom_button.dart';

class LearningMaterialScreen extends StatelessWidget {
  const LearningMaterialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Gambar Materi Pembelajaran
              Image.asset(
                'assets/images/background/materi_pembelajaran.png',
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
              // Row dengan tombol kembali dan judul
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: Text(
                      'Materi Pembelajaran',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                  ),
                ),
              ),
              // Positioned(
              //   // left: 0,
              //   // right: 0,
              //   top: MediaQuery.of(context).padding.top,
              //   child: Center(
              //     child: Text(
              //       'Materi Pembelajaran',
              //       style: TextStyle(
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold,
              //         color: AppColors.textBlack,
              //       ),
              //     ),
              //   ),
              // ),
              // Tombol Kembali
              LeadingActionButton(
                onPressed: () => Navigator.pop(context),
                icon: AppIcons.back,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
