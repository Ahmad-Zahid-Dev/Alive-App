import '../data/firebase_auth_data_source.dart';
import '../data/local_auth_data_source.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

/// Concrete implementation of [AuthRepository].
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.firebaseDataSource,
    required this.localDataSource,
  });

  final FirebaseAuthDataSource firebaseDataSource;
  final LocalAuthDataSource localDataSource;

  @override
  Future<UserModel?> signInWithGoogle() async {
    final user = await firebaseDataSource.signInWithGoogle();
    if (user != null) {
      await localDataSource.saveUser(user);
    }
    return user;
  }

  @override
  Future<void> signOut() async {
    await firebaseDataSource.signOut();
    await localDataSource.clearUser();
  }

  @override
  bool get isLoggedIn => localDataSource.isLoggedIn;

  @override
  UserModel? getCachedUser() => localDataSource.getCachedUser();
}
