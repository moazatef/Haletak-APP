// ignore_for_file: deprecated_member_use

import 'package:aluna/core/theme/colors.dart';
import 'package:flutter/material.dart';

class CustomButtonAssment extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  const CustomButtonAssment({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorStyles.mainColor,
        foregroundColor: ColorStyles.fontButtonColor,
        disabledBackgroundColor: ColorStyles.mainColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (icon != null) ...[
            const SizedBox(width: 8),
            Icon(
              icon,
              color: ColorStyles.fontButtonColor,
            ),
          ],
        ],
      ),
    );
  }
}
