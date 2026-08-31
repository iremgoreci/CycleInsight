import 'package:dio/dio.dart';

class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
  });

  final String message;
  final int? statusCode;

  factory ApiException.fromDio(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    if (data is Map && data['detail'] != null) {
      final message = _messageFromDetail(data['detail']);
      if (message != null) {
        return ApiException(message: message, statusCode: statusCode);
      }
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return ApiException(
        message: 'Unable to reach the server',
        statusCode: statusCode,
      );
    }

    return ApiException(
      message: error.message ?? 'Request failed',
      statusCode: statusCode,
    );
  }

  static String? _messageFromDetail(Object? detail) {
    if (detail is String && detail.isNotEmpty) {
      return detail;
    }

    if (detail is List && detail.isNotEmpty) {
      final parts = detail.map((item) {
        if (item is Map && item['msg'] is String) {
          return item['msg'] as String;
        }
        return item.toString();
      });
      return parts.join('\n');
    }

    return null;
  }

  @override
  String toString() => message;
}
