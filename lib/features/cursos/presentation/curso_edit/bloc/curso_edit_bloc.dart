import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uerj_companion/features/cursos/data/cursos_repository.dart';
import 'package:uerj_companion/features/cursos/domain/entities/curso.dart';
import 'package:uerj_companion/features/cursos/domain/entities/materia.dart';

part 'curso_edit_event.dart';
part 'curso_edit_state.dart';

class CursoEditBloc extends Bloc<CursoEditEvent, CursoEditState> {
  final CursosRepository _repository;

  CursoEditBloc({required CursosRepository cursosRepository})
    : _repository = cursosRepository,
      super(const CursoEditState()) {
    on<LoadCursoToEdit>(_onLoadCursoToEdit);
    on<UpdateCursoName>(_onUpdateCursoName);
    on<AddMateria>(_onAddMateria);
    on<RemoveMateria>(_onRemoveMateria);
    on<SaveCurso>(_onSaveCurso);
  }

  Future<void> _onLoadCursoToEdit(
    LoadCursoToEdit event,
    Emitter<CursoEditState> emit,
  ) async {
    emit(state.copyWith(status: CursoEditStatus.loading));
    try {
      if (event.curso != null) {
        final materias = await _repository.getMaterias(event.curso!.id!);
        emit(
          state.copyWith(
            status: CursoEditStatus.loaded,
            initialCurso: event.curso,
            cursoNome: event.curso!.nome,
            materias: materias,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: CursoEditStatus.loaded,
            initialCurso: null,
            cursoNome: '',
            materias: [],
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: CursoEditStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onUpdateCursoName(UpdateCursoName event, Emitter<CursoEditState> emit) {
    emit(state.copyWith(cursoNome: event.name));
  }

  void _onAddMateria(AddMateria event, Emitter<CursoEditState> emit) {
    final updatedMaterias = List<Materia>.from(state.materias)
      ..add(event.materia);
    emit(state.copyWith(materias: updatedMaterias));
  }

  void _onRemoveMateria(RemoveMateria event, Emitter<CursoEditState> emit) {
    final updatedMaterias = List<Materia>.from(state.materias)
      ..remove(event.materia);
    emit(state.copyWith(materias: updatedMaterias));
  }

  Future<void> _onSaveCurso(
    SaveCurso event,
    Emitter<CursoEditState> emit,
  ) async {
    emit(state.copyWith(status: CursoEditStatus.saving));
    try {
      final curso = Curso(id: state.initialCurso!.id, nome: state.cursoNome);
      await _repository.saveCurso(curso, state.materias);
      emit(state.copyWith(status: CursoEditStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: CursoEditStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
