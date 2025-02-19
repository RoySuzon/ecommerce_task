import 'package:ecommerce/features/auth/bloc/auth_bloc.dart';
import 'package:ecommerce/features/auth/bloc/auth_event.dart';
import 'package:ecommerce/features/auth/bloc/auth_state.dart';
import 'package:ecommerce/features/auth/presentation/pages/login_page.dart';
import 'package:ecommerce/features/cart/cubit/cart_cubit.dart';
import 'package:ecommerce/features/cart/data/models/cart_item.dart';
import 'package:ecommerce/features/home/bloc/home_bloc.dart';
import 'package:ecommerce/features/home/bloc/home_event.dart';
import 'package:ecommerce/features/home/bloc/home_state.dart';
import 'package:ecommerce/features/home/presentation/widgets/product_view.dart';
import 'package:ecommerce/features/home/presentation/widgets/show_cart_items_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Card(
            margin: EdgeInsets.zero,
            child: CupertinoTextField(
              placeholder: "Search by product name",
              onChanged: (query) => context
                  .read<HomeBloc>()
                  .add(ProductSearchingEvent(query: query)),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Spacer(),
            BlocListener<AuthBloc, AuthState>(
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
              child: ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Logout"),
                      content: Text("Are you sure you want to log out?"),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context), // Close dialog
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () =>
                              context.read<AuthBloc>().add(AuthLogoutEvent()),
                          child: Text("Logout",
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                title: Text("Logout"),
                trailing: Icon(Icons.logout),
              ),
            ),
            SizedBox(height: kBottomNavigationBarHeight),
          ],
        ),
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        bloc: context.read<HomeBloc>()..add(ProductsEvent()),
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
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return ProductView(product: product);
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
                          Text("মোটঃ ৳${state.fold(
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
