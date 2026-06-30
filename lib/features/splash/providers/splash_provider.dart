import 'package:flutter/material.dart';
import '../../auth/repositories/auth_repository.dart';
import '../../../core/services/sound_service.dart';
import '../../../core/constants/app_constants.dart';

enum SplashNavTarget { login, home }

/// Manages splash screen state: plays sound, waits, then signals navigation.
class SplashProvider extends ChangeNotifier {
  SplashProvider({
    required this.authRepository,
    required this.soundService,
  });

  final AuthRepository authRepository;
  final SoundService soundService;

  SplashNavTarget? _navTarget;
  SplashNavTarget? get navTarget => _navTarget;

  /// Call once when splash screen mounts.
  Future<void> initialize() async {
    // Play splash sound (optional)
    await soundService.playSplash();

    // Wait for animation + minimum display time
    await Future.delayed(AppConstants.splashDelay);

    _navTarget = authRepository.isLoggedIn
        ? SplashNavTarget.home
        : SplashNavTarget.login;
    notifyListeners();
  }
}
