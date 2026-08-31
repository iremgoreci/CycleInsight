import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/errors/api_exception.dart';
import '../data/api/api_client.dart';
import '../data/local/token_storage.dart';
import '../data/services/auth_service.dart';
import 'auth_session.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthSession>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AuthSession> {
  var _disposed = false;

  @override
  AuthSession build() {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    ref.read(apiClientProvider).onUnauthorized =
        unauthenticatedFromExpiredToken;
    _restoreSession();
    return const AuthSession.unknown();
  }

  Future<void> _restoreSession() async {
    String? token;
    try {
      token = await ref.read(tokenStorageProvider).readAccessToken();
    } catch (_) {
      token = null;
    }

    if (_disposed) {
      return;
    }

    if (token == null || token.isEmpty) {
      state = const AuthSession.unauthenticated();
      return;
    }

    try {
      final user = await ref.read(authServiceProvider).getCurrentUser();
      if (_disposed) {
        return;
      }
      state = AuthSession.authenticated(user);
    } on ApiException {
      if (_disposed) {
        return;
      }
      await ref.read(tokenStorageProvider).clear();
      if (_disposed) {
        return;
      }
      state = const AuthSession.unauthenticated();
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final authService = ref.read(authServiceProvider);
    final accessToken = await authService.login(
      email: email,
      password: password,
    );
    await ref.read(tokenStorageProvider).saveAccessToken(accessToken);

    try {
      final user = await authService.getCurrentUser();
      if (_disposed) {
        return;
      }
      state = AuthSession.authenticated(user);
    } catch (_) {
      await ref.read(tokenStorageProvider).clear();
      if (_disposed) {
        return;
      }
      state = const AuthSession.unauthenticated();
      rethrow;
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required DateTime dateOfBirth,
  }) async {
    await ref.read(authServiceProvider).register(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          dateOfBirth: dateOfBirth,
        );

    await login(email: email, password: password);
  }

  Future<void> logout() async {
    await ref.read(tokenStorageProvider).clear();
    if (_disposed) {
      return;
    }
    state = const AuthSession.unauthenticated();
  }

  void unauthenticatedFromExpiredToken() {
    if (_disposed) {
      return;
    }
    state = const AuthSession.unauthenticated();
  }
}
