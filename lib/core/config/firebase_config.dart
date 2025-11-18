import 'package:firebase_core/firebase_core.dart';
import 'package:homeshop/core/utils/logger.dart';
import 'package:homeshop/firebase_options.dart';


/// Firebase configuration and initialization
class FirebaseConfig {
  /// Initialize Firebase
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      AppLogger.info('Firebase initialized successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize Firebase', e, stackTrace);
      rethrow;
    }
  }

  // Private constructor to prevent instantiation
  FirebaseConfig._();
}
