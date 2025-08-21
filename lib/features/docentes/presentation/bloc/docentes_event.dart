part of 'docentes_bloc.dart';

sealed class DocentesEvent extends Equatable {
  const DocentesEvent();

  @override
  List<Object> get props => [];
}

final class GetDocentes extends DocentesEvent {}
