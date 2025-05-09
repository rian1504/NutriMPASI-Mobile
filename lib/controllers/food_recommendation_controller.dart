import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/remote_dio.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/food_recommendation.dart';

class FoodRecommendationController {
  final Dio _dio = RemoteDio().dio;

  Future<FoodRecommendation> showFood({required int foodId}) async {
    try {
      // Kirim request ke API
      final response = await _dio.get(
        '${ApiEndpoints.foodRecommendation}/$foodId',
      );

      // Debug response
      debugPrint('Get Food Recommendation response: ${response.data}');

      // Return data
      return FoodRecommendation.fromJson(response.data['data']);
    } on DioException catch (e) {
      debugPrint('Get Food Recommendation error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<void> deleteFood({required int foodId}) async {
    try {
      // Kirim request ke API
      final response = await _dio.delete(
        '${ApiEndpoints.foodRecommendation}/$foodId',
      );

      // Debug response
      debugPrint('Delete Food Recommendation response: ${response.data}');
    } on DioException catch (e) {
      debugPrint('Delete Food Recommendation error: ${e.response?.data}');
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
