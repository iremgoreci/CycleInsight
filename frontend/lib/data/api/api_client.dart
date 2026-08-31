import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/api_config.dart';
import '../local/token_storage.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient(tokenStorage: ref.watch(tokenStorageProvider));
  ref.onDispose(client.close);
  return client;
});

class ApiClient {
  ApiClient({required this._tokenStorage}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        sendTimeout: ApiConfig.sendTimeout,
        headers: const {
          Headers.acceptHeader: Headers.jsonContentType,
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (!_isPublicAuthPath(options.path)) {
            final token = await _tokenStorage.readAccessToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 &&
              !_isPublicAuthPath(error.requestOptions.path)) {
            await _tokenStorage.clear();
            _onUnauthorized?.call();
          }
          handler.next(error);
        },
      ),
    );
  }

  final TokenStorage _tokenStorage;
  late final Dio _dio;
  void Function()? _onUnauthorized;

  Dio get dio => _dio;

  set onUnauthorized(void Function()? callback) {
    _onUnauthorized = callback;
  }

  void close() => _dio.close(force: true);

  static bool _isPublicAuthPath(String path) {
    return path == '/login' ||
        path == '/users' ||
        path.endsWith('/login') ||
        path.endsWith('/users');
  }
}
