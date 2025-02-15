// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:ecommerce/features/cart/data/models/cart_item.dart';
import 'package:ecommerce/features/cart/domain/repository/cart_local_data_source.dart';

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final List<CartItem> _cart = [];

  @override
  Future<List<CartItem>> getCartItems() async {
    return _cart;
  }

  @override
  Future<void> addCartItem(CartItem cartItem) async {
    _cart.add(cartItem);
  }

  @override
  Future<void> removeCartItem(String productId) async {
    _cart.removeWhere((item) => item.product.id.toString() == productId);
  }

  @override
  Future<void> updateCartItem(CartItem cartItem) async {
    int index = _cart.indexWhere(
      (item) => item.product.id == cartItem.product.id,
    );
    if (index != -1) {
      _cart[index] = cartItem;
    }
  }
}
