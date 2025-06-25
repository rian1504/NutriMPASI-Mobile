import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrimpasi/constants/remote_dio.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/baby.dart';
import 'package:nutrimpasi/models/baby_food_recommendation.dart';

class BabyController {
  final Dio _dio = RemoteDio().dio;

  Future<List<Baby>> getBaby() async {
    try {
      // Kirim request ke API
      final response = await _dio.get(ApiEndpoints.baby);

      // Return data
      return (response.data['data'] as List)
          .map((e) => Baby.fromJson(e))
          .toList();
    } on DioException catch (e) {
      debugPrint('Get baby error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<void> storeBaby({
    required String name,
    required DateTime dob,
    required String gender,
    required double weight,
    required double height,
    String? condition,
  }) async {
    try {
      final data = FormData();
      data.fields.add(MapEntry('name', name));
      data.fields.add(MapEntry('dob', DateFormat('yyyy-MM-dd').format(dob)));
      data.fields.add(MapEntry('gender', gender));
      data.fields.add(MapEntry('weight', weight.toString()));
      data.fields.add(MapEntry('height', height.toString()));
      data.fields.add(MapEntry('condition', condition!));

      // Kirim request ke API
      final response = await _dio.post(ApiEndpoints.baby, data: data);

      // Debug response
      debugPrint('Store baby response: ${response.data}');
    } on DioException catch (e) {
      debugPrint('Store baby error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<void> updateBaby({
    required int babyId,
    required String name,
    required DateTime dob,
    required String gender,
    required double weight,
    required double height,
    String? condition,
  }) async {
    try {
      // data
      final data = FormData();
      data.fields.add(MapEntry('name', name));
      data.fields.add(MapEntry('dob', DateFormat('yyyy-MM-dd').format(dob)));
      data.fields.add(MapEntry('gender', gender));
      data.fields.add(MapEntry('weight', weight.toString()));
      data.fields.add(MapEntry('height', height.toString()));
      data.fields.add(MapEntry('condition', condition!));

      // Kirim request ke API
      final response = await _dio.post(
        '${ApiEndpoints.baby}/$babyId',
        data: data,
      );

      // Debug response
      debugPrint('Update baby response: ${response.data}');
    } on DioException catch (e) {
      debugPrint('Update baby error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<void> deleteBaby({required int babyId}) async {
    try {
      // Kirim request ke API
      final response = await _dio.delete('${ApiEndpoints.baby}/$babyId');

      // Debug response
      debugPrint('Delete baby response: ${response.data}');
    } on DioException catch (e) {
      debugPrint('Delete baby error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<List<BabyFoodRecommendation>> getBabyFoodRecommendation({
    required int babyId,
  }) async {
    try {
      // Kirim request ke API
      final response = await _dio.get(
        '${ApiEndpoints.babyFoodRecommendation}/$babyId',
      );

      // Return data
      return (response.data['data'] as List)
          .map((e) => BabyFoodRecommendation.fromJson(e))
          .toList();
    } on DioException catch (e) {
      debugPrint('Get baby food recommendation error: ${e.response?.data}');
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
