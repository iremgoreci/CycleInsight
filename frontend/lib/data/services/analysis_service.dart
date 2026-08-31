import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/api_exception.dart';
import '../api/api_client.dart';
import '../models/analysis.dart';

final analysisServiceProvider = Provider<AnalysisService>((ref) {
  return AnalysisService(ref.watch(apiClientProvider));
});

class AnalysisService {
  AnalysisService(this._apiClient);

  final ApiClient _apiClient;

  Future<Analysis> getAnalysis() async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        '/analysis',
      );
      final data = response.data;
      if (data == null) {
        throw const ApiException(message: 'Unable to load analysis');
      }

      return Analysis.fromJson(data);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
