import 'package:flutter/material.dart';
import '../widgets/animated_aluna_text.dart';
import '../../logic/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashController _splashController;

  @override
  void initState() {
    super.initState();
    _splashController = SplashController(context);
    _splashController.navigateToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return const PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: AnimatedAlunaText(),
      ),
    );
  }
}
