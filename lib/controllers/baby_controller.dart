import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/remote_dio.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/baby.dart';

class BabyController {
  final Dio _dio = RemoteDio().dio;

  Future<List<Baby>> getBaby() async {
    try {
      // Kirim request ke API
      final response = await _dio.get(ApiEndpoints.baby);

      // Debug response
      debugPrint('Get baby response: ${response.data}');

      // Return data
      return (response.data['data'] as List)
          .map((e) => Baby.fromJson(e))
          .toList();
    } on DioException catch (e) {
      debugPrint('Get baby error: ${e.response?.data}');
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
