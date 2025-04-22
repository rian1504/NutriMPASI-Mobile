import 'package:dio/dio.dart';
import 'url.dart';
import 'secure_storage.dart';

class RemoteDio {
  final Dio dio = Dio(
      BaseOptions(
        baseUrl: apiUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
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
        onError: (e, handler) {
          if (e.response?.statusCode == 401) {
            // Token expired, logout user
            // context.read<AuthenticationBloc>().add(LogoutRequested());
          }
          return handler.next(e);
        },
      ),
    );
}
