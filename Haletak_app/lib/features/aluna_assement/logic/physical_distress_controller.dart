// lib/presentation/screens/assessment_flow_screen.dart
import 'package:aluna/features/aluna_assement/presentation/screens/physiacal_distress_screen.dart';
import 'package:flutter/material.dart';

class AssessmentFlowScreen extends StatefulWidget {
  const AssessmentFlowScreen({super.key});

  @override
  State<AssessmentFlowScreen> createState() => _AssessmentFlowScreenState();
}

class _AssessmentFlowScreenState extends State<AssessmentFlowScreen> {
  final PageController _pageController = PageController();
  final int _totalQuestions = 14;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {});
        },
        itemCount: _totalQuestions,
        itemBuilder: (context, index) {
          return const PhysicalDistressScreen();
        },
      ),
    );
  }
}
