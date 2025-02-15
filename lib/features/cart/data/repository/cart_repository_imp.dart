import 'package:ecommerce/features/cart/data/models/cart_item.dart';
import 'package:ecommerce/features/cart/domain/repository/cart_repository.dart';
import 'package:ecommerce/features/home/data/models/product_model.dart';

class CartRepositoryImpl implements CartRepository {
  final List<CartItem> _cart = [];

  @override
  Future<void> addToCart(ProductModel product, int quantity) async {
    final index = _cart.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      _cart[index] = _cart[index].copyWith(
        quantity: _cart[index].quantity + quantity,
      );
    } else {
      _cart.add(CartItem(product: product, quantity: quantity));
    }
  }

  @override
  Future<void> removeFromCart(String productId) async {
    _cart.removeWhere((item) => item.product.id.toString() == productId);
  }

  @override
  Future<List<CartItem>> getCartItems() async {
    return _cart;
  }
}

class CartRepositoryMock implements CartRepository {
  final List<CartItem> _cart = [
    CartItem(quantity: 2, product: ProductModel(categoryId: 11, name: "akddk")),
  ];

  @override
  Future<void> addToCart(ProductModel product, int quantity) async {
    final index = _cart.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      _cart[index] = _cart[index].copyWith(
        quantity: _cart[index].quantity + quantity,
      );
    } else {
      _cart.add(CartItem(product: product, quantity: quantity));
    }
  }

  @override
  Future<void> removeFromCart(String productId) async {
    _cart.removeWhere((item) => item.product.id.toString() == productId);
  }

  @override
  Future<List<CartItem>> getCartItems() async {
    return _cart;
  }
}
