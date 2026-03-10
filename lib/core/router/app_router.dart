import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/tasks/presentation/pages/home_page.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../injection_container.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(sl<AuthBloc>().stream),
    routes: [
      GoRoute(
        path: '/splash',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SplashPage(),
      ),
      // Auth Shell
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Container(
                  key: const ValueKey('auth_background'),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    gradient: RadialGradient(
                      center: Alignment(-0.8, -0.6),
                      radius: 1.2,
                      colors: [Color(0xFFECFDF5), Colors.white],
                    ),
                  ),
                ),
                child,
              ],
            ),
          );
        },
        routes: [
          GoRoute(
            path: '/login',
            pageBuilder: (context, state) =>
                NoTransitionPage(key: state.pageKey, child: const LoginPage()),
          ),
          GoRoute(
            path: '/signup',
            pageBuilder: (context, state) =>
                NoTransitionPage(key: state.pageKey, child: const SignupPage()),
          ),
          GoRoute(
            path: '/forgot-password',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ForgotPasswordPage(),
            ),
          ),
        ],
      ),
      // Home Route
      GoRoute(
        path: '/',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const HomePage(),
      ),
    ],
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;
      final matchedLocation = state.matchedLocation;

      final isAuthRoute =
          matchedLocation == '/login' ||
          matchedLocation == '/signup' ||
          matchedLocation == '/forgot-password';

      final isSplash = matchedLocation == '/splash';

      if (authState.status == AuthStatus.authenticated) {
        if (isAuthRoute || isSplash) return '/';
        return null;
      }

      if (authState.status == AuthStatus.unauthenticated) {
        if (isSplash) return null;
        if (!isAuthRoute) return '/login';
      }

      return null;
    },
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
