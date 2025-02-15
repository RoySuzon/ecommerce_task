import 'package:ecommerce/features/cart/bloc/cart_event.dart';
import 'package:ecommerce/features/cart/bloc/cart_state.dart';
import 'package:ecommerce/features/cart/data/models/cart_item.dart';
import 'package:ecommerce/features/cart/domain/usecases/add_to_cart.dart';
import 'package:ecommerce/features/cart/domain/usecases/get_cart_items.dart';
import 'package:ecommerce/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:ecommerce/features/cart/domain/usecases/update_cart_item_quantity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final AddToCart addToCart;
  final RemoveFromCart removeFromCart;
  final GetCartItems getCartItems;
  final UpdateCartItemQuantity updateCartItemQuantity;

  CartBloc({
    required this.addToCart,
    required this.removeFromCart,
    required this.getCartItems,
    required this.updateCartItemQuantity,
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
        add(LoadCartEvent());
      } catch (e) {
        emit(CartError(errorMessage: 'Failed to add item to cart.'));
      }
    });

    on<RemoveFromCartEvent>((event, emit) async {
      try {
        await removeFromCart(event.productId);
        add(LoadCartEvent());
      } catch (e) {
        emit(CartError(errorMessage: 'Failed to remove item from cart.'));
      }
    });

    // Handle Incrementing Item Quantity
    on<IncrementQuantityEvent>((event, emit) {
      if (state is CartLoaded) {
        final updatedCartItems = (state as CartLoaded).cartItems.map((item) {
          if (item.product.id.toString() == event.productId) {
            return item.copyWith(quantity: item.quantity + 1);
          }
          return item;
        }).toList();

        emit(CartLoaded(cartItems: updatedCartItems));
      }
    });

    on<DecrementQuantityEvent>((event, emit) {
      if (state is CartLoaded) {
        final updatedCartItems = (state as CartLoaded)
            .cartItems
            .map((item) {
              if (item.product.id.toString() == event.productId) {
                return item.copyWith(quantity: item.quantity - 1);
              }
              return item;
            })
            .where((item) => item.quantity > 0)
            .toList();

        emit(CartLoaded(cartItems: updatedCartItems)); // Emit updated state
      }
    });
  }
}
