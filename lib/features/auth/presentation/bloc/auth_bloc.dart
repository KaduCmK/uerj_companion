import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:uerj_companion/features/auth/data/auth_service.dart';
import 'package:uerj_companion/features/cursos/domain/entities/curso.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _logger = Logger();
  final AuthService _authService;
  final FirebaseAuth _firebaseAuth;
  late final StreamSubscription<User?> _userSubscription;

  AuthBloc({
    required AuthService authService,
    required FirebaseAuth firebaseAuth,
  }) : _authService = authService,
       _firebaseAuth = firebaseAuth,
       super(Unauthenticated()) {
    _userSubscription = _firebaseAuth.authStateChanges().listen((user) {
      _logger.i("User changed: $user");
      add(AuthenticationUserChanged(user));
    });

    on<AuthenticationUserChanged>((event, emit) async {
      if (event.user != null) {
        final userDoc = await _authService.getUserDocument();
        final onboardingComplete =
            userDoc.exists && (userDoc.data()?['onboardingCompleted'] ?? false);

        emit(
          Authenticated(event.user!, onboardingCompleted: onboardingComplete),
        );
      } else
        emit(Unauthenticated());
      _logger.i(state);
    });

    on<SignInAnonymously>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authService.signInAnonymously();
      } catch (e) {
        _logger.e(e);
        emit(AuthError(e.toString()));
      }
    });

    on<CompleteOnboarding>((event, emit) async {
      emit(AuthLoading());
      try {
        final userDoc = await _authService.getUserDocument();
        await userDoc.reference.update({'onboardingCompleted': true});
        emit(
          Authenticated(_authService.currentUser!, onboardingCompleted: true),
        );
      } catch (e) {
        _logger.e(e);
        emit(AuthError(e.toString()));
      }
    });

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
        if (_authService.currentUser != null) {
          _logger.i('Usuario já autenticado, ignorando o link de login');

          if (state is Authenticated)
            emit(
              Authenticated(
                _authService.currentUser!,
                onboardingCompleted:
                    (state as Authenticated).onboardingCompleted,
              ),
            );
          return;
        }

        emit(AuthValidatingLink());
        try {
          await _authService.handleSignInLink(event.uri);
        } on FirebaseAuthException catch (e) {
          _logger.e('Falha em CheckSignInLink', error: e);
          emit(AuthError('Falha no login: ${e.message}'));
          emit(Unauthenticated());
        } catch (e) {
          _logger.e(e);
          emit(AuthError(e.toString()));
        }
      }
    });
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
