import 'package:ecommerce/features/cart/data/models/cart_item.dart';
import 'package:ecommerce/features/home/data/models/product_model.dart';

abstract class CartRepository {
  Future<void> addToCart(ProductModel product, int quantity);
  Future<void> removeFromCart(String productId);
  Future<List<CartItem>> getCartItems();
}
