import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/remote_dio.dart';
import 'package:nutrimpasi/constants/secure_storage.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/user.dart';

class AuthenticationController {
  final Dio _dio = RemoteDio().dio;

  // registrasi
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      // data
      final data = {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      };

      // kirim data ke API
      final response = await _dio.post(ApiEndpoints.register, data: data);

      // debug response
      debugPrint('Registration response: ${response.data}');

      // return response
      return {
        'user': User.fromJson(response.data['data']),
        'message': response.data['message'],
      };
    } on DioException catch (e) {
      debugPrint('Registration error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  // login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      // data
      final data = {'email': email, 'password': password};

      // kirim data ke API
      final response = await _dio.post(ApiEndpoints.login, data: data);

      // simpan variabel
      final result = response.data;
      final user = result['user'];
      final token = result['token'];
      final message = result['message'];

      // return response
      return {'user': User.fromJson(user), 'token': token, 'message': message};
    } on DioException catch (e) {
      debugPrint('Login error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  // logout
  Future<String> logout() async {
    try {
      // kirim data ke API
      final response = await _dio.post(ApiEndpoints.logout);

      // debug response
      debugPrint('Logout response: ${response.data}');

      // return response
      return response.data['message'];
    } on DioException catch (e) {
      debugPrint('Logout error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<User> getUserProfile() async {
    try {
      // kirim data ke API
      final response = await _dio.get(ApiEndpoints.user);

      // debug response
      debugPrint('User profile response: ${response.data}');

      // return response
      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await SecureStorage.clearAll();
      }
      throw _handleError(e);
    }
  }

  // forgot password
  Future<String> forgotPassword({required String email}) async {
    try {
      // data
      final data = {'email': email};

      // kirim data ke API
      final response = await _dio.post(ApiEndpoints.forgotPassword, data: data);

      // debug response
      debugPrint('Forgot Password response: ${response.data}');

      // return response
      return response.data['message'];
    } on DioException catch (e) {
      debugPrint('Forgot Password error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  // reset password
  Future<String> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      // data
      final data = {
        'email': email,
        'token': token,
        'password': password,
        'password_confirmation': passwordConfirmation,
      };

      // kirim data ke API
      final response = await _dio.post(ApiEndpoints.resetPassword, data: data);

      // debug response
      debugPrint('Reset Password response: ${response.data}');

      // return response
      return response.data['message'];
    } on DioException catch (e) {
      debugPrint('Reset Password error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  // update profile
  Future<User> updateProfile({
    required int userId,
    required String name,
    required String email,
    File? avatar,
  }) async {
    try {
      // data
      FormData data = FormData.fromMap({'name': name, 'email': email});

      // Tambahkan file gambar ke FormData jika image tidak null
      if (avatar != null) {
        data.files.add(
          MapEntry('avatar', await MultipartFile.fromFile(avatar.path)),
        );
      }

      // kirim data ke API
      final response = await _dio.post(
        '${ApiEndpoints.profile}/$userId',
        data: data,
      );

      // debug response
      debugPrint('Update Profile response: ${response.data}');

      // return response
      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      debugPrint('Update Profile error: ${e.response?.data}');
      // throw _handleError(e);
      throw _formatErrorMessage(e.response?.data);
    }
  }

  // update password
  Future<String> updatePassword({
    required int userId,
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
    File? avatar,
  }) async {
    try {
      // data
      final data = {
        'old_password': oldPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      };

      // kirim data ke API
      final response = await _dio.post(
        '${ApiEndpoints.profile}/$userId/password',
        data: data,
      );

      // debug response
      debugPrint('Update password response: ${response.data}');

      // return response
      return response.data['message'];
    } on DioException catch (e) {
      debugPrint('Update password error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response?.data != null && e.response?.data['message'] != null) {
      return e.response!.data['message'];
    }
    return e.message ?? 'An unexpected error occurred';
  }
}

String _formatErrorMessage(dynamic errorData) {
  if (errorData is Map<String, dynamic>) {
    // Handle error berbentuk {message: "...", errors: {...}}
    if (errorData['errors'] != null) {
      final errors = errorData['errors'] as Map<String, dynamic>;
      return errors.values.first?.first?.toString() ?? errorData['message'];
    }
    return errorData['message'].toString();
  }
  return 'An unexpected error occurred';
}
