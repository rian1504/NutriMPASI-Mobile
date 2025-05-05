import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/remote_dio.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/nutritionist.dart';

class NutritionistController {
  final Dio _dio = RemoteDio().dio;

  Future<List<Nutritionist>> getNutritionist() async {
    try {
      // Kirim request ke API
      final response = await _dio.get(ApiEndpoints.nutritionist);

      // Debug response
      debugPrint('Get Nutritionist response: ${response.data}');

      // Return data
      return (response.data['data'] as List)
          .map((e) => Nutritionist.fromJson(e))
          .toList();
    } on DioException catch (e) {
      debugPrint('Get Nutritionist error: ${e.response?.data}');
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
