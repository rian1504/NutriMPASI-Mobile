import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/remote_dio.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/favorite.dart';

class FavoriteController {
  final Dio _dio = RemoteDio().dio;

  Future<List<Favorite>> getFavorite() async {
    try {
      // Kirim request ke API
      final response = await _dio.get(ApiEndpoints.favorite);

      // Return data
      return (response.data['data'] as List)
          .map((e) => Favorite.fromJson(e))
          .toList();
    } on DioException catch (e) {
      debugPrint('Get Favorite error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<void> toggleFavorite({required int foodId}) async {
    try {
      // Kirim request ke API
      final response = await _dio.post('${ApiEndpoints.favorite}/$foodId');

      // Debug response
      debugPrint('Favorite response: ${response.data}');
    } on DioException catch (e) {
      debugPrint('Favorite error: ${e.response?.data}');
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
