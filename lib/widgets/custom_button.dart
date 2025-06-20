import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart';
import 'package:nutrimpasi/widgets/custom_app_bar.dart';

// class MediumButton extends StatelessWidget {
//   final Widget text;
//   final VoidCallback? onPressed;

//   const MediumButton({super.key, required this.text, required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: AppColors.accent,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//         elevation: 6,
//       ),
//       onPressed: onPressed,
//       child: text,
//     );
//   }
// }

class CircleButton extends StatelessWidget {
  final VoidCallback? onPressed; // Callback saat tombol ditekan
  final Color? buttonColor; // Warna latar belakang tombol (default bisa diset)
  final double size; // Ukuran keseluruhan tombol (diameter)
  final double elevation; // Elevasi/bayangan tombol
  final EdgeInsetsGeometry margin; // Margin eksternal tombol

  // === PROPERTI UNTUK KONTEN (PILIH SALAH SATU) ===
  final Widget? child; // Untuk konten yang sepenuhnya kustom
  final IconData?
  icon; // Untuk menggunakan Icon (jika child dan imagePath null)
  final Color? iconColor; // Warna icon (hanya relevan jika icon diberikan)
  final double? iconSize;
  final String?
  imagePath; // Untuk menggunakan Image.asset (jika child dan icon null)
  final String?
  imageUrl; // Untuk menggunakan Image.network (jika child, icon, imagePath null)
  // ===============================================

  const CircleButton({
    super.key,
    required this.onPressed,
    this.buttonColor = Colors.white,
    this.size = 40.0,
    this.elevation = 2.0,
    this.margin = const EdgeInsets.all(0.0),
    // --- Pastikan hanya satu dari berikut yang diberikan ---
    this.child,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.imagePath,
    this.imageUrl,
  }) : assert(
         // Memastikan hanya SATU dari child, icon, imagePath, atau imageUrl yang tidak null
         (child != null &&
                 icon == null &&
                 imagePath == null &&
                 imageUrl == null) ||
             (child == null &&
                 icon != null &&
                 imagePath == null &&
                 imageUrl == null) ||
             (child == null &&
                 icon == null &&
                 imagePath != null &&
                 imageUrl == null) ||
             (child == null &&
                 icon == null &&
                 imagePath == null &&
                 imageUrl != null),
         'Anda harus menyediakan tepat satu dari: child, icon, imagePath, atau imageUrl',
       );

  // Helper untuk menentukan widget konten berdasarkan properti yang diberikan
  Widget _buildContent() {
    if (child != null) {
      return child!;
    } else if (icon != null) {
      return Icon(
        icon,
        color: iconColor ?? AppColors.primary, // Gunakan iconColor atau default
        size: iconSize ?? size * 0.5, // Ukuran icon proporsional
      );
    } else if (imagePath != null) {
      return Image.asset(
        imagePath!,
        fit: BoxFit.contain, // Default fit, bisa dikustomisasi jika Anda mau
        width: size * 0.5, // Ukuran gambar proporsional
        height: size * 0.5,
        color: AppColors.primary,
      );
    } else if (imageUrl != null) {
      return ClipOval(
        // Biasanya gambar dari URL untuk profil itu melingkar
        child: Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          width: size * 0.5,
          height: size * 0.5,
          color: AppColors.primary,
        ),
      );
    }
    // Jika semua null (assert akan mencegah ini terjadi), kembalikan SizedBox kosong
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: buttonColor,
          padding:
              EdgeInsets.zero, // Padding internal ElevatedButton diatur ke nol
          elevation: elevation,
          minimumSize: Size(size, size), // Ukuran minimum tombol
        ),
        child: SizedBox(
          // Memastikan _buildContent berada di tengah dan memiliki ukuran yang dikontrol
          width:
              size, // Memberikan ruang penuh kepada child agar _buildContent bisa mengatur dirinya
          height: size,
          child: Center(
            child:
                _buildContent(), // Memanggil helper untuk mendapatkan konten yang tepat
          ),
        ),
      ),
    );
  }
}

class SmallButton extends StatelessWidget {
  // Properti yang dapat dikustomisasi
  final String text; // Teks pada tombol
  final VoidCallback? onPressed; // Callback saat tombol ditekan
  final Color? backgroundColor; // Warna latar belakang tombol (opsional)
  final Color? textColor; // Warna teks tombol (opsional)
  final IconData? icon; // Ikon opsional
  final EdgeInsetsGeometry? padding; // Padding tombol (opsional)
  final Size? minimumSize; // Ukuran minimum tombol (opsional)
  final double? fontSize; // Ukuran font teks (opsional)
  final FontWeight? fontWeight; // Ketebalan font teks (opsional)

  const SmallButton({
    super.key,
    required this.text, // Wajib ada teks
    this.onPressed, // Wajib ada fungsi saat ditekan
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.padding,
    this.minimumSize,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // Gunakan callback yang diterima dari properti
      style: ElevatedButton.styleFrom(
        backgroundColor:
            backgroundColor ??
            AppColors.accent, // Gunakan warna default atau yang dikustom
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: padding ?? const EdgeInsets.fromLTRB(20, 8, 20, 8),
        minimumSize: minimumSize ?? const Size(42, 42),
        elevation: 1,
      ),
      child:
          icon !=
                  null // Jika ada ikon, tampilkan Row dengan ikon dan teks
              ? Row(
                mainAxisSize:
                    MainAxisSize
                        .min, // Penting agar Row tidak memakan ruang lebih
                children: [
                  Icon(icon, color: textColor ?? Colors.white),
                  const SizedBox(width: 8), // Jarak antara ikon dan teks
                  Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: fontSize ?? 16,
                      fontWeight: fontWeight ?? FontWeight.w700,
                      color: textColor ?? Colors.white,
                    ),
                  ),
                ],
              )
              : Text(
                // Jika tidak ada ikon, tampilkan hanya teks
                text,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: fontSize ?? 16,
                  fontWeight: fontWeight ?? FontWeight.w700,
                  color: textColor ?? Colors.white,
                ),
              ),
    );
  }
}

class MediumButton extends StatelessWidget {
  // Properti yang dapat dikustomisasi
  final String text; // Teks pada tombol
  final Widget? loadingIndicator; // Teks pada tombol
  final VoidCallback? onPressed; // Callback saat tombol ditekan
  final Color? backgroundColor; // Warna latar belakang tombol (opsional)
  final Color? textColor; // Warna teks tombol (opsional)
  final IconData? icon; // Ikon opsional
  final EdgeInsetsGeometry? padding; // Padding tombol (opsional)
  final Size? minimumSize; // Ukuran minimum tombol (opsional)
  final double? fontSize; // Ukuran font teks (opsional)
  final FontWeight? fontWeight; // Ketebalan font teks (opsional)

  const MediumButton({
    super.key,
    required this.text, // Wajib ada teks
    this.loadingIndicator, // Opsional indikator loading
    this.onPressed, // Wajib ada fungsi saat ditekan
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.padding,
    this.minimumSize,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // Gunakan callback yang diterima dari properti
      style: ElevatedButton.styleFrom(
        backgroundColor:
            backgroundColor ??
            AppColors.accent, // Gunakan warna default atau yang dikustom
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        // padding: padding ?? const EdgeInsets.fromLTRB(20, 8, 20, 8),
        padding: padding ?? EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        minimumSize: minimumSize ?? const Size(42, 42),
        elevation: 1,
      ),
      child:
          icon !=
                  null // Jika ada ikon, tampilkan Row dengan ikon dan teks
              ? Row(
                mainAxisSize:
                    MainAxisSize
                        .min, // Penting agar Row tidak memakan ruang lebih
                children: [
                  Icon(icon, color: textColor ?? Colors.white),
                  const SizedBox(width: 8), // Jarak antara ikon dan teks
                  Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: fontSize ?? 16,
                      fontWeight: fontWeight ?? FontWeight.w700,
                      color: textColor ?? Colors.white,
                    ),
                  ),
                  // text,
                ],
              )
              // : text,
              : Text(
                // Jika tidak ada ikon, tampilkan hanya teks
                text,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: fontSize ?? 16,
                  fontWeight: fontWeight ?? FontWeight.w700,
                  color: textColor ?? Colors.white,
                ),
              ),
    );
  }
}

class LeadingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final double? top;
  final double? left;
  final bool? potioned;
  final double? size;

  const LeadingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black,
    this.elevation = 3,
    this.top,
    this.left,
    this.potioned = true,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top ?? getStatusBarHeight(context) + 8,
      left: left ?? 8,
      child: FloatingActionButton(
        mini: true,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: elevation,
        onPressed: onPressed,
        child: Icon(icon),
      ),
    );
  }
}
