part of 'curso_bloc.dart';

sealed class CursoState extends Equatable {
  const CursoState();

  @override
  List<Object> get props => [];
}

final class CursoInitial extends CursoState {}

final class CursoLoading extends CursoState {}

final class CursosLoaded extends CursoState {
  final List<Curso> cursos;
  final List<Materia> materias;
  final String? selectedCursoId;

  const CursosLoaded({
    required this.cursos,
    this.materias = const [],
    this.selectedCursoId,
  });

  @override
  List<Object> get props => [cursos, materias, selectedCursoId ?? ''];
}

final class CursosError extends CursoState {
  final String message;

  const CursosError({required this.message});

  @override
  List<Object> get props => [message];
}
