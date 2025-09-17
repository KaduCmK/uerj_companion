// kaducmk/uerj_companion/uerj_companion-feat-perfil-usuario/lib/shared/router/app_router.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uerj_companion/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:uerj_companion/features/auth/presentation/onboarding_screen.dart';
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
  final shellNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    initialLocation: '/',
    navigatorKey: rootNavigatorKey,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final location = state.uri.toString();

      final publicRoutes = ['/login'];

      if (authState is AuthInitial ||
          authState is AuthLoading ||
          authState is AuthLinkSentSuccess) {
        return null;
      }

      final isAuthenticated = authState is Authenticated;
      final isAnonymous = isAuthenticated && authState.isAnonymous;
      final isOnboardingComplete =
          isAuthenticated && authState.onboardingComplete;

      // 2. Usuário logado, mas não completou o onboarding
      if (!isOnboardingComplete) {
        // Permite que o usuário anônimo vá para a tela de login
        if (location == '/onboarding' ||
            (isAnonymous && location == '/login')) {
          return null;
        }
        return '/onboarding';
      }

      // 3. Usuário logado e onboarding completo
      if (publicRoutes.contains(location) || location == '/onboarding') {
        // Permite que o usuário anônimo vá para a tela de login
        if (isAnonymous && location == '/login') {
          return null;
        }
        return '/'; // Senão, redireciona para a home
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => CustomPageTransition(
          key: ValueKey(state.uri.toString()),
          child: const WelcomeScreen(),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) => CustomPageTransition(
          key: ValueKey(state.uri.toString()),
          child: BlocProvider(
            create: (context) => CursoBloc(cursosRepository: sl()),
            child: const OnboardingScreen(),
          ),
        ),
      ),
      ShellRoute(
        navigatorKey: shellNavigatorKey,
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
              key: ValueKey(state.uri.toString()),
              child: const HomePage(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => CustomPageTransition(
              key: ValueKey(state.uri.toString()),
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
            pageBuilder: (context, state) => CustomPageTransition(
              key: ValueKey(state.uri.toString()),
              child: AboutScreen(),
            ),
          ),
        ],
      ),
    ],
  );
}