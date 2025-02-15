import 'package:ecommerce/features/auth/bloc/auth_bloc.dart';
import 'package:ecommerce/features/auth/bloc/auth_event.dart';
import 'package:ecommerce/features/auth/bloc/auth_state.dart';
import 'package:ecommerce/features/auth/presentation/pages/login_page.dart';
import 'package:ecommerce/features/cart/bloc/cart_bloc.dart';
import 'package:ecommerce/features/cart/bloc/cart_event.dart';
import 'package:ecommerce/features/cart/bloc/cart_state.dart';
import 'package:ecommerce/features/home/bloc/home_bloc.dart';
import 'package:ecommerce/features/home/bloc/home_event.dart';
import 'package:ecommerce/features/home/bloc/home_state.dart';
import 'package:ecommerce/features/home/data/models/product_model.dart';
import 'package:ecommerce/features/home/data/repository/home_repository_imp.dart';
import 'package:ecommerce/features/home/domain/usecases/home_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RepositoryProvider<HomeBloc>(
          create:
              (context) =>
                  HomeBloc(HomeUseCase(repo: HomeRepositoryImp()))
                    ..add(ProductsEvent()),
          child: BlocConsumer<HomeBloc, HomeState>(
            // bloc: HomeBloc(HomeUseCase(repo: HomeRepositoryImp()))
            //   ..add(ProductsEvent()),
            listener: (context, state) {},
            builder: (context, state) {
              if (state is ProductsLoading) {
                return Center(child: CircularProgressIndicator.adaptive());
              } else if (state is ProductsLoaded) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return ProductTile(product: product);
                    // return ListTile(
                    //   title: Text(product.name ?? ""),
                    //   trailing: IconButton(
                    //     onPressed:
                    //         () => context.read<CartBloc>().add(
                    //           AddToCartEvent(product: product, quantity: 5),
                    //         ),
                    //     icon: Icon(Icons.add),
                    //   ),
                    //   leading: IconButton(
                    //     onPressed:
                    //         () => context.read<CartBloc>().add(
                    //           RemoveFromCartEvent(
                    //             productId: product.id.toString(),
                    //           ),
                    //         ),
                    //     icon: Icon(Icons.remove),
                    //   ),
                    // );
                  },
                  itemCount: state.products.length,
                );
              } else {
                return SizedBox();
              }
            },
          ),
        ),
      ),
      floatingActionButton: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          } else if (state is LogoutFaild) {
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    state.failure.message,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge!.copyWith(color: Colors.white),
                  ),
                  showCloseIcon: true,
                  duration: Duration(seconds: 5),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        child: FloatingActionButton(
          onPressed: () {
            context.read<AuthBloc>().add(AuthLogoutEvent());
          },
          child: Icon(Icons.logout),
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Colors.green,
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state is CartLoaded) {
                  return Text("Total Items: ${state.cartItems.length}");
                }
                return Text("Cart is empty");
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ProductTile extends StatefulWidget {
  final ProductModel product;
  const ProductTile({super.key, required this.product});

  @override
  State createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.product.name ?? ""),
        subtitle: Text("\$${widget.product.price}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                if (quantity > 1) setState(() => quantity--);
              },
            ),
            Text(quantity.toString()),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() => quantity++);
              },
            ),
            IconButton(
              icon: Icon(Icons.add_shopping_cart, color: Colors.green),
              onPressed: () {
                context.read<CartBloc>().add(
                  AddToCartEvent(product: widget.product, quantity: quantity),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${widget.product.name} added to cart!"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
