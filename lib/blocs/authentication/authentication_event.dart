part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationEvent {}

class LoginRequested extends AuthenticationEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

class RegisterRequested extends AuthenticationEvent {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  RegisterRequested(
    this.name,
    this.email,
    this.password,
    this.passwordConfirmation,
  );
}

class LogoutRequested extends AuthenticationEvent {}

class LoadUserData extends AuthenticationEvent {}

class CheckAuthStatus extends AuthenticationEvent {}
