// lib/presentation/widgets/mood_icon.dart

import 'package:flutter/material.dart';

class MoodIcon extends StatelessWidget {
  final String mood;

  const MoodIcon({super.key, required this.mood});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _getMoodColor(),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: _getMoodIcon(),
      ),
    );
  }

  Color _getMoodColor() {
    switch (mood.toLowerCase()) {
      case 'terrible':
        return Colors.red;
      case 'bad':
        return Colors.orange;
      case 'neutral':
        return Colors.yellow;
      case 'good':
        return Colors.lightGreen;
      case 'excellent':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _getMoodIcon() {
    switch (mood.toLowerCase()) {
      case 'terrible':
        return const Icon(Icons.sentiment_very_dissatisfied,
            color: Colors.white);
      case 'bad':
        return const Icon(Icons.sentiment_dissatisfied, color: Colors.white);
      case 'neutral':
        return const Icon(Icons.sentiment_neutral, color: Colors.white);
      case 'good':
        return const Icon(Icons.sentiment_satisfied, color: Colors.white);
      case 'excellent':
        return const Icon(Icons.sentiment_very_satisfied, color: Colors.white);
      default:
        return const Icon(Icons.emoji_emotions, color: Colors.white);
    }
  }
}
