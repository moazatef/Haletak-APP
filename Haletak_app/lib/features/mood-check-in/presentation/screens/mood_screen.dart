import 'package:aluna/core/theme/colors.dart';
import 'package:aluna/features/mood-check-in/presentation/screens/old_note_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_slider.dart';
import '../widgets/emoji_display.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  _MoodScreenState createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  double _moodValue = 0.5; // Default slider value

  // Mood emoji list
  final List<String> emojis = [
    'assets/images/angry.gif',
    'assets/images/sad.gif',
    'assets/images/neutral.gif',
    'assets/images/grimace.gif',
    'assets/images/happy.gif',
    'assets/images/shy.gif',
    'assets/images/smile.gif',
    'assets/images/worried.gif',
  ];

  // Mood text logic corresponding to emojis
  final List<String> moodTexts = [
    "SO MAD ",
    "KIND OF SAD ",
    "IT'S ALL GOOD ",
    "A LITTLE STRESSED ",
    "TOTALLY HYPED ",
    "BIG SMILES ",
    "LOWKEY NERVOUS ",
  ];

  int getMoodIndex(double value) {
    if (value < 0.125) return 0;
    if (value < 0.25) return 1;
    if (value < 0.375) return 2;
    if (value < 0.5) return 3;
    if (value < 0.625) return 4;
    if (value < 0.75) return 5;
    if (value < 0.875) return 6;
    return 6; // Worried
  }

  @override
  Widget build(BuildContext context) {
    int moodIndex = getMoodIndex(_moodValue);

    return Scaffold(
      backgroundColor: ColorStyles.fontButtonColor,
      body: Stack(
        children: [
          // Main content with padding and centering
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Emoji display widget
                EmojiDisplay(
                  emojiPath: emojis[moodIndex], // Pick correct emoji
                  moodText: moodTexts[moodIndex], // Pick matching mood text
                ),
                const SizedBox(height: 20),

                // Custom slider widget
                CustomSlider(
                  value: _moodValue,
                  onChanged: (value) {
                    setState(() {
                      _moodValue = value; // Update mood value
                    });
                  },
                ),
              ],
            ),
          ),

          // Positioned button at bottom center
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: CustomButton(
                text: "CONTINUE",
                onPressed: () {
                  Navigator.pushNamed(context, '/addJournalScreen');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void navigateToNextScreen(BuildContext context) {
  // Navigate to next screen
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => const AddNoteScreen(),
    ),
  );
}
