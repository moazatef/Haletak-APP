// ignore_for_file: use_build_context_synchronously

import 'package:aluna/core/routing/routes.dart';
import 'package:flutter/material.dart';

class SplashController {
  final BuildContext context;

  SplashController(this.context);

  void navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 2), () {
      if (Navigator.of(context).mounted) {
        Navigator.pushNamed(context, Routes.onBoardingScreen);
      }
    });
  }
}
