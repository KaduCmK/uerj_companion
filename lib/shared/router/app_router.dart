import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uerj_companion/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:uerj_companion/features/auth/presentation/onboarding_screen.dart';
import 'package:uerj_companion/features/auth/presentation/validating_screen.dart';
import 'package:uerj_companion/features/auth/presentation/welcome_screen.dart';
import 'package:uerj_companion/features/cursos/presentation/bloc/curso_bloc.dart';
import 'package:uerj_companion/features/docentes/presentation/bloc/docentes/docentes_bloc.dart';
import 'package:uerj_companion/features/home/presentation/home_page.dart';
import 'package:uerj_companion/features/home/presentation/main_screen.dart';
import 'package:uerj_companion/features/sobre/presentation/about_screen.dart';
import 'package:uerj_companion/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:uerj_companion/features/profile/presentation/profile_screen.dart';
import 'package:uerj_companion/shared/config/service_locator.dart';
import 'package:uerj_companion/shared/router/cursos_routes.dart';
import 'package:uerj_companion/shared/router/docente_routes.dart';
import 'package:uerj_companion/shared/router/custom_page_transition.dart';
import 'package:uerj_companion/shared/router/go_router_refresh_stream.dart';

GoRouter createAppRouter(AuthBloc authBloc) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    initialLocation: '/',
    navigatorKey: rootNavigatorKey,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final location = state.uri.toString();

      final publicRoutes = ['/login', '/validating', '/onboarding'];

      if (authState is AuthInitial) {
        // Enquanto o estado de auth não é determinado, não faça nada.
        // O ideal é ter uma splash screen, mas por enquanto isso evita o redirect prematuro.
        return null;
      }

      final isAuthenticated = authState is Authenticated;
      final isOnboardingComplete =
          isAuthenticated && authState.onboardingCompleted;

      // Se o usuário está logado e já completou o onboarding
      if (isAuthenticated && isOnboardingComplete) {
        // Se ele tentar acessar uma rota pública (onboarding/login), redirecione para home
        if (publicRoutes.contains(location)) {
          return '/';
        }
        return null;
      }

      // Se o usuário está logado mas NÃO completou o onboarding
      if (isAuthenticated && !isOnboardingComplete) {
        // Garanta que ele esteja na tela de onboarding
        if (location != '/onboarding') {
          return '/onboarding';
        }
        return null;
      }

      // Se o usuário NÃO está logado
      if (!isAuthenticated) {
        // Permite acesso às rotas públicas, senão redireciona para a tela de login/onboarding
        if (publicRoutes.contains(location)) {
          return null;
        }
        // A lógica original envia para o onboarding para o login anônimo.
        return '/onboarding';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => BlocProvider(
          create: (context) => CursoBloc(cursosRepository: sl()),
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/validating',
        builder: (context, state) => const ValidatingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<DocentesBloc>(
                create: (context) =>
                    DocentesBloc(docenteRepository: sl())..add(GetDocentes()),
              ),
              BlocProvider<CursoBloc>(
                create: (context) =>
                    CursoBloc(cursosRepository: sl())..add(LoadCursos()),
              ),
            ],
            child: MainScreen(content: child),
          );
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => CustomPageTransition(
              key: state.pageKey,
              child: const HomePage(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => CustomPageTransition(
              key: state.pageKey,
              child: BlocProvider(
                create: (context) => ProfileBloc(
                  userRepository: sl(),
                  firebaseAuth: FirebaseAuth.instance,
                )..add(LoadUserProfile()),
                child: const ProfileScreen(),
              ),
            ),
          ),
          ...cursosRoutes,
          ...docenteRoutes,
          GoRoute(
            path: '/about',
            pageBuilder: (context, state) =>
                CustomPageTransition(key: state.pageKey, child: AboutScreen()),
          ),
        ],
      ),
    ],
  );
}
