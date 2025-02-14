// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:ecommerce/core/error/failure.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class LoginLoading extends AuthState {
  @override
  List<Object> get props => [];
}

class LoginSuccess extends AuthState {
 final  String message;
  const LoginSuccess({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class LoginFailed extends AuthState {
  final Failure failure;
  const LoginFailed({required this.failure});
  @override
  List<Object> get props => [failure];
}
