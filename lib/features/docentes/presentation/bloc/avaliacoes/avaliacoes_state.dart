part of 'avaliacoes_bloc.dart';

sealed class AvaliacoesState extends Equatable {
  const AvaliacoesState();
  
  @override
  List<Object?> get props => [];
}

final class AvaliacoesInitial extends AvaliacoesState {}

final class AvaliacoesLoading extends AvaliacoesState {}

final class AvaliacoesLoaded extends AvaliacoesState {
  final List<Avaliacao> avaliacoes;

  const AvaliacoesLoaded(this.avaliacoes);

  @override
  List<Object?> get props => [avaliacoes];
}

final class AvaliacoesError extends AvaliacoesState {
  final String message;

  const AvaliacoesError(this.message);

  @override
  List<Object?> get props => [message];
}