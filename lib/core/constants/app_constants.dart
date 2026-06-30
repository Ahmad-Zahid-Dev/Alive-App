/// App-wide constants — single source of truth for strings, asset paths, keys.
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Alive';
  static const String appTagline = 'Sign in to continue your live streaming journey.';

  // Asset Paths
  static const String logoPath = 'assets/images/app_logo.png';
  static const String splashSoundPath = 'assets/sounds/splash.mp3';
  static const String clickSoundPath = 'assets/sounds/button_click.mp3';
  static const String successSoundPath = 'assets/sounds/success_login.mp3';

  // SharedPreferences Keys
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserName = 'user_name';
  static const String keyUserEmail = 'user_email';
  static const String keyUserPhoto = 'user_photo';
  static const String keyUserId = 'user_id';

  // Dummy data JSON path
  static const String dummyHomePath = 'assets/data/dummy_home.json';

  // Animation durations
  static const Duration splashDelay = Duration(milliseconds: 2500);
  static const Duration shortAnim = Duration(milliseconds: 200);
  static const Duration mediumAnim = Duration(milliseconds: 400);
  static const Duration longAnim = Duration(milliseconds: 700);

  // Route names
  static const String routeSplash = '/';
  static const String routeLogin = '/login';
  static const String routeHome = '/home';
}
