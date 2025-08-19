import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uerj_companion/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:uerj_companion/features/auth/presentation/validating_screen.dart';
import 'package:uerj_companion/features/auth/presentation/welcome_screen.dart';
import 'package:uerj_companion/features/home/home_screen.dart';
import 'package:uerj_companion/features/profile/presentation/profile_screen.dart';
import 'package:uerj_companion/shared/config/service_locator.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final appRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: rootNavigatorKey,
  refreshListenable: GoRouterRefreshStream(sl<AuthBloc>().stream),
  redirect: (context, state) {
    final authBloc = sl<AuthBloc>();
    final user = FirebaseAuth.instance.currentUser;

    final isLoggedIn = user != null;
    final isAuthenticating = authBloc.state is AuthValidatingLink;

    final location = state.matchedLocation;
    final isAtLogin = location == '/login';
    final isAtValidating = location == '/validating';

    // Se estiver validando, manda pra tela de validação
    if (isAuthenticating) {
      return isAtValidating ? null : '/validating';
    }

    // Se NÃO estiver logado e NÃO estiver na tela de login, manda pra landing page
    if (!isLoggedIn && !isAtLogin) {
      return '/';
    }

    // Se estiver logado e na tela de login ou validação, manda pra home
    if (isLoggedIn && (isAtLogin || isAtValidating)) {
      return '/profile';
    }

    // Em qualquer outro caso, não faz nada
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomeScreen()),
    GoRoute(path: '/login', builder: (context, state) => const WelcomeScreen()),
    GoRoute(
      path: '/validating',
      builder: (context, state) => const ValidatingScreen(),
    ),

    GoRoute(path: '/profile', builder: (context, state) => ProfileScreen()),
  ],
);
