import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uerj_companion/features/auth/presentation/validating_screen.dart';
import 'package:uerj_companion/features/auth/presentation/welcome_screen.dart';
import 'package:uerj_companion/features/cursos/presentation/bloc/curso_bloc.dart';
import 'package:uerj_companion/features/docentes/presentation/bloc/docentes/docentes_bloc.dart';
import 'package:uerj_companion/features/home/presentation/home_page.dart';
import 'package:uerj_companion/features/home/presentation/main_screen.dart';
import 'package:uerj_companion/features/sobre/presentation/about_screen.dart';
import 'package:uerj_companion/shared/config/service_locator.dart';
import 'package:uerj_companion/shared/router/cursos_routes.dart';
import 'package:uerj_companion/shared/router/docente_routes.dart';
import 'package:uerj_companion/shared/router/custom_page_transition.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: rootNavigatorKey,
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
          child: MainScreen(content: child),
        );
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) =>
              CustomPageTransition(key: state.pageKey, child: const HomePage()),
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
