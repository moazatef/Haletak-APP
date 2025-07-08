import 'package:aluna/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmotionOption {
  final String name;
  final Color color;
  final Image image;

  EmotionOption({
    required this.name,
    required this.color,
    required this.image,
  });
}

class EmotionSelector extends StatelessWidget {
  final String selectedEmotion;
  final Function(String) onEmotionSelected;

  EmotionSelector({
    super.key,
    required this.selectedEmotion,
    required this.onEmotionSelected,
  });

  final List<EmotionOption> emotions = [
    EmotionOption(
      name: 'Very Sad',
      color: Colors.purple.shade200,
      image:
          Image.asset('assets/images/mooddepressed.png', width: 50, height: 50),
    ),
    EmotionOption(
      name: 'Sad',
      color: Colors.orange,
      image: Image.asset('assets/images/moodsad.png', width: 50, height: 50),
    ),
    EmotionOption(
      name: 'Neutral',
      color: Colors.brown.shade200,
      image:
          Image.asset('assets/images/moodneutral.png', width: 50, height: 50),
    ),
    EmotionOption(
      name: 'Happy',
      color: Colors.amber,
      image: Image.asset('assets/images/moodhappy.png', width: 50, height: 50),
    ),
    EmotionOption(
      name: 'Very Happy',
      color: Colors.lightGreen,
      image:
          Image.asset('assets/images/moodoverjoyed.png', width: 50, height: 50),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Your Emotion',
          style: TextStyle(
            fontSize: 18.sp,
            color: ColorStyles.fontMainColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: emotions.map((emotion) {
            return GestureDetector(
              onTap: () => onEmotionSelected(emotion.name),
              child: Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  color: emotion.color,
                  shape: BoxShape.circle,
                  border: selectedEmotion == emotion.name
                      ? Border.all(color: Colors.black, width: 2)
                      : null,
                ),
                child: Center(
                  child: emotion.image,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
