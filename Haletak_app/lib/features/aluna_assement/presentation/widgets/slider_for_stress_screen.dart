import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const CustomSlider({required this.value, required this.onChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 10,
          activeTrackColor: Colors.brown.shade800,
          inactiveTrackColor: Colors.grey.shade300,
          thumbColor: Colors.brown.shade800,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 16),
        ),
        child: Slider(
          value: value.toDouble(), // ✅ Convert int to double
          min: 1,
          max: 5,
          divisions: 4,
          label: value.toString(),
          onChanged: (double val) =>
              onChanged(val.toInt()), // ✅ Convert double to int
        ),
      ),
    );
  }
}
