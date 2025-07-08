import 'package:aluna/core/routing/routes.dart';
import 'package:aluna/core/theme/colors.dart';
import 'package:flutter/material.dart';
import '../widgets/onboarding_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;

  final List<Map<String, dynamic>> onboardingData = [
    {
      'image': 'assets/images/green.png',
      'step': 'Step One',
      'styledText': [
        const TextSpan(
            text: 'Personalize Your ',
            style: TextStyle(color: Color(0xFF000000))),
        const TextSpan(
            text: 'Mental Health ', style: TextStyle(color: Color(0xFF4CAF50))),
        const TextSpan(
            text: 'State With AI', style: TextStyle(color: Colors.black)),
      ],
      'backgroundColor': Colors.green.shade100,
    },
    {
      'image': 'assets/images/orange.png',
      'step': 'Step Two',
      'styledText': [
        const TextSpan(
            text: 'Intelligent ', style: TextStyle(color: Color(0xFFFF9800))),
        const TextSpan(
            text: 'Mood Tracking & ', style: TextStyle(color: Colors.black)),
        const TextSpan(
            text: 'AI Emotion Insights',
            style: TextStyle(color: Colors.orange)),
      ],
      'backgroundColor': Colors.orange.shade100,
    },
    {
      'image': 'assets/images/dark.png',
      'step': 'Step Three',
      'styledText': [
        const TextSpan(
            text: 'AI Mental ', style: TextStyle(color: Colors.black)),
        const TextSpan(
            text: 'Journaling & ', style: TextStyle(color: Color(0xFF9E9E9E))),
        const TextSpan(
            text: 'AI Therapy Chatbot', style: TextStyle(color: Colors.black)),
      ],
      'backgroundColor': Colors.grey.shade200,
    },
  ];

  void nextPage() {
    if (currentIndex < onboardingData.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      Navigator.pushNamed(context, Routes.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: OnboardingWidget(
                  image: onboardingData[currentIndex]['image'],
                  step: onboardingData[currentIndex]['step'],
                  styledText: onboardingData[currentIndex]['styledText'],
                  backgroundColor: onboardingData[currentIndex]
                      ['backgroundColor'],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (currentIndex + 1) / onboardingData.length,
                    backgroundColor: const Color.fromARGB(255, 206, 226, 224),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      ColorStyles.mainColor,
                    ),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: GestureDetector(
                  onTap: nextPage,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: ColorStyles.mainColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
