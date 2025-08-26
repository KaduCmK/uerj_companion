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

final class EditAvaliacao extends AvaliacoesEvent {
  final Avaliacao? avaliacao;

  const EditAvaliacao({this.avaliacao});

  @override
  List<Object?> get props => [avaliacao];
}

final class CancelEditing extends AvaliacoesEvent {}

final class SetAvaliacao extends AvaliacoesEvent {
  final String docenteId;
  final int? rating;
  final String? comentario;

  const SetAvaliacao({
    required this.docenteId,
    this.rating,
    this.comentario,
  });

  @override
  List<Object?> get props => [docenteId, rating, comentario];
}
