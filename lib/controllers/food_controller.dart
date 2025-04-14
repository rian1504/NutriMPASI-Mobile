import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/remote_dio.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/food.dart';

class FoodController {
  final Dio _dio = RemoteDio().dio;

  Future<List<Food>> getFood() async {
    try {
      // Kirim request ke API
      final response = await _dio.get(ApiEndpoints.food);

      // Debug response
      debugPrint('Get Food response: ${response.data}');

      // Return data
      return (response.data['data'] as List)
          .map((e) => Food.fromJson(e))
          .toList();
    } on DioException catch (e) {
      debugPrint('Get Food error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<List<FoodCategory>> getFoodCategory() async {
    try {
      // Kirim request ke API
      final response = await _dio.get(ApiEndpoints.foodCategory);

      // Debug response
      debugPrint('Get Food Category response: ${response.data}');

      // Return data
      return (response.data['data'] as List)
          .map((e) => FoodCategory.fromJson(e))
          .toList();
    } on DioException catch (e) {
      debugPrint('Get Food Category error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<List<Food>> filterFood({
    String? search,
    String? foodCategoryId,
    String? source,
    String? age,
  }) async {
    try {
      // Data
      final data = {
        if (search != null && search.isNotEmpty) 'search': search,
        if (age != null) 'age': age,
        if (foodCategoryId != null) 'food_category_id': foodCategoryId,
        if (source != null) 'source': source,
      };

      // Kirim request ke API
      final response = await _dio.get(
        ApiEndpoints.foodFilter,
        queryParameters: data,
      );

      // Debug response
      debugPrint('Get Filter Food response: ${response.data}');

      // Return data
      return (response.data['data'] as List)
          .map((e) => Food.fromJson(e))
          .toList();
    } on DioException catch (e) {
      debugPrint('Get Filter Food error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<Food> showFood({required String id}) async {
    try {
      // Kirim request ke API
      final response = await _dio.get('${ApiEndpoints.food}/$id');

      // Debug response
      debugPrint('Get Food Detail response: ${response.data}');

      // Return data
      return Food.fromJson(response.data['data']);
    } on DioException catch (e) {
      debugPrint('Get Food Detail error: ${e.response?.data}');
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
