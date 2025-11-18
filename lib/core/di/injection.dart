import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:homeshop/core/utils/logger.dart';
import 'package:homeshop/data/repositories/cart_repository_impl.dart';
import 'package:homeshop/data/repositories/product_repository_impl.dart';
import 'package:homeshop/data/services/ai/ai_tryon_service.dart';
import 'package:homeshop/data/services/api/product_api_service.dart';
import 'package:homeshop/data/services/auth/firebase_auth_service.dart';
import 'package:homeshop/data/services/network/dio_client.dart';
import 'package:homeshop/domain/repositories/cart_repository.dart';
import 'package:homeshop/domain/repositories/product_repository.dart';
import 'package:homeshop/presentation/blocs/auth/auth_bloc.dart';
import 'package:homeshop/presentation/blocs/cart/cart_cubit.dart';
import 'package:homeshop/presentation/blocs/product/product_cubit.dart';

/// GetIt service locator instance
final getIt = GetIt.instance;

/// Initialize all dependencies
Future<void> initializeDependencies() async {
  AppLogger.info('Initializing dependencies...');

  // External Dependencies
  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Firebase Auth
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Core Services
  // Dio Client
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // Auth Service
  getIt.registerLazySingleton<FirebaseAuthService>(
    () => FirebaseAuthService(getIt<FirebaseAuth>()),
  );

  // API Services
  getIt.registerLazySingleton<ProductApiService>(
    () => ProductApiService(getIt<DioClient>()),
  );

  getIt.registerLazySingleton<AITryOnService>(
    () => AITryOnService(),
  );

  // Repositories
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(getIt<ProductApiService>()),
  );

  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(),
  );

  // BLoCs / Cubits
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      authService: getIt<FirebaseAuthService>(),
      prefs: getIt<SharedPreferences>(),
    ),
  );

  getIt.registerFactory<CartCubit>(
    () => CartCubit(getIt<CartRepository>()),
  );

  getIt.registerFactory<ProductCubit>(
    () => ProductCubit(getIt<ProductRepository>()),
  );

  AppLogger.info('Dependencies initialized successfully');
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
  AppLogger.info('Dependencies reset');
}
