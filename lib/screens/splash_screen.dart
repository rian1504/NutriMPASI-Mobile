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
  late AnimationController
  _secondaryPrimaryController; // New controller for the third primary-colored circle
  late Animation<double> _primaryAnimation;
  late Animation<double> _amberAnimation;
  late Animation<double> _lightAmberAnimation;
  late Animation<double>
  _secondaryPrimaryAnimation; // New animation for the third primary-colored circle
  late Animation<double> _logoOpacityAnimation;

  // Add a state variable to track if logo has already appeared
  bool _logoRevealed = false;

  // Add these variables to track if widget is disposed
  bool _isDisposed = false;
  List<Timer> _timers = [];

  // Add this property to track when to show the fifth circle
  bool _showFifthCircle = false;

  @override
  void initState() {
    super.initState();

    // Create separate controllers for each circle for independent repeating animations
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

    // New controller for secondary primary circle
    _secondaryPrimaryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Primary circle animation (orange) - increase end size to 3.0
    _primaryAnimation = Tween<double>(begin: 0.1, end: 3.0).animate(
      CurvedAnimation(parent: _primaryController, curve: Curves.easeOut),
    );

    // Amber circle animation - increase end size to 3.0
    _amberAnimation = Tween<double>(
      begin: 0.1,
      end: 3.0,
    ).animate(CurvedAnimation(parent: _amberController, curve: Curves.easeOut));

    // Light amber circle animation - increase end size to 3.0
    _lightAmberAnimation = Tween<double>(begin: 0.1, end: 3.0).animate(
      CurvedAnimation(parent: _lightAmberController, curve: Curves.easeOut),
    );

    // New animation for secondary primary circle - also large end size
    _secondaryPrimaryAnimation = Tween<double>(begin: 0.1, end: 3.0).animate(
      CurvedAnimation(
        parent: _secondaryPrimaryController,
        curve: Curves.easeOut,
      ),
    );

    // Logo opacity animation (only for first appearance)
    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _primaryController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeIn),
      ),
    );

    // Add listener to mark when logo is fully revealed
    _primaryController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_logoRevealed) {
        setState(() {
          _logoRevealed = true;
        });
      }
    });

    // Start with primary circle visible first, then delay the others
    _primaryController.forward();

    // Sequence the animations with faster timing - one after another
    Future.delayed(const Duration(milliseconds: 350), () {
      if (!_isDisposed) {
        _amberController.forward();
      }
    });

    // Light amber starts after amber
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!_isDisposed) {
        _lightAmberController.forward();
      }
    });

    // Secondary primary starts after light amber
    Future.delayed(const Duration(milliseconds: 1050), () {
      if (!_isDisposed) {
        _secondaryPrimaryController.forward();
      }
    });

    // Add fifth circle animations (amber again)
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!_isDisposed) {
        // Instead of reusing amber controller, let's just track the time for the fifth circle
        setState(() {
          // This will make our fifth circle appear in the build method
          _showFifthCircle = true;
        });
      }
    });

    // Navigate to next screen after delay
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
    // Mark as disposed first
    _isDisposed = true;

    // Cancel all pending timers
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();

    // Then dispose controllers
    _primaryController.dispose();
    _amberController.dispose();
    _lightAmberController.dispose();
    _secondaryPrimaryController.dispose(); // Dispose the new controller
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
            // First circle (primary/orange)
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

            // Second circle (amber)
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

            // Third circle (light amber)
            AnimatedBuilder(
              animation: _lightAmberController,
              builder: (context, child) {
                // Make sure this is always visible and properly scaled
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

            // Fourth circle (primary/orange again)
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

            // Fifth circle (amber again) - using TweenAnimationBuilder instead of reusing controller
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

            // White circle behind the logo (static)
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),

            // Logo with fade-in effect for first cycle only
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
