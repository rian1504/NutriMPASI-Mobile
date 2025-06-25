// ignore_for_file: unused_local_variable

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/remote_dio.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/food_suggestion.dart';

class FoodSuggestionController {
  Dio _dio = RemoteDio().dio;
  set dio(Dio dioInstance) => _dio = dioInstance;

  Future<List<FoodCategory>> getFoodCategory() async {
    try {
      // Kirim request ke API
      final response = await _dio.get(ApiEndpoints.foodCategory);

      // Return data
      return (response.data['data'] as List)
          .map((e) => FoodCategory.fromJson(e))
          .toList();
    } on DioException catch (e) {
      debugPrint('Get Food Category error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<FoodSuggestion> showFood({required int foodId}) async {
    try {
      // Kirim request ke API
      final response = await _dio.get('${ApiEndpoints.foodSuggestion}/$foodId');

      // Return data
      return FoodSuggestion.fromJson(response.data['data']);
    } on DioException catch (e) {
      debugPrint('Get Food Suggestion error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<void> storeFood({
    required int foodCategoryId,
    required String name,
    required File image,
    required String age,
    required double energy,
    required double protein,
    required double fat,
    required int portion,
    required List<String> recipe,
    List<String>? fruit,
    required List<String> step,
    required String description,
  }) async {
    try {
      // data
      FormData data = FormData.fromMap({
        'food_category_id': foodCategoryId,
        'name': name,
        'image': await MultipartFile.fromFile(image.path),
        'age': age,
        'energy': energy,
        'protein': protein,
        'fat': fat,
        'portion': portion,
        'recipe': recipe.join(','),
        'fruit': fruit?.join(',') ?? '',
        'step': step.join(','),
        'description': description,
      });

      // Kirim request ke API
      final response = await _dio.post(ApiEndpoints.foodSuggestion, data: data);

    } on DioException catch (e) {
      debugPrint('Store food error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<void> updateFood({
    required int foodId,
    required int foodCategoryId,
    required String name,
    File? image,
    required String age,
    required double energy,
    required double protein,
    required double fat,
    required int portion,
    required List<String> recipe,
    List<String>? fruit,
    required List<String> step,
    required String description,
  }) async {
    try {
      // data
      FormData data = FormData.fromMap({
        'food_category_id': foodCategoryId,
        'name': name,
        'age': age,
        'energy': energy,
        'protein': protein,
        'fat': fat,
        'portion': portion,
        'recipe': recipe.join(','),
        'fruit': fruit?.join(',') ?? '',
        'step': step.join(','),
        'description': description,
      });

      // Tambahkan file gambar ke FormData jika image tidak null
      if (image != null) {
        data.files.add(
          MapEntry('image', await MultipartFile.fromFile(image.path)),
        );
      }

      // Kirim request ke API
      final response = await _dio.post(
        '${ApiEndpoints.foodSuggestion}/$foodId',
        data: data,
      );

    } on DioException catch (e) {
      debugPrint('Update food error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<void> deleteFood({required int foodId}) async {
    try {
      // Kirim request ke API
      final response = await _dio.delete(
        '${ApiEndpoints.foodSuggestion}/$foodId',
      );

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
