import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    // on<CheckAuthStatus>(_onCheckStatus);
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
    } catch (e) {
      emit(AuthenticationError(e.toString()));
    }
  }

  // Future<void> _onCheckStatus(
  //   CheckAuthStatus event,
  //   Emitter<AuthenticationState> emit,
  // ) async {
  //   final token = await controller.getToken();
  //   if (token != null) {
  //     emit(AuthenticationAuthenticated({'token': token}));
  //   } else {
  //     emit(AuthenticationUnauthenticated());
  //   }
  // }
}
