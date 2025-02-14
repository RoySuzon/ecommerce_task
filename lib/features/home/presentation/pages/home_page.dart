import 'package:ecommerce/features/auth/bloc/auth_bloc.dart';
import 'package:ecommerce/features/auth/bloc/auth_event.dart';
import 'package:ecommerce/features/auth/bloc/auth_state.dart';
import 'package:ecommerce/features/auth/presentation/pages/login_page.dart';
import 'package:ecommerce/features/home/bloc/home_bloc.dart';
import 'package:ecommerce/features/home/bloc/home_event.dart';
import 'package:ecommerce/features/home/bloc/home_state.dart';
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
                    return ListTile(title: Text(product.name ?? ""));
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
    );
  }
}
