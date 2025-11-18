import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homeshop/core/di/injection.dart';
import 'package:homeshop/core/router/route_names.dart';
import 'package:homeshop/data/services/auth/firebase_auth_service.dart';
import 'package:homeshop/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:homeshop/presentation/screens/auth/login_screen.dart';
import 'package:homeshop/presentation/screens/auth/register_screen.dart';

/// App router configuration using GoRouter
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,

    // Redirect logic for auth guard
    redirect: (context, state) {
      final authService = getIt<FirebaseAuthService>();
      final isAuthenticated = authService.currentUser != null;
      final isGoingToAuth = state.matchedLocation.startsWith('/auth');
      final isGoingToSplash = state.matchedLocation == RouteNames.splash;

      // Allow splash screen always
      if (isGoingToSplash) {
        return null;
      }

      // If not authenticated and not going to auth, redirect to login
      if (!isAuthenticated && !isGoingToAuth) {
        return RouteNames.login;
      }

      // If authenticated and going to auth, redirect to home
      if (isAuthenticated && isGoingToAuth) {
        return RouteNames.home;
      }

      // No redirect needed
      return null;
    },

    routes: [
      // Splash/Onboarding Screen
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splash,
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const OnboardingScreen(),
        ),
      ),

      // Auth Routes
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.login,
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const LoginScreen(),
        ),
      ),

      GoRoute(
        path: RouteNames.register,
        name: RouteNames.register,
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const RegisterScreen(),
        ),
      ),

      // Home Screen
      GoRoute(
        path: RouteNames.home,
        name: RouteNames.home,
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const Scaffold(
            body: Center(
              child: Text('Home Screen - To be implemented'),
            ),
          ),
        ),
      ),

      // Products Screen
      GoRoute(
        path: RouteNames.products,
        name: RouteNames.products,
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const Scaffold(
            body: Center(
              child: Text('Products Screen - To be implemented'),
            ),
          ),
        ),
      ),

      // Product Detail Screen
      GoRoute(
        path: '${RouteNames.productDetail}/:id',
        name: RouteNames.productDetail,
        pageBuilder: (context, state) {
          final productId = state.pathParameters['id'] ?? '';
          return _buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: Scaffold(
              body: Center(
                child: Text('Product Detail Screen - ID: $productId - To be implemented'),
              ),
            ),
          );
        },
      ),

      // Cart Screen
      GoRoute(
        path: RouteNames.cart,
        name: RouteNames.cart,
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const Scaffold(
            body: Center(
              child: Text('Cart Screen - To be implemented'),
            ),
          ),
        ),
      ),

      // Profile Screen
      GoRoute(
        path: RouteNames.profile,
        name: RouteNames.profile,
        pageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const Scaffold(
            body: Center(
              child: Text('Profile Screen - To be implemented'),
            ),
          ),
        ),
      ),
    ],

    // Error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.matchedLocation}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.home),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );

  /// Build page with default transition
  static Page _buildPageWithDefaultTransition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  // Private constructor to prevent instantiation
  AppRouter._();
}
