part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationChecking extends AuthenticationState {}

class LoginSuccess extends AuthenticationState {
  final User user;
  final String? token;
  final String? message;

  LoginSuccess({required this.user, this.token, this.message});
}

class RegistrationSuccess extends AuthenticationState {
  final User user;
  final String message;

  RegistrationSuccess({required this.user, required this.message});
}

class LogoutSuccess extends AuthenticationState {
  final String message;

  LogoutSuccess({required this.message});
}

class ForgotPasswordSuccess extends AuthenticationState {
  final String message;

  ForgotPasswordSuccess({required this.message});
}

class ResetPasswordSuccess extends AuthenticationState {
  final String message;

  ResetPasswordSuccess({required this.message});
}

final class ProfileUpdated extends AuthenticationState {
  final User user;

  ProfileUpdated({required this.user});
}

final class PasswordUpdated extends AuthenticationState {}

class ProfileError extends AuthenticationState {
  final String error;

  ProfileError(this.error);
}

class AuthenticationError extends AuthenticationState {
  final String error;

  AuthenticationError(this.error);
}

class AuthenticationUnauthenticated extends AuthenticationState {}
