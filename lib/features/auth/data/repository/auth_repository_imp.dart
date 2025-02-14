import 'package:dartz/dartz.dart';
import 'package:ecommerce/common/api_endpoint.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/core/services/http_manager.dart';
import 'package:ecommerce/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImp implements AuthRepository {
  final HttpManager _httpManager = HttpManager();
  @override
  Future<bool> logOut(String token) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, dynamic>> login(String email, String passaword) async {
    final response = await _httpManager.request(
      HttpMethod.POST,
      ApiEndPoint.loginApi,
    );

    if (response.statusCode == 200) {
      return Right(response.body);
    } else {
      return Left(Failure('Something is going wrong!'));
    }
  }
}
