import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) throw UnsupportedError('Web not configured');
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
            'DefaultFirebaseOptions not configured for this platform.');
    }
  }

  static String _getEnvVar(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw StateError(
          'Missing configuration: Environment variable "$key" is not set in your .env file.');
    }
    return value;
  }

  static FirebaseOptions get android => FirebaseOptions(
        apiKey: _getEnvVar('FIREBASE_ANDROID_API_KEY'),
        appId: _getEnvVar('FIREBASE_ANDROID_APP_ID'),
        messagingSenderId: _getEnvVar('FIREBASE_ANDROID_MESSAGING_SENDER_ID'),
        projectId: _getEnvVar('FIREBASE_ANDROID_PROJECT_ID'),
        storageBucket: _getEnvVar('FIREBASE_ANDROID_STORAGE_BUCKET'),
      );

  static FirebaseOptions get ios => FirebaseOptions(
        apiKey: _getEnvVar('FIREBASE_IOS_API_KEY'),
        appId: _getEnvVar('FIREBASE_IOS_APP_ID'),
        messagingSenderId: _getEnvVar('FIREBASE_IOS_MESSAGING_SENDER_ID'),
        projectId: _getEnvVar('FIREBASE_IOS_PROJECT_ID'),
        storageBucket: _getEnvVar('FIREBASE_IOS_STORAGE_BUCKET'),
        iosBundleId: 'com.lvsinnovation.lvsApp',
      );
}
