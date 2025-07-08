import 'package:aluna/core/theme/colors.dart';
import 'package:flutter/material.dart';

// how to use it
// Text('Hello World', style: Theme.of(context).textTheme.displayLarge)
//style: Theme.of(context).textTheme.button,
//style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.red),

class AppTheme {
  // TextTheme with flexible color
  static TextTheme textTheme = const TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Urbanist',
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ), // Large Title
    displayMedium: TextStyle(
      fontFamily: 'Urbanist',
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ), // Medium Title
    displaySmall: TextStyle(
      fontFamily: 'Urbanist',
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ), // Small Title
    headlineMedium: TextStyle(
      fontFamily: 'Urbanist',
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ), // Section Title
    titleMedium: TextStyle(
      fontFamily: 'Urbanist',
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ), // Subtitle / Medium Text
    titleSmall: TextStyle(
      fontFamily: 'Urbanist',
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ), // Small Subtitle
    bodyLarge: TextStyle(
      fontFamily: 'Urbanist',
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ), // Body Text / Paragraph
    bodyMedium: TextStyle(
      fontFamily: 'Urbanist',
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ), // Small Body Text
    bodySmall: TextStyle(
      fontFamily: 'Urbanist',
      fontSize: 10,
      fontWeight: FontWeight.w300,
    ), // Caption / Hints
    labelLarge: TextStyle(
      fontFamily: 'Urbanist',
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ), // Button Text
  );

  // ThemeData using the custom text theme
  static ThemeData lightTheme = ThemeData(
    primaryColor: ColorStyles.mainColor,
    brightness: Brightness.light,
    textTheme: textTheme,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
            color: ColorStyles.mainColor,
            width: 2), // Change border color when clicked
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
            color: ColorStyles.mainColor,
            width: 2), // Change border color when clicked
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
            color: ColorStyles.backgroundColor,
            width: 1.5), // Change default border color
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
            color: Colors.red,
            width: 2), // Change border color when there's an error
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
            color: Colors.red, width: 2), // Change error border when focused
      ),
    ),
  );
}
