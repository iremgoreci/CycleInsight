import '../data/models/user.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthSession {
  const AuthSession({
    required this.status,
    this.user,
  });

  const AuthSession.unknown()
      : status = AuthStatus.unknown,
        user = null;

  const AuthSession.authenticated(this.user)
      : status = AuthStatus.authenticated;

  const AuthSession.unauthenticated()
      : status = AuthStatus.unauthenticated,
        user = null;

  final AuthStatus status;
  final User? user;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  @override
  bool operator ==(Object other) {
    return other is AuthSession &&
        other.status == status &&
        other.user == user;
  }

  @override
  int get hashCode => Object.hash(status, user);
}
