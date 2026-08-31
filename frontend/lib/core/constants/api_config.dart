import 'package:flutter/foundation.dart';

class ApiConfig {
  const ApiConfig._();

  static const String _fromEnvironment = String.fromEnvironment('API_BASE_URL');

  /// Override with `--dart-define=API_BASE_URL=http://...`.
  ///
  /// Defaults:
  /// - Android (emulator): `http://10.0.2.2:8000`
  /// - other platforms: `http://127.0.0.1:8000`
  ///
  /// A physical Android device needs the host machine's LAN IP via dart-define.
  static String get baseUrl {
    if (_fromEnvironment.isNotEmpty) {
      return _fromEnvironment;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000';
    }

    return 'http://127.0.0.1:8000';
  }

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);
}
