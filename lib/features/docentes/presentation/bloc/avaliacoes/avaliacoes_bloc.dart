import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:uerj_companion/features/docentes/data/docente_repository.dart';
import 'package:uerj_companion/features/docentes/domain/entities/avaliacao.dart';

part 'avaliacoes_event.dart';
part 'avaliacoes_state.dart';

class AvaliacoesBloc extends Bloc<AvaliacoesEvent, AvaliacoesState> {
  final _logger = Logger();
  final DocenteRepository _repository;
  final FirebaseAuth _firebaseAuth;

  AvaliacoesBloc({
    required DocenteRepository docenteRepository,
    required FirebaseAuth firebaseAuth,
  }) : _repository = docenteRepository,
       _firebaseAuth = firebaseAuth,
       super(AvaliacoesInitial()) {
    on<LoadAvaliacoes>((event, emit) async {
      emit(AvaliacoesLoading());
      try {
        final avaliacoes = await _repository.getAvaliacoes(event.docenteId);
        emit(AvaliacoesLoaded(avaliacoes: avaliacoes));
      } catch (e) {
        _logger.e(e);
        emit(AvaliacoesError(e.toString()));
      }
    });

    on<EditAvaliacao>((event, emit) {
      emit(
        AvaliacaoEditing(
          avaliacaoToEdit: event.avaliacao,
          avaliacoes: (state as AvaliacoesDataState).avaliacoes,
        ),
      );
    });

    on<CancelEditing>((event, emit) {
      emit(
        AvaliacoesLoaded(avaliacoes: (state as AvaliacoesDataState).avaliacoes),
      );
    });

    on<SetAvaliacao>((event, emit) async {
      if (event.rating == null)
        emit(
          AvaliacoesLoaded(
            avaliacoes: (state as AvaliacoesDataState).avaliacoes,
          ),
        );
      emit(AvaliacoesLoading());
      try {
        final user = _firebaseAuth.currentUser;
        if (user == null) {
          emit(AvaliacoesError('Usuário não Autenticado'));
          return;
        }

        final avaliacao = Avaliacao(
          userId: user.uid,
          nota: event.rating!,
          timestamp: Timestamp.now(),
          comentario: event.comentario,
        );
        await _repository.upsertAvaliacao(event.docenteId, avaliacao);
        add(LoadAvaliacoes(docenteId: event.docenteId));
      } catch (e) {
        _logger.e(e);
        emit(AvaliacoesError(e.toString()));
      }
    });
  }
}
