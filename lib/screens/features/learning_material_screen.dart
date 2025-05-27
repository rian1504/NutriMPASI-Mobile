import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/constants/colors.dart';

class LearningMaterialScreen extends StatelessWidget {
  const LearningMaterialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.champagne,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 3,
            shadowColor: Colors.black54,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                icon: const Icon(
                  Symbols.arrow_back_ios_new_rounded,
                  color: AppColors.textBlack,
                  size: 24,
                ),
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
        title: const Text(
          'Materi Pembelajaran',
          style: TextStyle(
            color: AppColors.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.primary,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gambar Materi Pembelajaran
            Image.asset(
              'assets/images/background/materi_pembelajaran.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      ),
    );
  }
}
