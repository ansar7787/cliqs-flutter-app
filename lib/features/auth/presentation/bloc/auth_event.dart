import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  const LoginSubmitted(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class SignupSubmitted extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const SignupSubmitted(this.email, this.password, this.name);

  @override
  List<Object?> get props => [email, password, name];
}

class LogoutRequested extends AuthEvent {}
