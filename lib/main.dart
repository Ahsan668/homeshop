import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:homeshop/core/config/firebase_config.dart';
import 'package:homeshop/core/constants/app_constants.dart';
import 'package:homeshop/core/constants/hive_constants.dart';
import 'package:homeshop/core/di/injection.dart';
import 'package:homeshop/core/router/app_router.dart';
import 'package:homeshop/core/theme/app_theme.dart';
import 'package:homeshop/core/utils/logger.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize app
  await _initializeApp();

  // Run app
  runApp(const HomeShopApp());
}

/// Initialize all app dependencies and services
Future<void> _initializeApp() async {
  try {
    AppLogger.info('Initializing HomeShop app...');

    // Initialize Hive
    await _initializeHive();

    // Initialize Firebase
    await FirebaseConfig.initialize();

    // Initialize GetIt dependencies
    await initializeDependencies();

    AppLogger.info('HomeShop app initialized successfully');
  } catch (e, stackTrace) {
    AppLogger.error('Failed to initialize app', e, stackTrace);
    rethrow;
  }
}

/// Initialize Hive local database
Future<void> _initializeHive() async {
  try {
    await Hive.initFlutter();

    // Open Hive boxes
    await Hive.openBox(HiveConstants.cartBox);
    await Hive.openBox(HiveConstants.favoritesBox);
    await Hive.openBox(HiveConstants.userBox);
    await Hive.openBox(HiveConstants.settingsBox);

    AppLogger.info('Hive initialized successfully');
  } catch (e, stackTrace) {
    AppLogger.error('Failed to initialize Hive', e, stackTrace);
    rethrow;
  }
}

/// Main app widget
class HomeShopApp extends StatelessWidget {
  const HomeShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // App configuration
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Router configuration
      routerConfig: AppRouter.router,

      // Locale configuration
      localizationsDelegates: const [],
      supportedLocales: const [
        Locale('en', 'US'),
      ],

      // Builder for additional configurations
      builder: (context, child) {
        return MediaQuery(
          // Prevent text scaling beyond 1.0 for consistent UI
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
    );
  }
}
