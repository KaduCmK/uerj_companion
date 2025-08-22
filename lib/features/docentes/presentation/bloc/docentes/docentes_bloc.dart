import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:uerj_companion/features/docentes/data/docente_repository.dart';
import 'package:uerj_companion/features/docentes/domain/entities/avaliacao.dart';
import 'package:uerj_companion/features/docentes/domain/entities/docente.dart';

part 'docentes_event.dart';
part 'docentes_state.dart';

class DocentesBloc extends Bloc<DocentesEvent, DocentesState> {
  final _logger = Logger();
  final DocenteRepository _repository;

  DocentesBloc({required DocenteRepository docenteRepository})
    : _repository = docenteRepository,
      super(DocentesInitial()) {
    on<GetDocentes>((event, emit) async {
      emit(DocentesLoading());

      try {
        final docentes = await _repository.getDocentes();

        emit(DocentesLoaded(docentes));
      } catch (e) {
        _logger.e(e);
        emit(DocentesError(e.toString()));
      }
    });

    on<EditDocente>((event, emit) {
      emit(DocenteEditing(event.docente));
    });

    on<SetDocente>((event, emit) async {
      final docente = (state as DocenteEditing).docente;
      emit(DocentesLoading());

      try {
        final newDocente = Docente(
          id: docente?.id,
          nome: event.nome,
          email: event.email,
        );
        await _repository.upsertDocente(newDocente);

        add(GetDocentes());
      } catch (e) {
        _logger.e(e);
        emit(DocentesError(e.toString()));
      }
    });

    on<SelectDocente>((event, emit) async {
      emit(DocentesLoading());
      try {
        final docente = await _repository.selectDocente(event.docenteId);
        emit(DocenteProfileLoaded(docente: docente, avaliacoes: []));
      } catch (e) {
        _logger.e(e);
        emit(DocentesError(e.toString()));
      }
    },);
  }
}
