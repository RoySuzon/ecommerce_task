import 'package:ecommerce/features/cart/cubit/cart_cubit.dart';
import 'package:ecommerce/features/cart/data/models/cart_item.dart';
import 'package:ecommerce/features/home/presentation/widgets/show_cart_item_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showCartItemsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return BlocBuilder<CartCubit, List<CartItem>>(
        builder: (context, state) {
          double subtotal =
              state.fold(0.0, (sum, item) => sum + item.totalCost);
          return AlertDialog(
            content: SizedBox(
              height: 300,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...List.generate(state.length, (index) {
                      CartItem item = state[index];
                      return ListTile(
                        trailing: InkWell(
                          onTap: () {
                            context.read<CartCubit>().removeFromCart(item);
                            if (state.isEmpty) {
                              Navigator.pop(context);
                            }
                          },
                          child: Icon(Icons.delete),
                        ),
                        title: Text(
                            "${item.product.name ?? ""} ${item.quantity}x ৳${item.product.price}"),
                        subtitle: Text(
                          "Subtotal: ৳${item.totalCost.toStringAsFixed(2)}",
                        ),
                        onTap: () => showCartItemDialog(context, item),
                      );
                    }),
                  ],
                ),
              ),
            ),
            actions: [
              Text('Subtotal: ${subtotal.toStringAsFixed(2)}'),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text('Order placed successfully'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 5),
                      ),
                    );
                  context.read<CartCubit>().clearCart();
                  Navigator.pop(context);
                },
                child: Text('Order Now'),
              ),
            ],
          );
        },
      );
    },
  );
}
