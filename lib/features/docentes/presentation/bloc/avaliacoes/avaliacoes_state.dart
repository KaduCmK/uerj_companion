part of 'avaliacoes_bloc.dart';

sealed class AvaliacoesState extends Equatable {
  const AvaliacoesState();
  
  @override
  List<Object> get props => [];
}

final class AvaliacoesInitial extends AvaliacoesState {}
