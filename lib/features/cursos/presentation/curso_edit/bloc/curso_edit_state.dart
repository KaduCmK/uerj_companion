part of 'curso_edit_bloc.dart';

enum CursoEditStatus { initial, loading, loaded, saving, success, error }

class CursoEditState extends Equatable {
  final CursoEditStatus status;
  final Curso? initialCurso;
  final String cursoNome;
  final List<Materia> materias;
  final String? errorMessage;

  const CursoEditState({
    this.status = CursoEditStatus.initial,
    this.initialCurso,
    this.cursoNome = '',
    this.materias = const [],
    this.errorMessage,
  });

  CursoEditState copyWith({
    CursoEditStatus? status,
    Curso? initialCurso,
    String? cursoNome,
    List<Materia>? materias,
    String? errorMessage,
  }) {
    return CursoEditState(
      status: status ?? this.status,
      initialCurso: initialCurso ?? this.initialCurso,
      cursoNome: cursoNome ?? this.cursoNome,
      materias: materias ?? this.materias,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, initialCurso, cursoNome, materias, errorMessage];
}