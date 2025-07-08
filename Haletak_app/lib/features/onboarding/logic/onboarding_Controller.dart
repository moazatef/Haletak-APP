import 'package:aluna/features/onboarding/data/onboardig_data.dart';
import 'package:flutter/material.dart';

class OnboardingController with ChangeNotifier {
  int currentIndex = 0;

  void nextPage() {
    if (currentIndex < onboardingData.length - 1) {
      currentIndex++;
      notifyListeners();
    }
  }
}
