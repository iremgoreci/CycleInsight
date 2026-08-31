import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/cycle.dart';
import '../../data/models/daily_log.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/cycles/cycle_form_screen.dart';
import '../../screens/daily_logs/daily_log_form_screen.dart';
import '../../screens/shell/app_shell_screen.dart';
import '../../screens/splash/splash_screen.dart';
import '../../state/auth_provider.dart';
import '../../state/auth_session.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<AuthSession>(ref.read(authProvider));
  ref.listen<AuthSession>(authProvider, (_, next) {
    refresh.value = next;
  });
  ref.onDispose(refresh.dispose);

  final router = GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final location = state.matchedLocation;
      final isSplash = location == '/splash';
      final isAuthRoute = location == '/login' || location == '/register';

      switch (auth.status) {
        case AuthStatus.unknown:
          return isSplash ? null : '/splash';
        case AuthStatus.unauthenticated:
          if (isAuthRoute) {
            return null;
          }
          return '/login';
        case AuthStatus.authenticated:
          if (isSplash || isAuthRoute) {
            return '/';
          }
          return null;
      }
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const AppShellScreen(selectedIndex: 0),
      ),
      GoRoute(
        path: '/daily-logs',
        builder: (context, state) => const AppShellScreen(selectedIndex: 1),
      ),
      GoRoute(
        path: '/insights',
        builder: (context, state) => const AppShellScreen(selectedIndex: 2),
      ),
      GoRoute(
        path: '/cycles/new',
        builder: (context, state) => const CycleFormScreen(),
      ),
      GoRoute(
        path: '/cycles/:cycleId/edit',
        builder: (context, state) =>
            CycleFormScreen(cycle: state.extra as Cycle?),
      ),
      GoRoute(
        path: '/daily-logs/new',
        builder: (context, state) => const DailyLogFormScreen(),
      ),
      GoRoute(
        path: '/daily-logs/:dailyLogId/edit',
        builder: (context, state) =>
            DailyLogFormScreen(dailyLog: state.extra as DailyLog?),
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});
