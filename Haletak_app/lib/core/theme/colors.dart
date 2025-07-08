import 'package:flutter/material.dart';

// how to use it in the app "backgroundColor: ColorStyles.backgroundColor,"
// more example to use it  "primary: ColorStyles.accentColor"
class ColorStyles {
  // Primary Colors
  static const Color mainColor =
      Color.from(alpha: 1, red: 0.329, green: 0.714, blue: 0.671);
  static const Color fontMainColor = Color(0xFF262C3D);
  static const Color fontButtonColor = Color.fromARGB(255, 255, 255, 255);
  static const Color cardColor = Color(0xFF84D4E4);
  static const Color errorColor = Color(0xFFEC6761);
  static const Color fontSmallBoldColor = Color.fromARGB(255, 81, 81, 81);
  static const Color backgroundColor = Color.fromARGB(255, 255, 255, 255);
}
