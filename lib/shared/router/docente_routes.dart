import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uerj_companion/features/docentes/presentation/bloc/docentes_bloc.dart';
import 'package:uerj_companion/features/docentes/presentation/docente_profile_screen.dart';
import 'package:uerj_companion/features/docentes/presentation/docentes_screen.dart';
import 'package:uerj_companion/features/docentes/presentation/edit_docente_screen.dart';
import 'package:uerj_companion/shared/config/service_locator.dart';

final docenteRoutes = ShellRoute(
  builder: (context, state, child) {
    return BlocProvider(
      create: (context) =>
          DocentesBloc(docenteRepository: sl())..add(GetDocentes()),
      child: child,
    );
  },
  routes: [
    GoRoute(
      path: '/docentes',
      builder: (context, state) => const DocentesScreen(),
    ),
    GoRoute(
      path: '/edit-docente',
      builder: (context, state) => const EditDocenteScreen(),
    ),
    GoRoute(
      path: '/docente/:id',
      builder: (context, state) {
        final docenteId = state.pathParameters['id']!;
        return DocenteProfileScreen(docenteId: docenteId);
      },
    ),
  ],
);
