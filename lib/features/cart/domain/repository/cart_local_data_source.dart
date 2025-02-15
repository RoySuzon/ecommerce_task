// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:ecommerce/features/cart/data/models/cart_item.dart';

abstract class CartLocalDataSource {
  Future<List<CartItem>> getCartItems();
  Future<void> addCartItem(CartItem cartItem);
  Future<void> removeCartItem(String productId);
  Future<void> updateCartItem(CartItem cartItem); // New Method
}
