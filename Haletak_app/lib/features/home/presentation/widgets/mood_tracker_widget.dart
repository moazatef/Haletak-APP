// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

class MoodTrackerCard extends StatelessWidget {
  const MoodTrackerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: ColorStyles.fontButtonColor,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: ColorStyles.mainColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_emotions,
                color: ColorStyles.mainColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Mood Tracker",
                    style: TextStyle(
                      color: ColorStyles.fontMainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Sad mood
                      _MoodLabel(
                          mood: "Sad",
                          color: ColorStyles.mainColor.withOpacity(0.1),
                          textColor:
                              ColorStyles.fontSmallBoldColor // Orange text
                          ),
                      const Icon(Icons.arrow_forward,
                          size: 16, color: ColorStyles.fontSmallBoldColor),
                      // Happy mood
                      _MoodLabel(
                        mood: "Happy",
                        color: ColorStyles.mainColor.withOpacity(0.1),
                        textColor: ColorStyles.fontSmallBoldColor, // Green text
                      ),
                      const Icon(Icons.arrow_forward,
                          size: 16, color: ColorStyles.fontSmallBoldColor),
                      // Neutral mood
                      _MoodLabel(
                        mood: "Neutral",
                        color: ColorStyles.mainColor.withOpacity(0.1),
                        textColor: ColorStyles.fontSmallBoldColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for Mood Labels
class _MoodLabel extends StatelessWidget {
  final String mood;
  final Color color;
  final Color textColor;

  const _MoodLabel({
    required this.mood,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        mood,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
