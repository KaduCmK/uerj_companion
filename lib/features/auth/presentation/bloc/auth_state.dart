part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class Unauthenticated extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthValidatingLink extends AuthState {}

final class AuthLinkSentSuccess extends AuthState {}

final class Authenticated extends AuthState {
  final User user;
  final bool onboardingCompleted;

  const Authenticated(this.user, {required this.onboardingCompleted});

  bool get isAnonymous => user.isAnonymous;
  
  @override
  List<Object> get props => [user, onboardingCompleted];
}

final class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
