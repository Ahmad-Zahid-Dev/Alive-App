import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/gradient_button.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  late final AnimationController _introController;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _titleFade;
  late final Animation<double> _taglineFade;
  late final Animation<double> _emailFade;
  late final Animation<double> _passwordFade;
  late final Animation<double> _forgotFade;
  late final Animation<double> _loginBtnFade;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _logoFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.85, end: 1.0).animate(CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _titleFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.1, 0.7, curve: Curves.easeOut),
    );
    _taglineFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
    );
    _emailFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.3, 0.85, curve: Curves.easeOut),
    );
    _passwordFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.4, 0.9, curve: Curves.easeOut),
    );
    _forgotFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.45, 0.95, curve: Curves.easeOut),
    );
    _loginBtnFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    _introController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _introController.dispose();
    super.dispose();
  }

  void _showOnlyGoogleLoginSnackbar() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.info_outline_rounded, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Text(
              'Only Google Login Is Available',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // Resizes view so user can scroll when keyboard is open
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          // Navigate to home on successful auth
          if (auth.status == AuthStatus.authenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) context.go(AppConstants.routeHome);
            });
          }

          // Show error snackbar
          if (auth.status == AuthStatus.error && auth.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(auth.errorMessage!),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              auth.clearError();
            });
          }

          return SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double screenHeight = constraints.maxHeight;
                final bool isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;

                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isLandscape ? 500 : double.infinity,
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: screenHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              // App logo
                              FadeTransition(
                                opacity: _logoFade,
                                child: ScaleTransition(
                                  scale: _logoScale,
                                  child: Image.asset(
                                    AppConstants.logoPath,
                                    width: isLandscape ? 48 : 60,
                                    height: isLandscape ? 48 : 60,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Title
                              FadeTransition(
                                opacity: _titleFade,
                                child: Text(
                                  'Welcome back! 👋',
                                  style: AppTheme.headlineMedium.copyWith(
                                    fontSize: isLandscape ? 22 : 26,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 6),
                              FadeTransition(
                                opacity: _taglineFade,
                                child: Text(
                                  AppConstants.appTagline,
                                  style: AppTheme.bodyMedium.copyWith(
                                    fontSize: isLandscape ? 11.5 : 12.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              // Adaptive flexible spacer
                              const Spacer(flex: 2),

                              // ── Fields Form Section ──────────────────────────────
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Email field
                                    _buildFieldLabel('Email ID or Phone Number'),
                                    const SizedBox(height: 6),
                                    FadeTransition(
                                      opacity: _emailFade,
                                      child: TextField(
                                        controller: _emailController,
                                        keyboardType: TextInputType.emailAddress,
                                        decoration: const InputDecoration(
                                          hintText: 'Enter Registered Email or Phone No.',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    // Password field
                                    _buildFieldLabel('Password'),
                                    const SizedBox(height: 6),
                                    FadeTransition(
                                      opacity: _passwordFade,
                                      child: TextField(
                                        controller: _passwordController,
                                        obscureText: _obscurePassword,
                                        decoration: InputDecoration(
                                          hintText: 'Enter your password',
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscurePassword
                                                  ? Icons.remove_red_eye_outlined
                                                  : Icons.visibility_off_outlined,
                                              color: AppColors.textSecondary,
                                            ),
                                            onPressed: () => setState(
                                                () => _obscurePassword = !_obscurePassword),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Forgot password
                                    FadeTransition(
                                      opacity: _forgotFade,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            HapticFeedback.lightImpact();
                                            _showOnlyGoogleLoginSnackbar();
                                          },
                                          child: Text(
                                            'Forgot Password?',
                                            style: AppTheme.labelMedium.copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                              decoration: TextDecoration.underline,
                                              decorationColor: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    // Login button
                                    FadeTransition(
                                      opacity: _loginBtnFade,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: GradientButton(
                                          label: 'Login',
                                          isLoading: false,
                                          onTap: () {
                                            HapticFeedback.lightImpact();
                                            _showOnlyGoogleLoginSnackbar();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Adaptive flexible spacer pushing the bottom card to the bottom
                              const Spacer(flex: 1),

                              // ── Green double-wave bottom container ──────────────────
                              _BottomWavyAuthCard(
                                auth: auth, 
                                onFacebookTap: () {
                                  HapticFeedback.lightImpact();
                                  _showOnlyGoogleLoginSnackbar();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label, 
      style: AppTheme.bodyMedium.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Wavy background bottom card
// ─────────────────────────────────────────────────────────────────────────────

class _BottomWavyAuthCard extends StatelessWidget {
  const _BottomWavyAuthCard({
    required this.auth,
    required this.onFacebookTap,
  });

  final AuthProvider auth;
  final VoidCallback onFacebookTap;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    final double cardPaddingBottom = bottomPad > 0 ? bottomPad + 12 : 20;

    return CustomPaint(
      painter: _DoubleWaveCardPainter(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(24, 68, 24, cardPaddingBottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Divider row
            Row(
              children: [
                const Expanded(
                    child: Divider(color: Colors.white60, thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'or continue with',
                    style: TextStyle(
                      color: Colors.white.withAlpha(220),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Expanded(
                    child: Divider(color: Colors.white60, thickness: 1)),
              ],
            ),
            const SizedBox(height: 18),
            // Google button using the real Google icon asset
            _SocialButton(
              label: 'Continue with Google',
              icon: Image.asset(
                'assets/images/google_logo.png',
                width: 22,
                height: 22,
                fit: BoxFit.contain,
              ),
              isLoading: auth.isLoading,
              onTap: auth.isLoading
                  ? null
                  : () => context.read<AuthProvider>().signInWithGoogle(),
            ),
            const SizedBox(height: 12),
            // Facebook button
            _SocialButton(
              label: 'Continue with Facebook',
              icon: Image.asset(
                'assets/images/facebook_logo.png',
                width: 22,
                height: 22,
                fit: BoxFit.contain,
              ),
              onTap: onFacebookTap,
            ),
            const SizedBox(height: 18),
            // Sign up link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(
                      color: Colors.white.withAlpha(220), fontSize: 13),
                ),
                GestureDetector(
                  onTap: onFacebookTap,
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Social Sign In Button
// ─────────────────────────────────────────────────────────────────────────────

class _SocialButton extends StatefulWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    this.onTap,
    this.isLoading = false,
  });

  final String label;
  final Widget icon;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        if (widget.onTap != null) {
          HapticFeedback.lightImpact();
          widget.onTap!.call();
        }
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Color(0xFF22AA00),
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget.icon,
                      const SizedBox(width: 10),
                      Text(
                        widget.label,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// CustomPainter for Double-Wave Green Gradient Bottom Card
// ─────────────────────────────────────────────────────────────────────────────

class _DoubleWaveCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw the back wave (translucent layered depth)
    final backPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0x8846AF03),
          Color(0x88BBD500),
          Color(0x88F6EB00),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Double hump path for back wave (peaks around 25% and 80%)
    final backPath = Path()
      ..moveTo(0, 32)
      ..cubicTo(size.width * 0.12, 12, size.width * 0.28, 12, size.width * 0.45, 38)
      ..cubicTo(size.width * 0.62, 60, size.width * 0.78, 15, size.width, 32)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(backPath, backPaint);

    // 2. Draw the front wave (solid gradient from deep green to bright yellow)
    final frontPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF46AF03), // Deep green
          Color(0xFFBBD500), // Yellow-green
          Color(0xFFF6EB00), // Vibrant yellow
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Double hump path for front wave, offset to match Image 1
    final frontPath = Path()
      ..moveTo(0, 52)
      ..cubicTo(size.width * 0.12, 30, size.width * 0.28, 30, size.width * 0.45, 52)
      ..cubicTo(size.width * 0.62, 70, size.width * 0.78, 25, size.width, 42)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(frontPath, frontPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
