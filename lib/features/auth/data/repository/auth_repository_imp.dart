import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:ecommerce/common/api_endpoint.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/core/services/http_manager.dart';
import 'package:ecommerce/core/services/secure_storage.dart';
import 'package:ecommerce/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImp implements AuthRepository {
  final HttpManager _httpManager = HttpManager();
  final secureStorageService = SecureStorageService();
  @override
  Future<bool> logout() async {
    final response = await _httpManager.request(
      HttpMethod.POST,
      ApiEndPoint.logOut,
    );
    try {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  @override
  Future<Either<Failure, dynamic>> login(String email, String passaword) async {
    Map<String, dynamic> body = {"email": email, "password": passaword};
    final response = await _httpManager.request(
      HttpMethod.POST,
      ApiEndPoint.loginApi,
      body: body,
    );
    if (response.statusCode == 200) {
      return Right(jsonDecode(response.body));
    } else {
      return Left(Failure(jsonDecode(response.body)['message']));
    }
  }
}
