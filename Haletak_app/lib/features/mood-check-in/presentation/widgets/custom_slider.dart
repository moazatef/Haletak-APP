import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

class CustomSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const CustomSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: value,
      min: 0,
      max: 1,
      activeColor: ColorStyles.mainColor,
      inactiveColor: ColorStyles.mainColor.withOpacity(0.5),
      onChanged: onChanged,
    );
  }
}
