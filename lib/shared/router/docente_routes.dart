import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uerj_companion/features/docentes/presentation/bloc/avaliacoes/avaliacoes_bloc.dart';
import 'package:uerj_companion/features/docentes/presentation/docente_profile_screen.dart';
import 'package:uerj_companion/features/docentes/presentation/docentes_screen.dart';
import 'package:uerj_companion/features/docentes/presentation/edit_docente_screen.dart';
import 'package:uerj_companion/shared/config/service_locator.dart';
import 'package:uerj_companion/shared/router/custom_page_transition.dart';

final docenteRoutes = [
  GoRoute(
    path: '/docentes',
    pageBuilder: (context, state) =>
        CustomPageTransition(key: state.pageKey, child: const DocentesScreen()),
  ),
  GoRoute(
    path: '/edit-docente',
    pageBuilder: (context, state) => CustomPageTransition(
      key: state.pageKey,
      child: const EditDocenteScreen(),
    ),
  ),
  GoRoute(
    path: '/docente/:id',
    pageBuilder: (context, state) {
      final docenteId = state.pathParameters['id']!;
      return CustomPageTransition(
        key: state.pageKey,
        child: BlocProvider(
          create: (context) => AvaliacoesBloc(
            docenteRepository: sl(),
            firebaseAuth: FirebaseAuth.instance,
          )..add(LoadAvaliacoes(docenteId: docenteId)),
          child: DocenteProfileScreen(docenteId: docenteId),
        ),
      );
    },
  ),
];
