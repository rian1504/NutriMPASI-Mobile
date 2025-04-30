import 'package:flutter/material.dart';
import 'dart:async';
import 'package:nutrimpasi/constants/colors.dart';

class SplashScreen extends StatefulWidget {
  final Widget? nextScreen;

  const SplashScreen({super.key, this.nextScreen});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _primaryController;
  late AnimationController _amberController;
  late AnimationController _lightAmberController;
  late AnimationController _secondaryPrimaryController;
  late Animation<double> _primaryAnimation;
  late Animation<double> _amberAnimation;
  late Animation<double> _lightAmberAnimation;
  late Animation<double> _secondaryPrimaryAnimation;
  late Animation<double> _logoOpacityAnimation;

  // Variabel state untuk melacak apakah logo sudah muncul
  bool _logoRevealed = false;

  // Variabel untuk melacak apakah widget sudah di-dispose
  bool _isDisposed = false;
  final List<Timer> _timers = [];

  // Properti untuk melacak kapan menampilkan lingkaran kelima
  bool _showFifthCircle = false;

  @override
  void initState() {
    super.initState();

    // Membuat controller terpisah untuk setiap lingkaran agar animasi dapat diulang secara independen
    _primaryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _amberController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _lightAmberController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Controller untuk lingkaran primary kedua
    _secondaryPrimaryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Animasi lingkaran pertama (warna orange/primary) - ukuran akhir 3.0
    _primaryAnimation = Tween<double>(begin: 0.1, end: 3.0).animate(
      CurvedAnimation(parent: _primaryController, curve: Curves.easeOut),
    );

    // Animasi lingkaran amber - ukuran akhir 3.0
    _amberAnimation = Tween<double>(
      begin: 0.1,
      end: 3.0,
    ).animate(CurvedAnimation(parent: _amberController, curve: Curves.easeOut));

    // Animasi lingkaran light amber - ukuran akhir 3.0
    _lightAmberAnimation = Tween<double>(begin: 0.1, end: 3.0).animate(
      CurvedAnimation(parent: _lightAmberController, curve: Curves.easeOut),
    );

    // Animasi untuk lingkaran primary kedua - juga dengan ukuran akhir besar
    _secondaryPrimaryAnimation = Tween<double>(begin: 0.1, end: 3.0).animate(
      CurvedAnimation(
        parent: _secondaryPrimaryController,
        curve: Curves.easeOut,
      ),
    );

    // Animasi opacity logo (hanya untuk kemunculan pertama)
    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _primaryController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeIn),
      ),
    );

    // Menambahkan listener untuk menandai ketika logo sudah sepenuhnya ditampilkan
    _primaryController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_logoRevealed) {
        setState(() {
          _logoRevealed = true;
        });
      }
    });

    // Mulai dengan lingkaran primary terlihat dahulu, lalu tunda yang lainnya
    _primaryController.forward();

    // Mengurutkan animasi dengan waktu yang lebih cepat - satu setelah yang lain
    Future.delayed(const Duration(milliseconds: 350), () {
      if (!_isDisposed) {
        _amberController.forward();
      }
    });

    // Light amber dimulai setelah amber
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!_isDisposed) {
        _lightAmberController.forward();
      }
    });

    // Secondary primary dimulai setelah light amber
    Future.delayed(const Duration(milliseconds: 1050), () {
      if (!_isDisposed) {
        _secondaryPrimaryController.forward();
      }
    });

    // Menambahkan animasi lingkaran kelima (amber lagi)
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!_isDisposed) {
        setState(() {
          _showFifthCircle = true;
        });
      }
    });

    // Navigasi ke layar berikutnya setelah penundaan
    Timer(const Duration(milliseconds: 2500), () {
      if (widget.nextScreen != null) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) => widget.nextScreen!,
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              const begin = 0.0;
              const end = 1.0;
              var tween = Tween(begin: begin, end: end);
              var fadeAnimation = animation.drive(tween);

              return FadeTransition(opacity: fadeAnimation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 1200),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    // Tandai sebagai disposed terlebih dahulu
    _isDisposed = true;

    // Batalkan semua timer yang tertunda
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();

    // Kemudian dispose semua controller
    _primaryController.dispose();
    _amberController.dispose();
    _lightAmberController.dispose();
    _secondaryPrimaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxCircleSize = size.width > size.height ? size.height : size.width;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Lingkaran pertama (primary/orange)
            AnimatedBuilder(
              animation: _primaryController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _primaryAnimation.value,
                  child: Container(
                    width: maxCircleSize,
                    height: maxCircleSize,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),

            // Lingkaran kedua (amber)
            AnimatedBuilder(
              animation: _amberController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _amberAnimation.value,
                  child: Container(
                    width: maxCircleSize,
                    height: maxCircleSize,
                    decoration: BoxDecoration(
                      color: AppColors.amber,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),

            // Lingkaran ketiga (light amber)
            AnimatedBuilder(
              animation: _lightAmberController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _lightAmberAnimation.value,
                  child: Container(
                    width: maxCircleSize,
                    height: maxCircleSize,
                    decoration: BoxDecoration(
                      color: AppColors.lightAmber,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),

            // Lingkaran keempat (primary/orange lagi)
            AnimatedBuilder(
              animation: _secondaryPrimaryController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _secondaryPrimaryAnimation.value,
                  child: Container(
                    width: maxCircleSize,
                    height: maxCircleSize,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),

            // Lingkaran kelima (amber lagi) - menggunakan TweenAnimationBuilder
            if (_showFifthCircle)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.1, end: 3.0),
                duration: const Duration(milliseconds: 1000),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: maxCircleSize,
                      height: maxCircleSize,
                      decoration: BoxDecoration(
                        color: AppColors.amber,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),

            // Lingkaran putih di belakang logo (statis)
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),

            // Logo dengan efek fade-in hanya untuk siklus pertama
            _logoRevealed
                ? Image.asset(
                  'assets/images/component/logo_text.png',
                  width: 180,
                  height: 180,
                )
                : AnimatedBuilder(
                  animation: _primaryController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoOpacityAnimation.value,
                      child: Image.asset(
                        'assets/images/component/logo_text.png',
                        width: 180,
                        height: 180,
                      ),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}
