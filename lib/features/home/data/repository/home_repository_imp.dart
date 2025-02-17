import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:ecommerce/common/api_endpoint.dart';
import 'package:ecommerce/core/error/app_exception.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/core/services/http_manager.dart';
import 'package:ecommerce/features/home/data/models/product_model.dart';
import 'package:ecommerce/features/home/domain/repository/home_repository.dart';

class HomeRepositoryImp implements HomeRepository {
  final HttpManager _httpManager = HttpManager();
  @override
  Future<Either<Failure, List<ProductModel>>> products() async {
    try {
      final response = await _httpManager.request(
        HttpMethod.GET,
        ApiEndPoint.products,
      );
      if (response.statusCode == 200) {
        return Right(productFromJson(response.body));
      } else {
        return Left(Failure("Status code is ${response.statusCode}"));
      }
    } catch (e) {
      return Left(Failure(AppException.handleExceptionMessage(e)));
    }
  }
}
