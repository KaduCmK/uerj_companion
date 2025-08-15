import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uerj_companion/features/auth/data/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<SendSignInLink>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authService.sendSignInLink(event.email);
        emit(AuthLinkSentSuccess());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<CheckSignInLink>((event, emit) async {
      if (_authService.isSignInLink(event.uri.toString())) {
        emit(AuthValidatingLink());

        try {
          await _authService.handleSignInLink(event.uri);
          emit(AuthSuccess());
        } on FirebaseAuthException catch (e) {
          emit(AuthError('Falha no login: ${e.message}'));
        } catch (e) {
          emit(AuthError(e.toString()));
        }
      }
    });
  }
}
