import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uerj_companion/features/cursos/data/cursos_repository.dart';
import 'package:uerj_companion/features/cursos/domain/entities/curso.dart';
import 'package:uerj_companion/features/cursos/domain/entities/materia.dart';

part 'curso_event.dart';
part 'curso_state.dart';

class CursoBloc extends Bloc<CursoEvent, CursoState> {
  final CursosRepository _repository;

  CursoBloc({required CursosRepository cursosRepository})
    : _repository = cursosRepository,
      super(CursoInitial()) {
    on<LoadCursos>((event, emit) async {
      emit(CursoLoading());

      try {
        final cursos = await _repository.getCursos();
        emit(CursosLoaded(cursos: cursos));
      } catch (e) {
        emit(CursosError(message: e.toString()));
      }
    });

    on<SelectCurso>((event, emit) async {
      final currentState = state as CursosLoaded;
      emit(CursoLoading());

      try {
        final materias = await _repository.getMaterias(event.cursoId);
        emit(
          CursosLoaded(
            cursos: currentState.cursos,
            materias: materias,
            selectedCursoId: event.cursoId,
          ),
        );
      } catch (e) {
        emit(CursosError(message: e.toString()));
      }
    });
  }
}
