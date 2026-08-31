import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/api_exception.dart';
import '../api/api_client.dart';
import '../models/daily_log_symptom.dart';

final dailyLogSymptomServiceProvider = Provider<DailyLogSymptomService>((ref) {
  return DailyLogSymptomService(ref.watch(apiClientProvider));
});

class DailyLogSymptomService {
  DailyLogSymptomService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<DailyLogSymptom>> getDailyLogSymptoms() async {
    try {
      final response = await _apiClient.dio.get<List<dynamic>>(
        '/daily_log_symptoms',
      );
      final data = response.data;
      if (data == null) {
        throw const ApiException(message: 'Unable to load daily log symptoms');
      }
      return data
          .map((item) => DailyLogSymptom.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<DailyLogSymptom> addSymptom({
    required int dailyLogId,
    required int symptomTypeId,
  }) async {
    try {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        '/daily_log_symptoms',
        data: {'daily_log_id': dailyLogId, 'symptom_type_id': symptomTypeId},
      );
      final data = response.data;
      if (data == null) {
        throw const ApiException(message: 'Unable to save symptom');
      }
      return DailyLogSymptom.fromJson(data);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<void> deleteSymptom(int dailyLogSymptomId) async {
    try {
      await _apiClient.dio.delete<void>(
        '/daily_log_symptoms/$dailyLogSymptomId',
      );
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
