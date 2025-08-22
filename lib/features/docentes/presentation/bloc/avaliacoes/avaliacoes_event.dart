part of 'avaliacoes_bloc.dart';

sealed class AvaliacoesEvent extends Equatable {
  const AvaliacoesEvent();

  @override
  List<Object?> get props => [];
}

final class LoadAvaliacoes extends AvaliacoesEvent {
  final String docenteId;

  const LoadAvaliacoes({required this.docenteId});

  @override
  List<Object?> get props => [docenteId];
}

final class AddAvaliacao extends AvaliacoesEvent {
  final String docenteId;
  final int rating;
  final String? comentario;

  const AddAvaliacao({
    required this.docenteId,
    required this.rating,
    this.comentario,
  });

  @override
  List<Object?> get props => [docenteId, rating, comentario];
}
