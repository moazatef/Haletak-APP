import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

class BottomButton extends StatelessWidget {
  const BottomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorStyles.mainColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          onPressed: () {
            // Add your logic here for button click
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Check-in Completed!')),
            );
            Navigator.pushReplacementNamed(context, '/homeScreen');
          },
          child: const Text(
            "COMPLETE CHECK-IN",
            style: TextStyle(
              color: ColorStyles.fontButtonColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
