import 'package:ecommerce/core/usecase/user_case.dart';
import 'package:ecommerce/features/cart/data/models/cart_item.dart';
import 'package:ecommerce/features/cart/domain/repository/cart_repository.dart';

class GetCartItems implements UseCase<List<CartItem>, NoParams?> {
  final CartRepository repository;

  GetCartItems(this.repository);

  @override
  Future<List<CartItem>> call([params]) {
    return repository.getCartItems();
  }
}
