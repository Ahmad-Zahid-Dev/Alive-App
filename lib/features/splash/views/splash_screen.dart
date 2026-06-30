import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/dependency_injection/service_locator.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/splash_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final SplashProvider _splashProvider;
  
  // Background animation controller (drives the moving fluid gradient bubbles)
  late final AnimationController _bgController;
  
  // Entrance & Exit animation controller (drives the glass card, logo, text, and fade-out)
  late final AnimationController _introController;
  
  late final Animation<double> _cardScale;
  late final Animation<double> _cardFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _textFade;
  late final Animation<double> _textSlide;
  late final Animation<double> _loaderFade;

  @override
  void initState() {
    super.initState();
    
    // Setup background dynamic fluid motion controller
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);

    // Setup entrance & exit animations
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _cardFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _cardScale = Tween<double>(begin: 0.85, end: 1.0).animate(CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _logoFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _textFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.4, 0.9, curve: Curves.easeOut),
    );
    _textSlide = Tween<double>(begin: 15.0, end: 0.0).animate(CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.4, 0.9, curve: Curves.easeOut),
    ));

    _loaderFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );

    _splashProvider = sl<SplashProvider>();
    _splashProvider.addListener(_onNavTargetChanged);

    // Start entrance animations
    _introController.forward();

    // Kick off initialization timer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _splashProvider.initialize();
    });
  }

  void _onNavTargetChanged() async {
    if (!mounted) return;
    final target = _splashProvider.navTarget;
    if (target == null) return;

    // Trigger smooth fade-out animation first
    await _introController.animateTo(0.0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);

    if (!mounted) return;
    if (target == SplashNavTarget.home) {
      context.go(AppConstants.routeHome);
    } else {
      context.go(AppConstants.routeLogin);
    }
  }

  @override
  void dispose() {
    _splashProvider.removeListener(_onNavTargetChanged);
    _bgController.dispose();
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark backing under colors
      body: Stack(
        children: [
          // ── Moving Fluid Gradient Background ────────────────────────────────
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, _) {
              final val = _bgController.value;
              final screenW = MediaQuery.sizeOf(context).width;
              final screenH = MediaQuery.sizeOf(context).height;

              // Calculate moving paths for spots
              final spot1X = (screenW * 0.1) + (screenW * 0.2 * val);
              final spot1Y = (screenH * 0.2) + (screenH * 0.15 * (1.0 - val));

              final spot2X = (screenW * 0.6) - (screenW * 0.25 * val);
              final spot2Y = (screenH * 0.5) + (screenH * 0.2 * val);

              final spot3X = (screenW * 0.35) + (screenW * 0.15 * val);
              final spot3Y = (screenH * 0.75) - (screenH * 0.15 * val);

              return Stack(
                children: [
                  // Base background
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1E4001), // Very deep green
                          Color(0xFF070707), // Dark grey
                        ],
                      ),
                    ),
                  ),
                  // Bubble 1 (Primary green #46af03)
                  Positioned(
                    left: spot1X - 180,
                    top: spot1Y - 180,
                    child: _colorBubble(360, AppColors.primary.withAlpha(140)),
                  ),
                  // Bubble 2 (Secondary yellow #f6eb00)
                  Positioned(
                    left: spot2X - 200,
                    top: spot2Y - 200,
                    child: _colorBubble(400, AppColors.secondary.withAlpha(100)),
                  ),
                  // Bubble 3 (Gradient yellow-green #bbd500)
                  Positioned(
                    left: spot3X - 180,
                    top: spot3Y - 180,
                    child: _colorBubble(360, AppColors.gradientStart.withAlpha(115)),
                  ),
                  // Backdrop filter overlay to blend and blur the bubbles into a fluid gradient
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ],
              );
            },
          ),

          // ── Centered Glassmorphism Container Card ──────────────────────────
          Center(
            child: FadeTransition(
              opacity: _cardFade,
              child: ScaleTransition(
                scale: _cardScale,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(28, 40, 28, 36),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(15),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.white.withAlpha(38),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(51),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Glassmorphism Logo frame
                            FadeTransition(
                              opacity: _logoFade,
                              child: ScaleTransition(
                                scale: _logoScale,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(20),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withAlpha(30),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Image.asset(
                                    AppConstants.logoPath,
                                    width: 88,
                                    height: 88,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // App Name and Taglines inside the animated block
                            AnimatedBuilder(
                              animation: _introController,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _textSlide.value),
                                  child: child,
                                );
                              },
                              child: FadeTransition(
                                opacity: _textFade,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      AppConstants.appName,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 40,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Live Streaming · Connect · Share',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: Colors.white.withAlpha(191),
                                        letterSpacing: 0.8,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Glassmorphic Loader at bottom ──────────────────────────────────
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _loaderFade,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(13),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withAlpha(25),
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: AppColors.secondary,
                              strokeWidth: 2.0,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Connecting...',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withAlpha(217),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorBubble(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withAlpha(0),
          ],
        ),
      ),
    );
  }
}
