import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uerj_companion/features/cursos/domain/entities/curso.dart';
import 'package:uerj_companion/features/cursos/presentation/curso_edit/bloc/curso_edit_bloc.dart';
import 'package:uerj_companion/features/cursos/presentation/curso_edit/curso_edit_screen.dart';
import 'package:uerj_companion/features/cursos/presentation/cursos_screen.dart';
import 'package:uerj_companion/shared/config/service_locator.dart';
import 'package:uerj_companion/shared/router/custom_page_transition.dart';

final cursosRoutes = [
  GoRoute(
    path: '/info-cursos',
    pageBuilder: (context, state) =>
        CustomPageTransition(key: state.pageKey, child: CursosScreen()),
  ),
  GoRoute(
    path: '/edit-curso',
    pageBuilder: (context, state) {
      final curso = state.extra as Curso?;
      return CustomPageTransition(
        key: state.pageKey,
        child: BlocProvider(
          create: (context) =>
              CursoEditBloc(cursosRepository: sl(), cursoToEdit: curso)
                ..add(LoadCursoToEdit(curso)),
          child: CursoEditScreen(),
        ),
      );
    },
  ),
];
