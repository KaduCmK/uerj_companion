part of 'avaliacoes_bloc.dart';

sealed class AvaliacoesState extends Equatable {
  const AvaliacoesState();

  @override
  List<Object?> get props => [];
}

final class AvaliacoesInitial extends AvaliacoesState {}

final class AvaliacoesLoading extends AvaliacoesState {}

abstract class AvaliacoesDataState extends AvaliacoesState {
  final List<Avaliacao> avaliacoes;

  const AvaliacoesDataState({required this.avaliacoes});

  @override
  List<Object?> get props => [avaliacoes];
}

final class AvaliacoesLoaded extends AvaliacoesDataState {
  const AvaliacoesLoaded({required super.avaliacoes});
}

final class AvaliacaoEditing extends AvaliacoesDataState {
  final Avaliacao? avaliacaoToEdit;

  const AvaliacaoEditing({this.avaliacaoToEdit, required super.avaliacoes});

  @override
  List<Object?> get props => [avaliacaoToEdit, avaliacoes];
}

final class AvaliacoesError extends AvaliacoesState {
  final String message;

  const AvaliacoesError(this.message);

  @override
  List<Object?> get props => [message];
}
