// ignore_for_file: deprecated_member_use

import 'package:aluna/features/auth/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/theme/colors.dart';
import '../../logic/auth_controller.dart';
import '../widgets/text_field_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthController _authController = AuthController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 30.0, top: 150.0, bottom: 20.0, right: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lets Register',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 40.0),
                    Text(
                      'Account',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 50.0),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.titleLarge,
                        children: const [
                          TextSpan(text: 'Hello user , you have'),
                          TextSpan(text: ' \n'),
                          TextSpan(text: 'a greatful journey'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      child: TextFormFieldWidget(
                        hintText: 'Name',
                        controller: _nameController,
                        obscureText: false,
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      child: TextFormFieldWidget(
                        hintText: 'Email',
                        controller: _emailController,
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      child: TextFormFieldWidget(
                        hintText: 'Password',
                        controller: _passwordController,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormFieldWidget(
                      keyboardType: TextInputType.visiblePassword,
                      hintText: 'Confirm Password',
                      controller: _confirmPasswordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ButtonWidget(
                            onPressed: () {
                              String name = _nameController.text.trim();
                              String email = _emailController.text.trim();
                              String password = _passwordController.text.trim();
                              String confirmPassword =
                                  _confirmPasswordController.text.trim();

                              // ✅ Debugging print statements (optional)
                              print("Name: $name");
                              print("Email: $email");
                              print("Password: $password");
                              print("Confirm Password: $confirmPassword");

                              if (name.isEmpty ||
                                  email.isEmpty ||
                                  password.isEmpty ||
                                  confirmPassword.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("All fields are required!")),
                                );
                                return;
                              }

                              if (password != confirmPassword) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Passwords do not match!")),
                                );
                                return;
                              }

                              _authController.register(context, name, email,
                                  password, confirmPassword);
                            },
                            height: 20,
                            color: ColorStyles.mainColor.withOpacity(0.8),
                            text: 'Sign Up',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Already have an account?",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, Routes.loginScreen);
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: ColorStyles.mainColor.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
