import 'package:ecommerce/features/cart/data/models/cart_item.dart';
import 'package:ecommerce/features/home/data/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<List<CartItem>> {
  CartCubit() : super([]);

  void addToCart(Product product) {
    final existingItem = state.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: Product()),
    );

    if (existingItem.product.id.isNotEmpty) {
      updateQuantity(existingItem, existingItem.quantity + 1);
    } else {
      emit([...state, CartItem(product: product)]);
    }
  }

  void updateQuantity(CartItem cartItem, int newQuantity) {
    if (newQuantity <= 0) {
      emit(state
          .where((item) => item.product.id != cartItem.product.id)
          .toList());
    } else {
      final updatedCart = state.map((item) {
        return item.product.id == cartItem.product.id
            ? CartItem(product: item.product, quantity: newQuantity)
            : item;
      }).toList();
      emit(updatedCart);
    }
  }

  void removeFromCart(CartItem cartItem) {
    emit(
        state.where((item) => item.product.id != cartItem.product.id).toList());
  }

  int getQuantity(Product product) {
    final existingItem = state.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: Product(), quantity: 0),
    );
    return existingItem.quantity;
  }

  double getTotalPrice() {
    return state.fold(
        0, (total, item) => total + (item.product.price * item.quantity));
  }

  void clearCart() {
    emit([]);
  }
}

class CartState {}
