// lib/presentation/widgets/weight_slider_widget.dart
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

class WeightSliderWidget extends StatefulWidget {
  final int currentWeight;
  final Function(int) onWeightChanged;

  const WeightSliderWidget({
    super.key,
    required this.currentWeight,
    required this.onWeightChanged,
  });

  @override
  State<WeightSliderWidget> createState() => _WeightSliderWidgetState();
}

class _WeightSliderWidgetState extends State<WeightSliderWidget> {
  late double _sliderValue;
  final int _minWeight = 30;
  final int _maxWeight = 200;

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.currentWeight.toDouble();
  }

  @override
  void didUpdateWidget(WeightSliderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentWeight != widget.currentWeight) {
      _sliderValue = widget.currentWeight.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 1.0,
            activeTrackColor: Colors.grey[300],
            inactiveTrackColor: Colors.grey[300],
            thumbColor: ColorStyles.mainColor,
            thumbShape: CustomSliderThumbShape(),
            overlayShape: SliderComponentShape.noOverlay,
            valueIndicatorShape: SliderComponentShape.noOverlay,
          ),
          child: Slider(
            value: _sliderValue,
            min: _minWeight.toDouble(),
            max: _maxWeight.toDouble(),
            onChanged: (value) {
              setState(() {
                _sliderValue = value;
              });
              widget.onWeightChanged(value.round());
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              5,
              (index) {
                final weight = _minWeight +
                    (index * ((_maxWeight - _minWeight) / 4)).round();
                final isSelected = (widget.currentWeight - weight).abs() < 2;

                return Text(
                  weight.toString(),
                  style: TextStyle(
                    color: isSelected
                        ? ColorStyles.fontMainColor
                        : Colors.grey[400],
                    fontSize: 14,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class CustomSliderThumbShape extends SliderComponentShape {
  final double enabledThumbRadius = 10.0;
  final double disabledThumbRadius = 8.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(
        isEnabled ? enabledThumbRadius : disabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // Draw vertical line
    final Paint linePaint = Paint()
      ..color = ColorStyles.mainColor
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(center.dx, center.dy - 15),
      Offset(center.dx, center.dy + 15),
      linePaint,
    );

    final Paint circlePaint = Paint()
      ..color = ColorStyles.fontMainColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(center.dx, center.dy - 15), 2.0, circlePaint);
    canvas.drawCircle(Offset(center.dx, center.dy + 15), 2.0, circlePaint);
  }
}
