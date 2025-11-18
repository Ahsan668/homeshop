import 'package:equatable/equatable.dart';

/// Auth events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Check auth status event
class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

/// Sign in with email and password event
class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Sign up with email and password event
class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const SignUpEvent({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

/// Sign out event
class SignOutEvent extends AuthEvent {
  const SignOutEvent();
}

/// Send password reset email event
class SendPasswordResetEvent extends AuthEvent {
  final String email;

  const SendPasswordResetEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Delete account event
class DeleteAccountEvent extends AuthEvent {
  const DeleteAccountEvent();
}
