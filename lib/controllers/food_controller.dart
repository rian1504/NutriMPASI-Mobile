import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/remote_dio.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/food.dart';
import 'package:nutrimpasi/models/food_cooking.dart';

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

  Future<Food> showFood({required int foodId}) async {
    try {
      // Kirim request ke API
      final response = await _dio.get('${ApiEndpoints.food}/$foodId');

      // Debug response
      debugPrint('Get Food Detail response: ${response.data}');

      // Return data
      return Food.fromJson(response.data['data']);
    } on DioException catch (e) {
      debugPrint('Get Food Detail error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<FoodCooking> showCookingGuide({
    required String foodId,
    required List<String> babyId,
  }) async {
    try {
      // data
      final data = {'baby_id[]': babyId};

      // Kirim request ke API
      final response = await _dio.get(
        '${ApiEndpoints.food}/$foodId/cook',
        queryParameters: data,
      );

      // Debug response
      debugPrint('Get Food Cooking response: ${response.data}');

      // Return data
      return FoodCooking.fromJson(response.data['data']);
    } on DioException catch (e) {
      debugPrint('Get Food Cooking error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<void> completeCookingGuide({
    required String foodId,
    required List<String> babyId,
    String? scheduleId,
  }) async {
    try {
      // data
      final data = FormData();
      // Tambahkan field satu per satu
      for (var id in babyId) {
        data.fields.add(MapEntry('baby_id[]', id)); // Format array PHP
      }
      if (scheduleId != null) {
        data.fields.add(MapEntry('schedule_id', scheduleId));
      }

      // Kirim request ke API
      final response = await _dio.post(
        '${ApiEndpoints.food}/$foodId/cook/complete',
        data: data,
      );

      // Debug response
      debugPrint('Complete Cooking response: ${response.data}');
    } on DioException catch (e) {
      debugPrint('Complete Cooking error: ${e.response?.data}');
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
