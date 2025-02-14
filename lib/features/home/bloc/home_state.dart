// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/features/home/data/models/product_model.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class ProductsLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class ProductsLoaded extends HomeState {
  final List<ProductModel> products;
  const ProductsLoaded({required this.products});
  @override
  List<Object> get props => [products];
}

class ProductsFaild extends HomeState {
  final Failure failure;
  const ProductsFaild({required this.failure});
  @override
  List<Object> get props => [failure];
}
