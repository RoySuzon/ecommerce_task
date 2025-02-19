// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/core/usecase/user_case.dart';
import 'package:ecommerce/features/home/data/models/product_model.dart';
import 'package:ecommerce/features/home/domain/repository/home_repository.dart';

class HomeUseCase implements UseCase<Either, NoParams?> {
  final HomeRepository repo;
  HomeUseCase({required this.repo});
  @override
  Future<Either<Failure, List<Product>>> call([noParams]) async =>
      await repo.products();
}
