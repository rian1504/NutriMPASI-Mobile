import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/remote_dio.dart';
import 'package:nutrimpasi/constants/url.dart';

class ReportController {
  final Dio _dio = RemoteDio().dio;

  Future<void> storeReport({
    required String category,
    required int refersId,
    required String content,
  }) async {
    try {
      // data
      final data = {'refers_id': refersId, 'content': content};

      // Kirim request ke API
      final response = await _dio.post(
        '${ApiEndpoints.report}/$category',
        data: data,
      );

      // Debug response
      debugPrint('Report response: ${response.data}');
    } on DioException catch (e) {
      debugPrint('Report error: ${e.response?.data}');
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
