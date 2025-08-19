part of 'curso_edit_bloc.dart';

abstract class CursoEditEvent extends Equatable {
  const CursoEditEvent();

  @override
  List<Object?> get props => [];
}

class LoadCursoToEdit extends CursoEditEvent {
  final Curso? curso;

  const LoadCursoToEdit(this.curso);

  @override
  List<Object?> get props => [curso];
}

class UpdateCursoName extends CursoEditEvent {
  final String name;

  const UpdateCursoName(this.name);

  @override
  List<Object> get props => [name];
}

class AddMateria extends CursoEditEvent {
  final Materia materia;

  const AddMateria(this.materia);

  @override
  List<Object> get props => [materia];
}

class RemoveMateria extends CursoEditEvent {
  final Materia materia;

  const RemoveMateria(this.materia);

  @override
  List<Object> get props => [materia];
}

class SaveCurso extends CursoEditEvent {}