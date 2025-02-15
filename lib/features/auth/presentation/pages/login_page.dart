// ignore_for_file: deprecated_member_use

import 'package:ecommerce/features/auth/bloc/auth_bloc.dart';
import 'package:ecommerce/features/auth/bloc/auth_event.dart';
import 'package:ecommerce/features/auth/bloc/auth_state.dart';
import 'package:ecommerce/features/auth/presentation/widgets/custom_button.dart';
import 'package:ecommerce/features/home/presentation/pages/home_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: "admin@gmail.com");
  final _passController = TextEditingController(text: "12345678");
  // final bloc = AuthBloc(AuthRepositoryImp());
  LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(
                            state.message,
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(color: Colors.white),
                          ),
                          showCloseIcon: true,
                          duration: Duration(seconds: 5),
                          backgroundColor: Colors.green,
                        ),
                      );
                  }
                  if (state is LoginFailed) {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(
                            state.failure.message,
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(color: Colors.white),
                          ),
                          showCloseIcon: true,
                          duration: Duration(seconds: 5),
                          backgroundColor: Colors.red,
                        ),
                      );
                  }
                },
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: constraints.maxHeight * 0.1),
                      Center(
                        child: Image.network(
                          "https://orderwalabd.com/images/orderwala-logo.png",
                          height: 100,
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.1),
                      Text(
                        "প্রবেশ করুন",
                        style: Theme.of(context).textTheme.headlineSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.05),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "অনুগ্রহ করে আপনার ইমেইল প্রবেশ করুন!";
                                }
                                return null;
                              },
                              decoration: InputDecoration(label: Text('ইমেইল')),
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (email) {
                                // Save it
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              child: TextFormField(
                                controller: _passController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "অনুগ্রহ করে আপনার পাসওয়ার্ড প্রবেশ করুন!";
                                  }
                                  return null;
                                },
                                obscureText: true,
                                decoration: const InputDecoration(
                                  label: Text('পাসওয়ার্ড'),
                                ),
                                onSaved: (passaword) {
                                  // Save it
                                },
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              children: [
                                Checkbox.adaptive(
                                  value: true,
                                  onChanged: (value) {},
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: "আমি মেনে নিচ্ছি এই পরিসেবার ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(color: Colors.grey),
                                    children: [
                                      TextSpan(
                                        text: "সকল শর্তাবলি",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(color: Color(0xFF00BF6D)),
                                        recognizer:
                                            TapGestureRecognizer()
                                              ..onTap = () {
                                                ('সকল শর্তাবলি');
                                              },
                                      ),
                                    ],
                                  ),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color!
                                        .withOpacity(0.64),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            CustomButton(
                              onTap: () async => await login(context),
                              title: "সাইন ইন করুন",
                              isLoading: state is LoginLoading,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    String email = _emailController.text.trim();
    String passaword = _passController.text.trim();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<AuthBloc>().add(
        AuthLoginEvent(email: email, passaword: passaword),
      );
      // Navigate to the main screen
    }
  }
}
