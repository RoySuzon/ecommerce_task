// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecommerce/features/home/data/models/product_model.dart';

class CartItem {
  int quantity;
  final ProductModel product;
  CartItem({required this.quantity, required this.product});
  double get totalCost => quantity * product.price;

  CartItem copyWith({int? quantity, ProductModel? product}) {
    return CartItem(
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
    );
  }
}
