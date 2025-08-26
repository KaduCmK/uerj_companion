part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class AuthenticationUserChanged extends AuthEvent {
  final User? user;

  const AuthenticationUserChanged(this.user);

  @override
  List<Object?> get props => [user];
}

final class SendSignInLink extends AuthEvent {
  final String email;

  const SendSignInLink(this.email);

  @override
  List<Object> get props => [email];
}

final class CheckSignInLink extends AuthEvent {
  final Uri uri;

  const CheckSignInLink(this.uri);

  @override
  List<Object> get props => [uri];
}
