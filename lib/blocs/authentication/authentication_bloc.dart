import 'dart:io';

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
    on<UpdateProfile>(_onUpdateProfile);
    on<UpdatePassword>(_onUpdatePassword);
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

      await SecureStorage.saveToken(token);
      await SecureStorage.saveUserData(user.toJson());

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

      await SecureStorage.clearAll();

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

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<AuthenticationState> emit,
  ) async {
    final currentState = state;
    emit(AuthenticationLoading());
    try {
      final updatedUser = await controller.updateProfile(
        userId: event.userId,
        name: event.name,
        email: event.email,
        avatar: event.avatar,
      );

      await SecureStorage.saveUserData(updatedUser.toJson());

      // Pertahankan token dari state sebelumnya jika ada
      if (currentState is LoginSuccess) {
        emit(ProfileUpdated(user: updatedUser));
        emit(
          LoginSuccess(
            user: updatedUser,
            token: currentState.token,
            message: 'Profile updated successfully',
          ),
        );
      } else {
        emit(ProfileUpdated(user: updatedUser));
        emit(currentState);
      }
    } catch (e) {
      emit(ProfileError('Update Profile gagal: ${e.toString()}'));
      emit(currentState);
    }
  }

  Future<void> _onUpdatePassword(
    UpdatePassword event,
    Emitter<AuthenticationState> emit,
  ) async {
    final currentState = state;
    emit(AuthenticationLoading());
    try {
      await controller.updatePassword(
        userId: event.userId,
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
        newPasswordConfirmation: event.newPasswordConfirmation,
      );

      if (currentState is LoginSuccess) {
        final userData = await SecureStorage.getUserData();

        final User user = User.fromJson(userData!);
        // First, emit PasswordUpdated for the flushbar
        emit(PasswordUpdated());
        // Then, restore LoginSuccess state with user
        emit(LoginSuccess(user: user, token: currentState.token));
      } else {
        // If the state was not LoginSuccess or ProfileUpdated, just emit PasswordUpdated
        emit(PasswordUpdated());
        emit(currentState);
      }
    } catch (e) {
      emit(ProfileError('Update Password gagal: ${e.toString()}'));
      emit(currentState);
    }
  }

  Future<void> _onCheckStatus(
    CheckAuthStatus event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationChecking());

    final token = await SecureStorage.getToken();
    final userData = await SecureStorage.getUserData();

    if (token == null || userData == null) {
      await SecureStorage.clearAll();
      emit(AuthenticationUnauthenticated());
      return;
    }

    final user = User.fromJson(userData);

    try {
      emit(LoginSuccess(user: user, token: token));
    } catch (e) {
      await SecureStorage.clearAll();
      emit(AuthenticationUnauthenticated());
    }
  }
}
