import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/errors/api_exception.dart';
import '../api/api_client.dart';
import '../models/daily_log.dart';

final dailyLogServiceProvider = Provider<DailyLogService>((ref) {
  return DailyLogService(ref.watch(apiClientProvider));
});

class DailyLogService {
  DailyLogService(this._apiClient);

  final ApiClient _apiClient;

  static final _apiDateFormat = DateFormat('yyyy-MM-dd');

  Future<List<DailyLog>> getDailyLogs() async {
    try {
      final response = await _apiClient.dio.get<List<dynamic>>('/daily_logs');
      final data = response.data;
      if (data == null) {
        throw const ApiException(message: 'Unable to load daily logs');
      }

      final logs = data
          .map((item) => DailyLog.fromJson(item as Map<String, dynamic>))
          .toList();
      logs.sort((a, b) => b.logDate.compareTo(a.logDate));
      return logs;
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<DailyLog> createDailyLog({
    required DateTime logDate,
    required int bleedingLevel,
    required int moodLevel,
    required int painLevel,
    required int sleepQuality,
    required int stressLevel,
    String? notes,
  }) async {
    try {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        '/daily_logs',
        data: _payload(
          logDate: logDate,
          bleedingLevel: bleedingLevel,
          moodLevel: moodLevel,
          painLevel: painLevel,
          sleepQuality: sleepQuality,
          stressLevel: stressLevel,
          notes: notes,
        ),
      );
      return _logFromResponse(response.data);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<DailyLog> updateDailyLog({
    required int dailyLogId,
    required DateTime logDate,
    required int bleedingLevel,
    required int moodLevel,
    required int painLevel,
    required int sleepQuality,
    required int stressLevel,
    String? notes,
  }) async {
    try {
      final response = await _apiClient.dio.put<Map<String, dynamic>>(
        '/daily_logs/$dailyLogId',
        data: _payload(
          logDate: logDate,
          bleedingLevel: bleedingLevel,
          moodLevel: moodLevel,
          painLevel: painLevel,
          sleepQuality: sleepQuality,
          stressLevel: stressLevel,
          notes: notes,
        ),
      );
      return _logFromResponse(response.data);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<void> deleteDailyLog(int dailyLogId) async {
    try {
      await _apiClient.dio.delete<void>('/daily_logs/$dailyLogId');
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Map<String, dynamic> _payload({
    required DateTime logDate,
    required int bleedingLevel,
    required int moodLevel,
    required int painLevel,
    required int sleepQuality,
    required int stressLevel,
    required String? notes,
  }) {
    return {
      'log_date': _apiDateFormat.format(logDate),
      'bleeding_level': bleedingLevel,
      'mood_level': moodLevel,
      'pain_level': painLevel,
      'sleep_quality': sleepQuality,
      'stress_level': stressLevel,
      'notes': notes,
    };
  }

  DailyLog _logFromResponse(Map<String, dynamic>? data) {
    if (data == null) {
      throw const ApiException(
        message: 'Daily log request did not return a daily log',
      );
    }
    return DailyLog.fromJson(data);
  }
}
