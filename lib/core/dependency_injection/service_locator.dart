import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/firebase_auth_data_source.dart';
import '../../features/auth/data/local_auth_data_source.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/repositories/auth_repository.dart';
import '../../features/auth/repositories/auth_repository_impl.dart';
import '../../features/home/data/home_local_data_source.dart';
import '../../features/home/providers/home_provider.dart';
import '../../features/home/repositories/home_repository.dart';
import '../../features/home/repositories/home_repository_impl.dart';
import '../../features/splash/providers/splash_provider.dart';
import '../network/api_client.dart';
import '../services/sound_service.dart';

final GetIt sl = GetIt.instance;

/// Register all dependencies with GetIt.
Future<void> setupServiceLocator() async {
  // ── External ─────────────────────────────────────────────────────────────
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // ── Network ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(baseUrl: 'https://api.lvsinnovation.com/v1'),
  );

  // ── Services ──────────────────────────────────────────────────────────────
  sl.registerLazySingleton<SoundService>(() => SoundService());

  // ── Data Sources ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSource(),
  );
  sl.registerLazySingleton<LocalAuthDataSource>(
    () => LocalAuthDataSource(sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSource(),
  );

  // ── Repositories ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      firebaseDataSource: sl<FirebaseAuthDataSource>(),
      localDataSource: sl<LocalAuthDataSource>(),
    ),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      localDataSource: sl<HomeLocalDataSource>(),
    ),
  );

  // ── Providers ─────────────────────────────────────────────────────────────
  sl.registerFactory<SplashProvider>(
    () => SplashProvider(
      authRepository: sl<AuthRepository>(),
      soundService: sl<SoundService>(),
    ),
  );
  sl.registerFactory<AuthProvider>(
    () => AuthProvider(
      authRepository: sl<AuthRepository>(),
      soundService: sl<SoundService>(),
    ),
  );
  sl.registerFactory<HomeProvider>(
    () => HomeProvider(homeRepository: sl<HomeRepository>()),
  );
}
