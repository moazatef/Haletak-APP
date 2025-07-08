import 'package:aluna/features/auth/presentation/widgets/custom_button.dart';
import 'package:aluna/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/theme/colors.dart';
import '../../logic/auth_controller.dart';
import '../widgets/text_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController _authController = AuthController();
  bool _isLoading = false;
  String? _errorMessage;
  int _attemptCount = 0;

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
                      'Let’s Sign you in',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 50.0),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.titleLarge,
                        children: const [
                          TextSpan(text: 'Welcome Back'),
                          TextSpan(text: '  , \n'),
                          TextSpan(text: 'You have been missed'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    // Email Field
                    TextFormFieldWidget(
                      hintText: 'Email',
                      controller: _emailController,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20.0),

                    // Password Field
                    TextFormFieldWidget(
                      hintText: 'Password',
                      controller: _passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    const SizedBox(height: 20.0),

                    // Error message display
                    if (_errorMessage != null)
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red[200]!),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline,
                                    color: Colors.red),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: TextStyle(color: Colors.red[800]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Retry button only shown after first failure
                          if (_attemptCount > 0)
                            ButtonWidget(
                              onPressed: _retryLogin,
                              height: 20,
                              color: ColorStyles.mainColor,
                              text: 'Try Again',
                            ),
                          const SizedBox(height: 10),
                        ],
                      ),

                    // Sign In Button
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ButtonWidget(
                            onPressed:
                                _isLoading ? () {} : () => _handleLogin(),
                            height: 20,
                            color: ColorStyles.mainColor,
                            text: _isLoading ? 'Signing in...' : 'Sign in',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('or'),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Image.asset('assets/images/gmail.png'),
                          onPressed: () {
                            _authController.signInWithGoogle(context);
                          },
                        ),
                        IconButton(
                          icon: Image.asset('assets/images/facebook.png'),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Image.asset('assets/images/apple.png'),
                          onPressed: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 20.0),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, Routes.registerScreen);
                            },
                            child: Text(
                              'Register Now',
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
        ],
      ),
    );
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _attemptCount++;
    });

    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email and password are required!")),
        );
        return;
      }

      String? name = await _authController.login(context, email, password);

      if (name != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(username: name),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Login failed. Please check your credentials.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = _getUserFriendlyErrorMessage(e);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _retryLogin() async {
    setState(() {
      _errorMessage = null;
    });
    _handleLogin();
  }

  String _getUserFriendlyErrorMessage(dynamic error) {
    if (error.toString().contains('502')) {
      return 'Server is temporarily unavailable. Please try again.';
    } else if (error.toString().contains('MySQL')) {
      return 'Connection issue. Please try again.';
    } else if (error.toString().contains('timeout')) {
      return 'Request timed out. Please check your connection.';
    } else {
      return 'Login failed. Please try again.';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
