// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecommerce/features/cart/data/models/cart_item.dart';
import 'package:ecommerce/features/cart/domain/repository/cart_repository.dart';
import 'package:ecommerce/features/home/data/models/product_model.dart';

class CartRepositoryImpl implements CartRepository {
  CartLocalDataSource localDataSource;
  CartRepositoryImpl(this.localDataSource);
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

  @override
  Future<void> updateCartItemQuantity(CartItem cartItem) async {
    return localDataSource.updateCartItem(cartItem);
  }
}


abstract class CartLocalDataSource {
  Future<List<CartItem>> getCartItems();
  Future<void> addCartItem(CartItem cartItem);
  Future<void> removeCartItem(String productId);
  Future<void> updateCartItem(CartItem cartItem); // New Method
}

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
