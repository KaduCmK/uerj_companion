import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uerj_companion/features/cursos/domain/entities/curso.dart';
import 'package:uerj_companion/features/cursos/presentation/bloc/curso_bloc.dart';
import 'package:uerj_companion/features/cursos/presentation/curso_edit/bloc/curso_edit_bloc.dart';
import 'package:uerj_companion/features/cursos/presentation/curso_edit/curso_edit_screen.dart';
import 'package:uerj_companion/features/cursos/presentation/cursos_screen.dart';
import 'package:uerj_companion/shared/config/service_locator.dart';

final cursosRoutes = [
  GoRoute(
      path: '/info-cursos',
      builder: (context, state) => BlocProvider(
        create: (_) => CursoBloc(cursosRepository: sl())..add(LoadCursos()),
        child: CursosScreen(),
      ),
    ),
    GoRoute(
      path: '/edit-curso',
      builder: (context, state) {
        final curso = state.extra as Curso?;
        return BlocProvider(
          create: (context) =>
              CursoEditBloc(cursosRepository: sl(), cursoToEdit: curso)
                ..add(LoadCursoToEdit(curso)),
          child: CursoEditScreen(),
        );
      },
    ),
];