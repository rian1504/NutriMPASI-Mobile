part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class LoginSuccess extends AuthenticationState {
  final User user;
  final String token;
  final String message;

  LoginSuccess({
    required this.user,
    required this.token,
    required this.message,
  });
}

class RegistrationSuccess extends AuthenticationState {
  final User user;

  RegistrationSuccess({required this.user});
}

class LogoutSuccess extends AuthenticationState {
  final String message;

  LogoutSuccess({required this.message});
}

class AuthenticationError extends AuthenticationState {
  final String error;

  AuthenticationError(this.error);
}
