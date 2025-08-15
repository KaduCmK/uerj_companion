part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SendSignInLink extends AuthEvent {
  final String email;

  const SendSignInLink(this.email);

  @override
  List<Object> get props => [email];
}

class CheckSignInLink extends AuthEvent {
  final Uri uri;

  const CheckSignInLink(this.uri);

  @override
  List<Object> get props => [uri];
}