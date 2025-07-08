// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../data/model/auth_model.dart';
import '../data/service/auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();

  // API Login
  Future<String?> login(
      BuildContext context, String email, String password) async {
    try {
      final result = await _authService.login(
        LoginRequest(email: email, password: password),
      );

      if (result != null) {
        final token = await _authService.getToken();
        debugPrint("Stored Token: $token");
        return result['name']; // ✅ return the name
      }
    } catch (e) {
      showError(context, e.toString());
    }

    return null;
  }

  // API Register
  Future<void> register(BuildContext context, String name, String email,
      String password, String trim) async {
    try {
      final success = await _authService.register(
          RegisterRequest(name: name, email: email, password: password));
      if (success) {
        Navigator.pushNamed(context, '/homeScreen');
      }
    } catch (e) {
      showError(context, e.toString());
    }
  }

  // Firebase Google Sign-In
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        Navigator.pushNamed(context, '/healthGoalScreen');
      }
    } catch (e) {
      showError(context, e.toString());
    }
  }

  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
