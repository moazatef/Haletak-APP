// lib/presentation/widgets/sleep_quality_slider.dart
import 'package:aluna/core/theme/colors.dart';
import 'package:flutter/material.dart';

class SleepQualityOption {
  final String rating;
  final String hoursRange;
  final String displayHours;
  final Widget emojiWidget;
  final int value;

  SleepQualityOption({
    required this.rating,
    required this.hoursRange,
    required this.displayHours,
    required this.emojiWidget,
    required this.value,
  });
}

class SleepQualitySlider extends StatefulWidget {
  final List<SleepQualityOption> options;
  final Function(SleepQualityOption) onChanged;
  final SleepQualityOption initialValue;

  const SleepQualitySlider({
    super.key,
    required this.options,
    required this.onChanged,
    required this.initialValue,
  });

  @override
  _SleepQualitySliderState createState() => _SleepQualitySliderState();
}

class _SleepQualitySliderState extends State<SleepQualitySlider> {
  late double _currentValue;
  late SleepQualityOption _selectedOption;

  @override
  void initState() {
    super.initState();
    // Initialize with the index of the initial value (reversed)
    int initialIndex = widget.options.indexOf(widget.initialValue);
    _currentValue = (widget.options.length - 1 - initialIndex).toDouble();
    _selectedOption = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 350,
          child: Stack(
            children: [
              // Vertical line in the center
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 2,
                    height: double.infinity,
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              // Options on the left
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: widget.options.map((option) {
                    bool isSelected = option == _selectedOption;
                    return Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  option.rating,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? ColorStyles.fontMainColor
                                        : Colors.grey,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      option.displayHours,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              // Slider and emojis on the right
              Positioned.fill(
                child: SliderTheme(
                  data: const SliderThemeData(
                    trackHeight: 0,
                    thumbShape: RoundSliderThumbShape(
                      enabledThumbRadius: 18,
                      elevation: 0,
                    ),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
                    thumbColor:
                        ColorStyles.mainColor, // Orange color from the image
                    activeTrackColor: Colors.transparent,
                    inactiveTrackColor: Colors.transparent,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Slider(
                            value: _currentValue,
                            min: 0,
                            max: (widget.options.length - 1).toDouble(),
                            divisions: widget.options.length - 1,
                            onChanged: (value) {
                              setState(() {
                                _currentValue = value;
                                // Reverse the index to make slider go from Excellent (top) to Worst (bottom)
                                int reversedIndex =
                                    widget.options.length - 1 - value.round();
                                _selectedOption = widget.options[reversedIndex];
                                widget.onChanged(_selectedOption);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Emojis on the right
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: widget.options.map((option) {
                    return Row(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: option.emojiWidget,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
