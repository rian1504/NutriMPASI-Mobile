// ignore_for_file: unused_local_variable

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrimpasi/constants/remote_dio.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/schedule.dart';

class ScheduleController {
  Dio _dio = RemoteDio().dio;
  set dio(Dio dioInstance) => _dio = dioInstance;

  Future<List<Schedule>> getSchedule() async {
    try {
      // Kirim request ke API
      final response = await _dio.get(ApiEndpoints.schedule);

      // Return data
      return (response.data['data'] as List)
          .map((e) => Schedule.fromJson(e))
          .toList();
    } on DioException catch (e) {
      debugPrint('Get Schedule error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<void> storeSchedule({
    required foodId,
    required List<String> babyId,
    required DateTime date,
  }) async {
    try {
      // data
      final data = FormData();
      for (var id in babyId) {
        data.fields.add(MapEntry('baby_id[]', id)); // Format array PHP
      }
      // Tambahkan field satu per satu
      data.fields.add(MapEntry('date', DateFormat('yyyy-MM-dd').format(date)));

      // Kirim request ke API
      final response = await _dio.post(
        '${ApiEndpoints.schedule}/$foodId',
        data: data,
      );
    } on DioException catch (e) {
      debugPrint('Store Schedule error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<Schedule> editSchedule({required int scheduleId}) async {
    try {
      // Kirim request ke API
      final response = await _dio.get(
        '${ApiEndpoints.schedule}/$scheduleId/edit',
      );

      // Return data
      return Schedule.fromJson(response.data['data']);
    } on DioException catch (e) {
      debugPrint('Edit Schedule error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<void> updateSchedule({
    required int scheduleId,
    required List<String> babyId,
    required DateTime date,
  }) async {
    try {
      // data
      final data = FormData();
      for (var id in babyId) {
        data.fields.add(MapEntry('baby_id[]', id)); // Format array PHP
      }
      // Tambahkan field satu per satu
      data.fields.add(MapEntry('date', DateFormat('yyyy-MM-dd').format(date)));

      // Kirim request ke API
      final response = await _dio.post(
        '${ApiEndpoints.schedule}/$scheduleId/update',
        data: data,
      );
    } on DioException catch (e) {
      debugPrint('Update Schedule error: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<void> deleteSchedule({required int scheduleId}) async {
    try {
      // Kirim request ke API
      final response = await _dio.delete(
        '${ApiEndpoints.schedule}/$scheduleId',
      );
    } on DioException catch (e) {
      debugPrint('Delete Schedule error: ${e.response?.data}');
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
