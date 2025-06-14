part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationEvent {}

class LoginRequested extends AuthenticationEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}

class RegisterRequested extends AuthenticationEvent {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });
}

class LogoutRequested extends AuthenticationEvent {}

class ForgotPasswordRequested extends AuthenticationEvent {
  final String email;

  ForgotPasswordRequested({required this.email});
}

class ResetPasswordRequested extends AuthenticationEvent {
  final String email;
  final String token;
  final String password;
  final String passwordConfirmation;

  ResetPasswordRequested({
    required this.email,
    required this.token,
    required this.password,
    required this.passwordConfirmation,
  });
}

class UpdateProfile extends AuthenticationEvent {
  final int userId;
  final String name;
  final String email;
  final File? avatar;

  UpdateProfile({
    required this.userId,
    required this.name,
    required this.email,
    this.avatar,
  });
}

class CheckAuthStatus extends AuthenticationEvent {}
