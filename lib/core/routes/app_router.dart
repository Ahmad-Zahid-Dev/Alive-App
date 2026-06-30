import 'package:go_router/go_router.dart';

import '../../features/auth/providers/auth_provider.dart';
import '../../features/home/views/home_screen.dart';
import '../../features/auth/views/login_screen.dart';
import '../../features/splash/views/splash_screen.dart';
import '../animations/page_transitions.dart';
import '../constants/app_constants.dart';

/// App router — GoRouter with protected routes.
/// Accepts [authProvider] so the redirect guard can read auth state reliably.
class AppRouter {
  AppRouter._();

  static GoRouter create(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: AppConstants.routeSplash,
      refreshListenable: authProvider,
      redirect: (context, state) {
        final isLoggedIn = authProvider.isLoggedIn;
        final location = state.matchedLocation;

        // Only redirect from home if not logged in
        if (location == AppConstants.routeHome && !isLoggedIn) {
          return AppConstants.routeLogin;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: AppConstants.routeSplash,
          name: 'splash',
          pageBuilder: (context, state) => AppPageTransitions.fade(
            key: state.pageKey,
            child: const SplashScreen(),
          ),
        ),
        GoRoute(
          path: AppConstants.routeLogin,
          name: 'login',
          pageBuilder: (context, state) => AppPageTransitions.slideUp(
            key: state.pageKey,
            child: const LoginScreen(),
          ),
        ),
        GoRoute(
          path: AppConstants.routeHome,
          name: 'home',
          pageBuilder: (context, state) => AppPageTransitions.fade(
            key: state.pageKey,
            child: const HomeScreen(),
          ),
        ),
      ],
    );
  }
}
