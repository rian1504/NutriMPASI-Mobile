import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/remote_dio.dart';
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

      // debug response
      debugPrint('Login response: ${response.data}');

      // return response
      return {
        'user': User.fromJson(response.data['user']),
        'token': response.data['token'],
        'message': response.data['message'],
      };
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
      debugPrint('Forgot password error: ${e.response?.data}');
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
