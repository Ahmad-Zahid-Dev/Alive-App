import '../models/user_model.dart';

/// Abstract auth repository — UI/Providers depend only on this contract.
abstract class AuthRepository {
  /// Sign in with Google.
  Future<UserModel?> signInWithGoogle();

  /// Sign out current user.
  Future<void> signOut();

  /// Whether a user is persisted locally as logged in.
  bool get isLoggedIn;

  /// Returns cached user from local storage.
  UserModel? getCachedUser();
}
