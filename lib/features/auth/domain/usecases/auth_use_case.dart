// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/features/auth/domain/repository/auth_repository.dart';

class AuthUseCase {
  final AuthRepository repo;
  AuthUseCase({required this.repo});
  Future<Either<Failure, dynamic>> loginUseCase(
    String email,
    String password,
  ) async {
    return repo.login(email, password);
  }
}
