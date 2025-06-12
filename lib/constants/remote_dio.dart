import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/blocs/authentication/authentication_bloc.dart';
import 'package:nutrimpasi/main.dart';
import 'url.dart';
import 'secure_storage.dart';

class RemoteDio {
  final Dio dio = Dio(
      BaseOptions(
        baseUrl: apiUrl,
        // connectTimeout: const Duration(seconds: 10),
        // receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorage.getToken();

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (e, handler) async {
          // Token expired, logout user
          if (e.response?.statusCode == 401) {
            // 1. Prevent infinite loop
            if (e.requestOptions.path == ApiEndpoints.logout) {
              return handler.next(e);
            }

            // 2. Clear token from storage
            await SecureStorage.clearAll();

            // 3. Show notification only if not already logging out
            if (navigatorKey.currentContext != null &&
                !(e.requestOptions.extra['isLoggingOut'] ?? false)) {
              ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
                SnackBar(
                  content: Text(
                    e.response?.data['message'] ??
                        'Session expired, please login again',
                  ),
                  duration: const Duration(seconds: 3),
                ),
              );

              // 4. Mark request as logging out to prevent recursion
              e.requestOptions.extra['isLoggingOut'] = true;

              // 5. Dispatch logout event
              navigatorKey.currentContext!.read<AuthenticationBloc>().add(
                LogoutRequested(),
              );
            }

            // 6. Reject the original request
            return handler.reject(e);
          }
          return handler.next(e);
        },
      ),
    );
}
