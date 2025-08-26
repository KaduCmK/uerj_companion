import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:uerj_companion/features/auth/data/auth_service.dart';
import 'package:uerj_companion/shared/router/app_router.dart';

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
       super(AuthInitial()) {
    _userSubscription = _firebaseAuth.authStateChanges().listen((user) {
      _logger.i("User changed: $user");
      add(AuthenticationUserChanged(user));
    });

    on<AuthenticationUserChanged>((event, emit) async {
      if (event.user != null)
        emit(Authenticated(event.user!));
      else
        emit(Unauthenticated());
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
        emit(AuthValidatingLink());
        appRouter.refresh();

        try {
          await _authService.handleSignInLink(event.uri);
        } on FirebaseAuthException catch (e) {
          _logger.w('Falha em CheckSignInLink', error: e);
          if (_firebaseAuth.currentUser != null) {
            emit(Authenticated(_firebaseAuth.currentUser!));
          } else {
            emit(AuthError('Falha no login: ${e.message}'));
          }
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
