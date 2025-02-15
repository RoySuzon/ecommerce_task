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
