// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/features/home/data/models/product_model.dart';
import 'package:ecommerce/features/home/domain/repository/home_repository.dart';

class HomeUseCase {
  final HomeRepository repo;
  HomeUseCase({required this.repo});

  Future<Either<Failure, List<ProductModel>>> callProductsUseCase() async =>
      await repo.products();
}
