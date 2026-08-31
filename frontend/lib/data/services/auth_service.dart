import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/errors/api_exception.dart';
import '../api/api_client.dart';
import '../models/user.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(apiClientProvider));
});

class AuthService {
  AuthService(this._apiClient);

  final ApiClient _apiClient;

  static final _dateOfBirthFormat = DateFormat('yyyy-MM-dd');

  Future<User> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required DateTime dateOfBirth,
  }) async {
    try {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        '/users',
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'date_of_birth': _dateOfBirthFormat.format(dateOfBirth),
        },
      );

      final user = response.data;
      if (user == null) {
        throw const ApiException(message: 'Registration did not return a user');
      }

      return User.fromJson(user);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        '/login',
        data: {
          'username': email,
          'password': password,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      final accessToken = response.data?['access_token'];
      if (accessToken is! String || accessToken.isEmpty) {
        throw const ApiException(message: 'Login did not return an access token');
      }

      return accessToken;
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<User> getCurrentUser() async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>('/me');
      final user = response.data;
      if (user == null) {
        throw const ApiException(message: 'Unable to load the current user');
      }

      return User.fromJson(user);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
