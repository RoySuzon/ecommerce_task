import 'package:ecommerce/core/services/secure_storage.dart';
import 'package:ecommerce/features/auth/bloc/auth_bloc.dart';
import 'package:ecommerce/features/auth/data/repository/auth_repository_imp.dart';
import 'package:ecommerce/features/auth/domain/usecases/auth_use_case.dart';
import 'package:ecommerce/features/auth/presentation/pages/login_page.dart';
import 'package:ecommerce/features/cart/bloc/cart_bloc.dart';
import 'package:ecommerce/features/cart/bloc/cart_event.dart';
import 'package:ecommerce/features/cart/data/repository/cart_repository_imp.dart';
import 'package:ecommerce/features/cart/domain/usecases/add_to_cart_user_case.dart';
import 'package:ecommerce/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SecureStorageService secureStorageService = SecureStorageService();
  // final cartRepository = CartRepositoryImpl();
  final cartRepository = CartRepositoryMock();
  final authRepo = AuthRepositoryImp();
  final useCase = AuthUseCase(repo: authRepo);
  final String? token = await secureStorageService.getToken();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => AuthBloc(
                useCase: useCase,
                secureStorageService: secureStorageService,
              ),
        ),
         BlocProvider(
          create: (context) => CartBloc(
            addToCart: AddToCart(cartRepository),
            removeFromCart: RemoveFromCart(cartRepository),
            getCartItems: GetCartItems(cartRepository),
          )..add(LoadCartEvent()),
        ),
        // BlocProvider(
        //   create: (context) => HomeBloc(HomeUseCase(repo: HomeRepositoryImp())),
        // ),
      ],
      child: MyApp(isLogedin: token != null),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLogedin;
  const MyApp({super.key, required this.isLogedin});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecommerce',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFFCF5F5),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.0 * 1.5,
            vertical: 16.0,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            // borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),
      home: isLogedin ? HomePage() : LoginPage(),
    );
  }
}
