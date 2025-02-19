import 'package:ecommerce/core/dependency_injection/dependency.dart';
import 'package:ecommerce/core/services/secure_storage.dart';
import 'package:ecommerce/features/auth/bloc/auth_bloc.dart';
import 'package:ecommerce/features/auth/domain/usecases/auth_use_case.dart';
import 'package:ecommerce/features/auth/presentation/pages/login_page.dart';
import 'package:ecommerce/features/cart/cubit/cart_cubit.dart';
import 'package:ecommerce/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Dependency.dependencyServicesLocator();
  final TokenServices secureStorageService = Dependency.injection();
  final useCase = AuthUseCase(repo: Dependency.injection());
  final String? token = await secureStorageService.getToken();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            useCase: useCase,
            secureStorageService: secureStorageService,
          ),
        ),
        BlocProvider(create: (context) => CartCubit()),
      ],
      child: MyApp(isLogin: token != null),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLogin;
  const MyApp({super.key, required this.isLogin});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecommerce',
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
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
      home: isLogin ? HomePage() : LoginPage(),
    );
  }
}
