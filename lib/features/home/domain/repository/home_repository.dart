import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/features/home/data/models/product_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Product>>> products();
}
