import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/remote_dio.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/thread.dart';

class ThreadController {
  final Dio _dio = RemoteDio().dio;

  Future<List<Thread>> getThread() async {
    try {
      // Kirim request ke API
      final response = await _dio.get(ApiEndpoints.thread);

      // Debug response
      debugPrint('Get Thread response: ${response.data}');

      // Return data
      return (response.data['data'] as List)
          .map((e) => Thread.fromJson(e))
          .toList();
    } on DioException catch (e) {
      debugPrint('Get Thread error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<void> storeThread({
    required String title,
    required String content,
  }) async {
    try {
      // data
      final data = {'title': title, 'content': content};

      // Kirim request ke API
      final response = await _dio.post(ApiEndpoints.threadUser, data: data);

      // Debug response
      debugPrint('Store Thread response: ${response.data}');
    } on DioException catch (e) {
      debugPrint('Store Thread error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<void> updateThread({
    required int threadId,
    required String title,
    required String content,
  }) async {
    try {
      // data
      final data = {'title': title, 'content': content};

      // Kirim request ke API
      final response = await _dio.post(
        '${ApiEndpoints.threadUser}/$threadId',
        data: data,
      );

      // Debug response
      debugPrint('Update Thread response: ${response.data}');
    } on DioException catch (e) {
      debugPrint('Update Thread error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<void> deleteThread({required int threadId}) async {
    try {
      // Kirim request ke API
      final response = await _dio.delete(
        '${ApiEndpoints.threadUser}/$threadId',
      );

      // Debug response
      debugPrint('Delete Thread response: ${response.data}');
    } on DioException catch (e) {
      debugPrint('Delete Thread error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response?.data != null && e.response?.data['message'] != null) {
      return e.response!.data['message'];
    }

    if (e.type == DioExceptionType.connectionTimeout) {
      return 'Koneksi timeout';
    }

    return e.message ?? 'Terjadi kesalahan tidak terduga';
  }
}
