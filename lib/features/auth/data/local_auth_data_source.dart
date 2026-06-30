import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../models/user_model.dart';

/// Persists and retrieves login state from SharedPreferences.
class LocalAuthDataSource {
  LocalAuthDataSource(this._prefs);

  final SharedPreferences _prefs;

  Future<void> saveUser(UserModel user) async {
    await Future.wait([
      _prefs.setBool(AppConstants.keyIsLoggedIn, true),
      _prefs.setString(AppConstants.keyUserId, user.uid),
      _prefs.setString(AppConstants.keyUserName, user.name),
      _prefs.setString(AppConstants.keyUserEmail, user.email),
      _prefs.setString(AppConstants.keyUserPhoto, user.photoUrl),
    ]);
  }

  Future<void> clearUser() async {
    await Future.wait([
      _prefs.remove(AppConstants.keyIsLoggedIn),
      _prefs.remove(AppConstants.keyUserId),
      _prefs.remove(AppConstants.keyUserName),
      _prefs.remove(AppConstants.keyUserEmail),
      _prefs.remove(AppConstants.keyUserPhoto),
    ]);
  }

  bool get isLoggedIn => _prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;

  UserModel? getCachedUser() {
    final uid = _prefs.getString(AppConstants.keyUserId);
    if (uid == null || uid.isEmpty) return null;
    return UserModel(
      uid: uid,
      name: _prefs.getString(AppConstants.keyUserName) ?? '',
      email: _prefs.getString(AppConstants.keyUserEmail) ?? '',
      photoUrl: _prefs.getString(AppConstants.keyUserPhoto) ?? '',
    );
  }
}
