import 'package:ecommerce/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: LoginPage(),
    );
  }
}
