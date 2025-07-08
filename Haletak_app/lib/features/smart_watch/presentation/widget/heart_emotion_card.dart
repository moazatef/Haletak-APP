import 'package:flutter/material.dart';

class HeartEmotionCard extends StatelessWidget {
  final int bpm;
  final String emotion;
  final String emoji;

  const HeartEmotionCard({
    super.key,
    required this.bpm,
    required this.emotion,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("❤️ $bpm BPM",
                style:
                    const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("$emoji $emotion", style: const TextStyle(fontSize: 28)),
          ],
        ),
      ),
    );
  }
}
