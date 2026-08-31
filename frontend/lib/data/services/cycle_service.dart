import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/errors/api_exception.dart';
import '../api/api_client.dart';
import '../models/cycle.dart';

final cycleServiceProvider = Provider<CycleService>((ref) {
  return CycleService(ref.watch(apiClientProvider));
});

class CycleService {
  CycleService(this._apiClient);

  final ApiClient _apiClient;

  static final _apiDateFormat = DateFormat('yyyy-MM-dd');

  Future<List<Cycle>> getCycles() async {
    try {
      final response = await _apiClient.dio.get<List<dynamic>>('/cycles');
      final data = response.data;
      if (data == null) {
        throw const ApiException(message: 'Unable to load cycles');
      }

      return data
          .map((item) => Cycle.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Cycle> createCycle({
    required DateTime startDate,
    DateTime? endDate,
  }) async {
    try {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        '/cycles',
        data: _cyclePayload(startDate: startDate, endDate: endDate),
      );
      return _cycleFromResponse(response.data);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Cycle> updateCycle({
    required int cycleId,
    required DateTime startDate,
    DateTime? endDate,
  }) async {
    try {
      final response = await _apiClient.dio.put<Map<String, dynamic>>(
        '/cycles/$cycleId',
        data: _cyclePayload(startDate: startDate, endDate: endDate),
      );
      return _cycleFromResponse(response.data);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<void> deleteCycle(int cycleId) async {
    try {
      await _apiClient.dio.delete<void>('/cycles/$cycleId');
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Map<String, String?> _cyclePayload({
    required DateTime startDate,
    DateTime? endDate,
  }) {
    return {
      'start_date': _apiDateFormat.format(startDate),
      'end_date': endDate == null ? null : _apiDateFormat.format(endDate),
    };
  }

  Cycle _cycleFromResponse(Map<String, dynamic>? data) {
    if (data == null) {
      throw const ApiException(message: 'Cycle request did not return a cycle');
    }
    return Cycle.fromJson(data);
  }
}
