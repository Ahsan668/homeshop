import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homeshop/core/utils/logger.dart';

/// Firebase Authentication Service
class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService(this._firebaseAuth);

  /// Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Get auth state changes stream
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Sign in with email and password
  Future<Either<String, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        AppLogger.info('User signed in: ${userCredential.user!.uid}');
        return Right(userCredential.user!);
      } else {
        return const Left('Sign in failed');
      }
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Sign in failed', e);
      return Left(_getAuthErrorMessage(e));
    } catch (e) {
      AppLogger.error('Unexpected error during sign in', e);
      return const Left('An unexpected error occurred');
    }
  }

  /// Register with email and password
  Future<Either<String, User>> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        AppLogger.info('User registered: ${userCredential.user!.uid}');
        return Right(userCredential.user!);
      } else {
        return const Left('Registration failed');
      }
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Registration failed', e);
      return Left(_getAuthErrorMessage(e));
    } catch (e) {
      AppLogger.error('Unexpected error during registration', e);
      return const Left('An unexpected error occurred');
    }
  }

  /// Sign out
  Future<Either<String, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      AppLogger.info('User signed out');
      return const Right(null);
    } catch (e) {
      AppLogger.error('Sign out failed', e);
      return const Left('Failed to sign out');
    }
  }

  /// Send password reset email
  Future<Either<String, void>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      AppLogger.info('Password reset email sent to: $email');
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Failed to send password reset email', e);
      return Left(_getAuthErrorMessage(e));
    } catch (e) {
      AppLogger.error('Unexpected error sending password reset email', e);
      return const Left('An unexpected error occurred');
    }
  }

  /// Delete user account
  Future<Either<String, void>> deleteAccount() async {
    try {
      await _firebaseAuth.currentUser?.delete();
      AppLogger.info('User account deleted');
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Failed to delete account', e);
      return Left(_getAuthErrorMessage(e));
    } catch (e) {
      AppLogger.error('Unexpected error deleting account', e);
      return const Left('An unexpected error occurred');
    }
  }

  /// Update user display name
  Future<Either<String, void>> updateDisplayName(String displayName) async {
    try {
      await _firebaseAuth.currentUser?.updateDisplayName(displayName);
      await _firebaseAuth.currentUser?.reload();
      AppLogger.info('Display name updated: $displayName');
      return const Right(null);
    } catch (e) {
      AppLogger.error('Failed to update display name', e);
      return const Left('Failed to update display name');
    }
  }

  /// Update user photo URL
  Future<Either<String, void>> updatePhotoURL(String photoURL) async {
    try {
      await _firebaseAuth.currentUser?.updatePhotoURL(photoURL);
      await _firebaseAuth.currentUser?.reload();
      AppLogger.info('Photo URL updated');
      return const Right(null);
    } catch (e) {
      AppLogger.error('Failed to update photo URL', e);
      return const Left('Failed to update photo URL');
    }
  }

  /// Get auth error message from FirebaseAuthException
  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      case 'requires-recent-login':
        return 'Please log in again to complete this action.';
      default:
        return e.message ?? 'An error occurred during authentication.';
    }
  }
}
