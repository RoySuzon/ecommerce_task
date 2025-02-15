import 'package:ecommerce/core/usecase/user_case.dart';
import 'package:ecommerce/features/cart/domain/repository/cart_repository.dart';

class RemoveFromCart implements UseCase<void, String> {
  final CartRepository repository;
  RemoveFromCart(this.repository);

  @override
  Future<void> call(String productId) {
    return repository.removeFromCart(productId);
  }
}
