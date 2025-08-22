part of 'docentes_bloc.dart';

sealed class DocentesEvent extends Equatable {
  const DocentesEvent();

  @override
  List<Object?> get props => [];
}

final class GetDocentes extends DocentesEvent {}

final class EditDocente extends DocentesEvent {
  final Docente? docente;

  const EditDocente({this.docente});

  @override
  List<Object?> get props => [docente];
}

final class SetDocente extends DocentesEvent {
  final String nome;
  final String email;

  const SetDocente({required this.nome, required this.email});

  @override
  List<Object?> get props => [nome, email];
}
