import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/remote_dio.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/comment.dart';

class CommentController {
  final Dio _dio = RemoteDio().dio;

  Future<ThreadDetail> getThreadDetail({required int threadId}) async {
    try {
      // Kirim request ke API
      final response = await _dio.get('${ApiEndpoints.thread}/$threadId');

      // Debug response
      debugPrint('Get Thread Detail response: ${response.data}');

      // Return data
      return ThreadDetail.fromJson(response.data['data']);
    } on DioException catch (e) {
      debugPrint('Get Thread Detail error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<Comment> storeComment({
    required int threadId,
    required String content,
  }) async {
    try {
      // data
      final data = {'thread_id': threadId, 'content': content};

      // Kirim request ke API
      final response = await _dio.post(ApiEndpoints.comment, data: data);

      // Debug response
      debugPrint('Store Comment response: ${response.data}');

      // Return data
      return Comment.fromJson(response.data['data']);
    } on DioException catch (e) {
      debugPrint('Store Comment error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<Comment> updateComment({
    required int commentId,
    required String content,
  }) async {
    try {
      // data
      final data = {'content': content};

      // Kirim request ke API
      final response = await _dio.post(
        '${ApiEndpoints.comment}/$commentId',
        data: data,
      );

      // Debug response
      debugPrint('Update Comment response: ${response.data}');

      // Return data
      return Comment.fromJson(response.data['data']);
    } on DioException catch (e) {
      debugPrint('Update Comment error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<void> deleteComment({required int commentId}) async {
    try {
      // Kirim request ke API
      final response = await _dio.delete('${ApiEndpoints.comment}/$commentId');

      // Debug response
      debugPrint('Delete Comment response: ${response.data}');
    } on DioException catch (e) {
      debugPrint('Delete Comment error: ${e.response?.data}');
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
