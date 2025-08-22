part of 'docentes_bloc.dart';

sealed class DocentesState extends Equatable {
  const DocentesState();

  @override
  List<Object?> get props => [];
}

final class DocentesInitial extends DocentesState {}
  
final class DocentesLoading extends DocentesState {}

final class DocentesLoaded extends DocentesState {
  final List<Docente> docentes;

  const DocentesLoaded(this.docentes);

  @override
  List<Object?> get props => [docentes];
}

final class DocenteEditing extends DocentesState {
  final Docente docente;

  const DocenteEditing(this.docente);

  @override
  List<Object?> get props => [docente];
}

final class DocentesError extends DocentesState {
  final String message;

  const DocentesError(this.message);

  @override
  List<Object?> get props => [message];
}