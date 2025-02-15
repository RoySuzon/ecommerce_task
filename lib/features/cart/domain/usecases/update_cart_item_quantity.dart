import 'package:ecommerce/features/cart/data/models/cart_item.dart';
import 'package:ecommerce/features/cart/domain/repository/cart_repository.dart';

class UpdateCartItemQuantity {
  final CartRepository repository;

  UpdateCartItemQuantity({required this.repository});

  Future<void> call(CartItem cartItem) async {
    return repository.updateCartItemQuantity(cartItem);
  }
}
