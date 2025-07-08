import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

class EmojiDisplay extends StatelessWidget {
  final String emojiPath;
  final String moodText;

  const EmojiDisplay({
    super.key,
    required this.moodText,
    required this.emojiPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          emojiPath,
          height: 100, // Adjust size as needed
        ),
        const SizedBox(height: 20),
        Text(
          moodText,
          style: const TextStyle(
            color: ColorStyles.fontMainColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
