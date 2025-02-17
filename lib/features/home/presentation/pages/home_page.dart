import 'package:collection/collection.dart';
import 'package:ecommerce/core/dependency_injection/dependency.dart';
import 'package:ecommerce/features/auth/bloc/auth_bloc.dart';
import 'package:ecommerce/features/auth/bloc/auth_event.dart';
import 'package:ecommerce/features/auth/bloc/auth_state.dart';
import 'package:ecommerce/features/auth/presentation/pages/login_page.dart';
import 'package:ecommerce/features/cart/bloc/cart_bloc.dart';
import 'package:ecommerce/features/cart/bloc/cart_event.dart';
import 'package:ecommerce/features/cart/bloc/cart_state.dart';
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
                          bool shouldListenOrBuild(
                              CartState previous, CartState current) {
                            if (previous is CartLoaded &&
                                current is CartLoaded) {
                              final prevItem =
                                  previous.cartItems.firstWhereOrNull(
                                (item) => item.product.id == product.id,
                              );
                              final currItem =
                                  current.cartItems.firstWhereOrNull(
                                (item) => item.product.id == product.id,
                              );

                              return prevItem?.quantity != currItem?.quantity ||
                                  prevItem == null ||
                                  currItem == null;
                            }
                            return false; // Ensures rebuild if state type changes
                          }

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Product Info
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "\$${product.price.toStringAsFixed(2)}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ],
                                  ),

                                  // Cart Controls (Add/Increment/Decrement)
                                  BlocConsumer<CartBloc, CartState>(
                                    listenWhen: shouldListenOrBuild,
                                    buildWhen: shouldListenOrBuild,
                                    builder: (context, state) {
                                      if (state is CartLoaded) {
                                        final cartItem =
                                            state.cartItems.firstWhere(
                                          (item) =>
                                              item.product.id == product.id,
                                          orElse: () => CartItem(
                                              product: product, quantity: 0),
                                        );

                                        return cartItem.quantity > 0
                                            ? Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      if (cartItem.quantity >
                                                          1) {
                                                        context
                                                            .read<CartBloc>()
                                                            .add(
                                                              DecrementQuantityEvent(
                                                                productId: product
                                                                    .id
                                                                    .toString(),
                                                              ),
                                                            );
                                                      } else {
                                                        context
                                                            .read<CartBloc>()
                                                            .add(
                                                              RemoveFromCartEvent(
                                                                productId: product
                                                                    .id
                                                                    .toString(),
                                                              ),
                                                            );
                                                      }
                                                    },
                                                    icon: const Icon(
                                                      Icons.remove_circle,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  Text(
                                                    cartItem.quantity
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      context
                                                          .read<CartBloc>()
                                                          .add(
                                                            IncrementQuantityEvent(
                                                              productId: product
                                                                  .id
                                                                  .toString(),
                                                            ),
                                                          );
                                                    },
                                                    icon: const Icon(
                                                      Icons.add_circle,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : ElevatedButton(
                                                onPressed: () {
                                                  context.read<CartBloc>().add(
                                                        AddToCartEvent(
                                                            product: product,
                                                            quantity: 1),
                                                      );
                                                },
                                                child: const Icon(Icons
                                                    .shopping_bag_outlined),
                                              );
                                      }
                                      return const CircularProgressIndicator();
                                    },
                                    listener: (BuildContext context,
                                        CartState state) {},
                                  ),
                                ],
                              ),
                            ),
                          );
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
            // throw NotInternetException();
          },
          child: Icon(Icons.logout),
        ),
      ),
      bottomSheet: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          switch (state) {
            case CartLoaded():
              return state.cartItems.isEmpty
                  ? SizedBox()
                  : Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        color: Colors.grey,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("মোটঃ ${state.cartItems.fold(
                                0.0,
                                (sum, item) => sum + item.totalCost,
                              )}"),
                              ElevatedButton(
                                onPressed: () {
                                  showCartItemsDialog(context, state.cartItems);
                                },
                                child: Text("অর্ডার করুন"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
            default:
              return SizedBox();
          }
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

void showCartItemsDialog(BuildContext context, List<CartItem> cartItems) {
  showDialog(
    context: context,
    builder: (context) {
      double subtotal = cartItems.fold(0.0, (sum, item) => sum + item.totalCost);
      return AlertDialog(
      content: SizedBox(
        height: 400,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ...List.generate(cartItems.length, (index) {
                CartItem item = cartItems[index];
                return Card(
                  child: ListTile(
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
}

// class ProductTile extends StatelessWidget {
//   final ProductModel product;

//   const ProductTile({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     bool shouldListenOrBuild(CartState previous, CartState current) {
//       if (previous is CartLoaded && current is CartLoaded) {
//         final prevItem = previous.cartItems.firstWhereOrNull(
//           (item) => item.product.id == product.id,
//         );
//         final currItem = current.cartItems.firstWhereOrNull(
//           (item) => item.product.id == product.id,
//         );

//         return prevItem?.quantity != currItem?.quantity ||
//             prevItem == null ||
//             currItem == null;
//       }
//       return false; // Ensures rebuild if state type changes
//     }

//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // Product Info
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   product.name ?? "",
//                   style: Theme.of(context).textTheme.titleMedium,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 Text(
//                   "\$${product.price.toStringAsFixed(2)}",
//                   style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//               ],
//             ),

//             // Cart Controls (Add/Increment/Decrement)
//             BlocConsumer<CartBloc, CartState>(
//               listenWhen: shouldListenOrBuild,
//               buildWhen: shouldListenOrBuild,
//               builder: (context, state) {
//                 if (state is CartLoaded) {
//                   final cartItem = state.cartItems.firstWhere(
//                     (item) => item.product.id == product.id,
//                     orElse: () => CartItem(product: product, quantity: 0),
//                   );

//                   return cartItem.quantity > 0
//                       ? Row(
//                           children: [
//                             IconButton(
//                               onPressed: () {
//                                 if (cartItem.quantity > 1) {
//                                   context.read<CartBloc>().add(
//                                         DecrementQuantityEvent(
//                                           productId: product.id.toString(),
//                                         ),
//                                       );
//                                 } else {
//                                   context.read<CartBloc>().add(
//                                         RemoveFromCartEvent(
//                                           productId: product.id.toString(),
//                                         ),
//                                       );
//                                 }
//                               },
//                               icon: const Icon(
//                                 Icons.remove_circle,
//                                 color: Colors.red,
//                               ),
//                             ),
//                             Text(
//                               cartItem.quantity.toString(),
//                               style: Theme.of(context).textTheme.titleMedium,
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 context.read<CartBloc>().add(
//                                       IncrementQuantityEvent(
//                                         productId: product.id.toString(),
//                                       ),
//                                     );
//                               },
//                               icon: const Icon(
//                                 Icons.add_circle,
//                                 color: Colors.green,
//                               ),
//                             ),
//                           ],
//                         )
//                       : ElevatedButton(
//                           onPressed: () {
//                             context.read<CartBloc>().add(
//                                   AddToCartEvent(product: product, quantity: 1),
//                                 );
//                           },
//                           child: const Icon(Icons.shopping_bag_outlined),
//                         );
//                 }
//                 return const CircularProgressIndicator();
//               },
//               listener: (BuildContext context, CartState state) {},
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
