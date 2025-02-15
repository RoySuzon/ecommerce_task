import 'package:ecommerce/features/cart/data/models/cart_item.dart';
import 'package:equatable/equatable.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

// Initial Cart State
class CartInitial extends CartState {}

// Loading State
class CartLoading extends CartState {}

// Cart Loaded Successfully
class CartLoaded extends CartState {
  final List<CartItem> cartItems;

  const CartLoaded({required this.cartItems});

  @override
  List<Object> get props => [cartItems];
}

// Cart Operation Failed
class CartError extends CartState {
  final String errorMessage;

  const CartError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
