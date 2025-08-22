import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'avaliacoes_event.dart';
part 'avaliacoes_state.dart';

class AvaliacoesBloc extends Bloc<AvaliacoesEvent, AvaliacoesState> {
  AvaliacoesBloc() : super(AvaliacoesInitial()) {
    on<AvaliacoesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
