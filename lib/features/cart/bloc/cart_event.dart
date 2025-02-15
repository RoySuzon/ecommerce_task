import 'package:ecommerce/features/home/data/models/product_model.dart';
import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

// Load Cart Items
class LoadCartEvent extends CartEvent {}

// Add Product to Cart
class AddToCartEvent extends CartEvent {
  final ProductModel product;
  final int quantity;

  const AddToCartEvent({required this.product, required this.quantity});

  @override
  List<Object> get props => [product, quantity];
}

// Remove Product from Cart
class RemoveFromCartEvent extends CartEvent {
  final String productId;

  const RemoveFromCartEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}
