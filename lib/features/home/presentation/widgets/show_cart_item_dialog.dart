import 'package:ecommerce/features/cart/data/models/cart_item.dart';
import 'package:flutter/material.dart';

void showCartItemDialog(BuildContext context, CartItem item) {
  showDialog(
    context: context,
    builder: (context) {
    
      return AlertDialog(
        title: Text(item.product.name ?? ""),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Quantity: ${item.quantity}"),
            Text("Price: ৳${item.product.price.toStringAsFixed(2)}"),
            Divider(),
            Text(
              "Subtotal: ৳${item.totalCost.toStringAsFixed(2)}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      );
    },
  );
}
