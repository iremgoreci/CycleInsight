import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/api_exception.dart';
import '../api/api_client.dart';
import '../models/symptom_type.dart';

final symptomTypeServiceProvider = Provider<SymptomTypeService>((ref) {
  return SymptomTypeService(ref.watch(apiClientProvider));
});

class SymptomTypeService {
  SymptomTypeService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<SymptomType>> getSymptomTypes() async {
    try {
      final response = await _apiClient.dio.get<List<dynamic>>(
        '/symptom_types',
      );
      final data = response.data;
      if (data == null) {
        throw const ApiException(message: 'Unable to load symptom types');
      }
      return data
          .map((item) => SymptomType.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
