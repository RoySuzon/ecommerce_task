// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecommerce/features/home/data/models/product_model.dart';
class CartItem {
  int quantity;
  final Product product;
  CartItem({required this.product, this.quantity = 1});
  double get totalCost => quantity * product.price;
}
