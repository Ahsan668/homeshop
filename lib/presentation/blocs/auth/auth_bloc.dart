import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeshop/core/constants/app_constants.dart';
import 'package:homeshop/core/utils/logger.dart';
import 'package:homeshop/data/models/user_model.dart';
import 'package:homeshop/data/services/auth/firebase_auth_service.dart';
import 'package:homeshop/presentation/blocs/auth/auth_event.dart';
import 'package:homeshop/presentation/blocs/auth/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Auth BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuthService _authService;
  final SharedPreferences _prefs;

  AuthBloc({
    required FirebaseAuthService authService,
    required SharedPreferences prefs,
  })  : _authService = authService,
        _prefs = prefs,
        super(const AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
    on<SignOutEvent>(_onSignOut);
    on<SendPasswordResetEvent>(_onSendPasswordReset);
    on<DeleteAccountEvent>(_onDeleteAccount);

    // Listen to auth state changes
    _authService.authStateChanges.listen((firebaseUser) {
      if (firebaseUser != null) {
        final user = UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: firebaseUser.displayName,
          photoUrl: firebaseUser.photoURL,
          isAdmin: UserModel.checkIsAdmin(firebaseUser.email ?? ''),
        );
        emit(Authenticated(user));
      } else {
        emit(const Unauthenticated());
      }
    });
  }

  /// Check auth status
  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());

      final firebaseUser = _authService.currentUser;

      if (firebaseUser != null) {
        final user = UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: firebaseUser.displayName,
          photoUrl: firebaseUser.photoURL,
          isAdmin: UserModel.checkIsAdmin(firebaseUser.email ?? ''),
        );

        AppLogger.info('User authenticated: ${user.email}');
        emit(Authenticated(user));
      } else {
        AppLogger.info('User not authenticated');
        emit(const Unauthenticated());
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error checking auth status', e, stackTrace);
      emit(AuthError(e.toString()));
    }
  }

  /// Sign in with email and password
  Future<void> _onSignIn(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());

      AppLogger.info('Signing in user: ${event.email}');

      final result = await _authService.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      result.fold(
        (error) {
          AppLogger.error('Sign in failed: $error');
          emit(AuthError(error));
        },
        (firebaseUser) {
          final user = UserModel(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            name: firebaseUser.displayName,
            photoUrl: firebaseUser.photoURL,
            isAdmin: UserModel.checkIsAdmin(firebaseUser.email ?? ''),
          );

          // Save session
          _prefs.setBool(AppConstants.isLoggedInKey, true);
          _prefs.setString(AppConstants.userIdKey, user.id);

          AppLogger.info('Sign in successful: ${user.email}');
          emit(Authenticated(user));
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error signing in', e, stackTrace);
      emit(AuthError(e.toString()));
    }
  }

  /// Sign up with email and password
  Future<void> _onSignUp(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());

      AppLogger.info('Signing up user: ${event.email}');

      final result = await _authService.registerWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      result.fold(
        (error) {
          AppLogger.error('Sign up failed: $error');
          emit(AuthError(error));
        },
        (firebaseUser) async {
          // Update display name
          await _authService.updateDisplayName(event.name);

          final user = UserModel(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            name: event.name,
            photoUrl: firebaseUser.photoURL,
            isAdmin: UserModel.checkIsAdmin(firebaseUser.email ?? ''),
          );

          // Save session
          _prefs.setBool(AppConstants.isLoggedInKey, true);
          _prefs.setString(AppConstants.userIdKey, user.id);

          AppLogger.info('Sign up successful: ${user.email}');
          emit(Authenticated(user));
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error signing up', e, stackTrace);
      emit(AuthError(e.toString()));
    }
  }

  /// Sign out
  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());

      AppLogger.info('Signing out user');

      final result = await _authService.signOut();

      result.fold(
        (error) {
          AppLogger.error('Sign out failed: $error');
          emit(AuthError(error));
        },
        (_) {
          // Clear session
          _prefs.remove(AppConstants.isLoggedInKey);
          _prefs.remove(AppConstants.userIdKey);
          _prefs.remove(AppConstants.accessTokenKey);
          _prefs.remove(AppConstants.refreshTokenKey);

          AppLogger.info('Sign out successful');
          emit(const Unauthenticated());
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error signing out', e, stackTrace);
      emit(AuthError(e.toString()));
    }
  }

  /// Send password reset email
  Future<void> _onSendPasswordReset(
    SendPasswordResetEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());

      AppLogger.info('Sending password reset email to: ${event.email}');

      final result = await _authService.sendPasswordResetEmail(
        email: event.email,
      );

      result.fold(
        (error) {
          AppLogger.error('Password reset failed: $error');
          emit(AuthError(error));
        },
        (_) {
          AppLogger.info('Password reset email sent');
          emit(const PasswordResetEmailSent());
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error sending password reset email', e, stackTrace);
      emit(AuthError(e.toString()));
    }
  }

  /// Delete account
  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());

      AppLogger.info('Deleting user account');

      final result = await _authService.deleteAccount();

      result.fold(
        (error) {
          AppLogger.error('Account deletion failed: $error');
          emit(AuthError(error));
        },
        (_) {
          // Clear session
          _prefs.remove(AppConstants.isLoggedInKey);
          _prefs.remove(AppConstants.userIdKey);
          _prefs.remove(AppConstants.accessTokenKey);
          _prefs.remove(AppConstants.refreshTokenKey);

          AppLogger.info('Account deleted');
          emit(const AccountDeleted());
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting account', e, stackTrace);
      emit(AuthError(e.toString()));
    }
  }
}
