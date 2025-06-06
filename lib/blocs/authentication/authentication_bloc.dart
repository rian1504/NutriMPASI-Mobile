import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/constants/secure_storage.dart';
import 'package:nutrimpasi/controllers/authentication_controller.dart';
import 'package:nutrimpasi/models/user.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationController controller;

  AuthenticationBloc({required this.controller})
    : super(AuthenticationInitial()) {
    on<LoginRequested>(_onLogin);
    on<RegisterRequested>(_onRegister);
    on<LogoutRequested>(_onLogout);
    on<ForgotPasswordRequested>(_onForgotPassword);
    on<ResetPasswordRequested>(_onResetPassword);
    on<CheckAuthStatus>(_onCheckStatus);
  }

  Future<void> _onLogin(
    LoginRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    try {
      final result = await controller.login(
        email: event.email,
        password: event.password,
      );

      final User user = result['user'];
      final String token = result['token'];
      final String message = result['message'];

      emit(LoginSuccess(user: user, token: token, message: message));
    } catch (e) {
      emit(AuthenticationError('Login gagal: ${e.toString()}'));
    }
  }

  Future<void> _onRegister(
    RegisterRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    try {
      final result = await controller.register(
        name: event.name,
        email: event.email,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
      );

      final User user = result['user'];
      final String message = result['message'];

      emit(RegistrationSuccess(user: user, message: message));
    } catch (e) {
      emit(AuthenticationError('Registrasi gagal: ${e.toString()}'));
    }
  }

  Future<void> _onLogout(
    LogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    try {
      final result = await controller.logout();

      emit(LogoutSuccess(message: result));
      emit(AuthenticationUnauthenticated());
    } catch (e) {
      emit(AuthenticationError(e.toString()));
    }
  }

  Future<void> _onForgotPassword(
    ForgotPasswordRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    try {
      final result = await controller.forgotPassword(email: event.email);

      emit(ForgotPasswordSuccess(message: result));
    } catch (e) {
      emit(AuthenticationError(e.toString()));
    }
  }

  Future<void> _onResetPassword(
    ResetPasswordRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    try {
      final result = await controller.resetPassword(
        email: event.email,
        token: event.token,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
      );

      emit(ResetPasswordSuccess(message: result));
    } catch (e) {
      emit(AuthenticationError(e.toString()));
    }
  }

  Future<void> _onCheckStatus(
    CheckAuthStatus event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationChecking());

    final token = await SecureStorage.getToken();

    if (token == null) {
      emit(AuthenticationUnauthenticated());
      return;
    }

    try {
      final user = await controller.getUserProfile();
      emit(LoginSuccess(user: user, token: token));
    } catch (e) {
      await SecureStorage.clearAll();
      emit(AuthenticationUnauthenticated());
    }
  }
}
