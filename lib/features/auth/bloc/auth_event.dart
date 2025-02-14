// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String passaword;
  const AuthLoginEvent({required this.email, required this.passaword});
  @override
  List<Object> get props => [email, passaword];
}

class AuthLogoutEvent extends AuthEvent {
  final String token;
  const AuthLogoutEvent({required this.token});
  @override
  List<Object> get props => [token];
}
