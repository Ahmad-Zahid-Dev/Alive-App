import 'package:flutter/material.dart';
import '../../auth/models/user_model.dart';
import '../../auth/repositories/auth_repository.dart';
import '../../../core/services/sound_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

/// Manages authentication state across the app.
class AuthProvider extends ChangeNotifier {
  AuthProvider({
    required this.authRepository,
    required this.soundService,
  }) {
    _init();
  }

  final AuthRepository authRepository;
  final SoundService soundService;

  AuthStatus _status = AuthStatus.initial;
  AuthStatus get status => _status;

  UserModel? _user;
  UserModel? get user => _user;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isLoggedIn => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;

  /// Load persisted user on startup.
  void _init() {
    if (authRepository.isLoggedIn) {
      _user = authRepository.getCachedUser();
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
  }

  /// Sign in with Google.
  Future<void> signInWithGoogle() async {
    _setStatus(AuthStatus.loading);
    try {
      await soundService.playClick();
      final user = await authRepository.signInWithGoogle();
      if (user != null) {
        _user = user;
        _setStatus(AuthStatus.authenticated);
        await soundService.playSuccess();
      } else {
        _setStatus(AuthStatus.unauthenticated);
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setStatus(AuthStatus.error);
    }
  }

  /// Sign out.
  Future<void> signOut() async {
    await authRepository.signOut();
    _user = null;
    _setStatus(AuthStatus.unauthenticated);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }
}
