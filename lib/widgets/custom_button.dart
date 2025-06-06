import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/colors.dart';

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
            backgroundColor ?? AppColors.accent, // Gunakan warna default atau yang dikustom
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: padding ?? const EdgeInsets.fromLTRB(20, 8, 20, 8),
        minimumSize: minimumSize ?? const Size(42, 42),
        elevation: 1,
      ),
      child:
          icon !=
                  null // Jika ada ikon, tampilkan Row dengan ikon dan teks
              ? Row(
                mainAxisSize: MainAxisSize.min, // Penting agar Row tidak memakan ruang lebih
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
            backgroundColor ?? AppColors.accent, // Gunakan warna default atau yang dikustom
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
                mainAxisSize: MainAxisSize.min, // Penting agar Row tidak memakan ruang lebih
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

  const LeadingActionButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black,
    this.elevation = 3,
    this.top,
    this.left,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top ?? MediaQuery.of(context).padding.top + 4,
      left: left ?? 4,
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
