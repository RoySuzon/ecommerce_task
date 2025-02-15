import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/features/home/data/models/product_model.dart';
import 'package:ecommerce/features/home/data/repository/home_repository_imp.dart';
import 'package:ecommerce/features/home/domain/repository/home_repository.dart';

class HomeRepositoryMock implements HomeRepository {
  @override
  Future<Either<Failure, List<ProductModel>>> products() async {
    await Future.delayed(Duration(seconds: 5));

    return Right(productFromJson(jsonEncode(data)));
  }
}
