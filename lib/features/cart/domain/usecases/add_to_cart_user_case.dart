import 'package:ecommerce/core/usecase/user_case.dart';
import 'package:ecommerce/features/cart/data/models/cart_item.dart';
import 'package:ecommerce/features/cart/domain/repository/cart_repository.dart';

class AddToCart implements UseCase<void, CartItem> {
  final CartRepository repository;
  AddToCart(this.repository);

  @override
  Future<void> call(CartItem params) {
    return repository.addToCart(params.product, params.quantity);
  }
}

class GetCartItems implements UseCase<List<CartItem>, NoParams?> {
  final CartRepository repository;

  GetCartItems(this.repository);

  @override
  Future<List<CartItem>> call([params]) {
    return repository.getCartItems();
  }
}

class RemoveFromCart implements UseCase<void, String> {
  final CartRepository repository;
  RemoveFromCart(this.repository);

  @override
  Future<void> call(String productId) {
    return repository.removeFromCart(productId);
  }
}
