import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, dynamic>> login(String email, String password);
  Future<bool> logout();
}
