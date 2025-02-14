import 'package:ecommerce/features/auth/presentation/widgets/custom_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

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

              child: Column(
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
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(label: Text('ইমেইল')),
                          keyboardType: TextInputType.phone,
                          onSaved: (phone) {
                            // Save it
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: TextFormField(
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
                                style: Theme.of(context).textTheme.titleSmall!
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
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyLarge!.color!.withOpacity(0.64),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        CustomButton(onTap: login, title: "সাইন ইন করুন"),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Navigate to the main screen
    }
  }
}
