import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uerj_companion/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:uerj_companion/features/auth/presentation/validating_screen.dart';
import 'package:uerj_companion/features/auth/presentation/welcome_screen.dart';
import 'package:uerj_companion/features/cursos/presentation/bloc/curso_bloc.dart';
import 'package:uerj_companion/features/docentes/presentation/bloc/docentes/docentes_bloc.dart';
import 'package:uerj_companion/features/profile/presentation/profile_page.dart';
import 'package:uerj_companion/features/profile/presentation/profile_screen.dart';
import 'package:uerj_companion/shared/config/service_locator.dart';
import 'package:uerj_companion/shared/router/cursos_routes.dart';
import 'package:uerj_companion/shared/router/docente_routes.dart';
import 'package:uerj_companion/shared/router/go_router_refresh_stream.dart';
import 'package:uerj_companion/shared/router/custom_page_transition.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: '/profile',
  navigatorKey: rootNavigatorKey,
  refreshListenable: GoRouterRefreshStream(sl<AuthBloc>().stream),
  redirect: (context, state) {
    final authState = sl<AuthBloc>().state;
    final isLoggedIn = authState is Authenticated;
    final isAuthenticating = authState is AuthValidatingLink;

    final location = state.matchedLocation;
    final isAtLogin = location == '/login';
    final isAtValidating = location == '/validating';

    if (isAuthenticating) return isAtValidating ? null : '/validating';

    if (isLoggedIn && (isAtLogin || isAtValidating)) {
      return '/profile';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const WelcomeScreen()),
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
          child: ProfileScreen(content: child),
        );
      },
      routes: [
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => CustomPageTransition(
            key: state.pageKey,
            child: const ProfilePage(),
          ),
        ),
        ...cursosRoutes,
        ...docenteRoutes,
      ],
    ),
  ],
);
