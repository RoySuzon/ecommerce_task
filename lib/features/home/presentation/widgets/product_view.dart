import 'package:ecommerce/features/cart/cubit/cart_cubit.dart';
import 'package:ecommerce/features/cart/data/models/cart_item.dart';
import 'package:ecommerce/features/home/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductView extends StatelessWidget {
  const ProductView({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, List<CartItem>>(
      builder: (context, cartItems) {
        int quantity = context
            .read<CartCubit>()
            .getQuantity(product);
        TextEditingController controller =
            TextEditingController(
                text: quantity.toString());
    
        return ListTile(
          title: Text(product.name ?? ""),
          subtitle: Text(
              "৳${product.price.toStringAsFixed(2)}"),
          trailing: quantity == 0
              ? IconButton(
                  icon: Icon(Icons.add_shopping_cart,
                      color: Colors.green),
                  onPressed: () => context
                      .read<CartCubit>()
                      .addToCart(product),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle,
                          color: Colors.red),
                      onPressed: () => context
                          .read<CartCubit>()
                          .updateQuantity(
                              CartItem(
                                  product: product,
                                  quantity: quantity - 1),
                              quantity - 1),
                    ),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        controller: controller,
                        keyboardType:
                            TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(
                                  vertical: 4),
                        ),
                        onChanged: (value) {
                          int newQuantity =
                              int.tryParse(value) ??
                                  quantity;
                          context
                              .read<CartCubit>()
                              .updateQuantity(
                                  CartItem(
                                      product: product,
                                      quantity:
                                          newQuantity),
                                  newQuantity);
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle,
                          color: Colors.green),
                      onPressed: () => context
                          .read<CartCubit>()
                          .updateQuantity(
                              CartItem(
                                  product: product,
                                  quantity: quantity + 1),
                              quantity + 1),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
