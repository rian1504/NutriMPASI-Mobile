import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/remote_dio.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/food_suggestion.dart';

class FoodSuggestionController {
  final Dio _dio = RemoteDio().dio;

  Future<FoodSuggestion> showFood({required int foodId}) async {
    try {
      // Kirim request ke API
      final response = await _dio.get('${ApiEndpoints.foodSuggestion}/$foodId');

      // Debug response
      debugPrint('Get Food Suggestion response: ${response.data}');

      // Return data
      return FoodSuggestion.fromJson(response.data['data']);
    } on DioException catch (e) {
      debugPrint('Get Food Suggestion error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<void> deleteFood({required int foodId}) async {
    try {
      // Kirim request ke API
      final response = await _dio.delete(
        '${ApiEndpoints.foodSuggestion}/$foodId',
      );

      // Debug response
      debugPrint('Delete Food Suggestion response: ${response.data}');
    } on DioException catch (e) {
      debugPrint('Delete Food Suggestion error: ${e.response?.data}');
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
