import 'package:ecommerce/core/dependency_injection/dependency.dart';
import 'package:ecommerce/features/auth/bloc/auth_bloc.dart';
import 'package:ecommerce/features/auth/bloc/auth_event.dart';
import 'package:ecommerce/features/auth/bloc/auth_state.dart';
import 'package:ecommerce/features/auth/presentation/pages/login_page.dart';
import 'package:ecommerce/features/cart/cubit/cart_cubit.dart';
import 'package:ecommerce/features/cart/data/models/cart_item.dart';
import 'package:ecommerce/features/home/bloc/home_bloc.dart';
import 'package:ecommerce/features/home/bloc/home_event.dart';
import 'package:ecommerce/features/home/bloc/home_state.dart';
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
          create: (context) =>
              HomeBloc(HomeUseCase(repo: Dependency.injection()))
                ..add(ProductsEvent()),
          child: BlocConsumer<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is ProductsFaild) {
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
            builder: (context, state) {
              if (state is ProductsLoading) {
                return Center(child: CircularProgressIndicator.adaptive());
              } else if (state is ProductsLoaded) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        margin: EdgeInsets.zero,
                        child: TextField(
                          onChanged: (value) => context
                              .read<HomeBloc>()
                              .add(ProductSearchingEvent(query: value)),
                          decoration: InputDecoration(
                            fillColor: Colors.grey[200],
                            hintText: "Search",
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          final product = state.products[index];
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
                        },
                        itemCount: state.products.length,
                      ),
                    ),
                  ],
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
      bottomSheet: BlocBuilder<CartCubit, List<CartItem>>(
        builder: (context, state) {
          return state.isEmpty
              ? SizedBox()
              : Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("মোটঃ ${state.fold(
                            0.0,
                            (sum, item) => sum + item.totalCost,
                          )}"),
                          ElevatedButton(
                            onPressed: () {
                              showCartItemsDialog(context);
                            },
                            child: Text("অর্ডার করুন"),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}

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
            Text("Price: \$${item.product.price.toStringAsFixed(2)}"),
            Divider(),
            Text(
              "Subtotal: \$${item.totalCost.toStringAsFixed(2)}",
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
              height: 400,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...List.generate(state.length, (index) {
                      CartItem item = state[index];
                      return Card(
                        child: ListTile(
                          leading: IconButton(
                              onPressed: () {
                                context.read<CartCubit>().removeFromCart(item);
                              },
                              icon: Icon(Icons.delete)),
                          title: Text(
                              "${item.product.name ?? ""} ${item.quantity}x${item.product.price}"),
                          trailing: Text(
                            "Subtotal: \$${item.totalCost.toStringAsFixed(2)}",
                          ),
                          onTap: () => showCartItemDialog(context, item),
                        ),
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
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    },
  );
}
