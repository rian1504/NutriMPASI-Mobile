import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/remote_dio.dart';
import 'package:nutrimpasi/constants/url.dart';

class LikeController {
  final Dio _dio = RemoteDio().dio;

  // Future<List<Like>> getLike() async {
  //   try {
  //     // Kirim request ke API
  //     final response = await _dio.get(ApiEndpoints.like);

  //     // Debug response
  //     debugPrint('Get Like response: ${response.data}');

  //     // Return data
  //     return (response.data['data'] as List)
  //         .map((e) => Like.fromJson(e))
  //         .toList();
  //   } on DioException catch (e) {
  //     debugPrint('Get Like error: ${e.response?.data}');
  //     throw _handleError(e);
  //   }
  // }

  Future<void> toggleLike({required int threadId}) async {
    try {
      // Kirim request ke API
      final response = await _dio.post('${ApiEndpoints.like}/$threadId');

      // Debug response
      debugPrint('Like response: ${response.data}');
    } on DioException catch (e) {
      debugPrint('Like error: ${e.response?.data}');
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
