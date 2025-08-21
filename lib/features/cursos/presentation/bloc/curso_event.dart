part of 'curso_bloc.dart';

sealed class CursoEvent extends Equatable {
  const CursoEvent();

  @override
  List<Object> get props => [];
}

class LoadCursos extends CursoEvent {}

class SelectCurso extends CursoEvent {
  final String cursoId;
  
  const SelectCurso(this.cursoId);

  @override
  List<Object> get props => [cursoId];
}
