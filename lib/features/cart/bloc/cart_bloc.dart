import 'package:ecommerce/features/cart/bloc/cart_event.dart';
import 'package:ecommerce/features/cart/bloc/cart_state.dart';
import 'package:ecommerce/features/cart/data/models/cart_item.dart';
import 'package:ecommerce/features/cart/domain/usecases/add_to_cart_user_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final AddToCart addToCart;
  final RemoveFromCart removeFromCart;
  final GetCartItems getCartItems;

  CartBloc({
    required this.addToCart,
    required this.removeFromCart,
    required this.getCartItems,
  }) : super(CartInitial()) {
    on<LoadCartEvent>((event, emit) async {
      emit(CartLoading());
      try {
        final cartItems = await getCartItems();
        emit(CartLoaded(cartItems: cartItems));
      } catch (e) {
        emit(CartError(errorMessage: 'Failed to load cart items.'));
      }
    });
    on<AddToCartEvent>((event, emit) async {
      try {
        await addToCart(
          CartItem(product: event.product, quantity: event.quantity),
        );
        add(LoadCartEvent()); // Reload cart after adding item
      } catch (e) {
        emit(CartError(errorMessage: 'Failed to add item to cart.'));
      }
    });
    on<RemoveFromCartEvent>((event, emit) async {
      try {
        await removeFromCart(event.productId);
        add(LoadCartEvent()); // Reload cart after removing item
      } catch (e) {
        emit(CartError(errorMessage: 'Failed to remove item from cart.'));
      }
    });
  }
}
