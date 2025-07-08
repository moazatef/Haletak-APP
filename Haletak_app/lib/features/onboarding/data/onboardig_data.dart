class OnboardingContent {
  final String image;
  final String title;
  final String subtitle;

  OnboardingContent({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

List<OnboardingContent> onboardingData = [
  OnboardingContent(
    image: "assets/images/green.png",
    title: "Step One",
    subtitle: "Personalize Your Mental Health State With AI",
  ),
  OnboardingContent(
    image: "assets/images/orange.png",
    title: "Step Two",
    subtitle: "Intelligent Mood Tracking & AI Emotion Insights",
  ),
  OnboardingContent(
    image: "assets/images/dark.png",
    title: "Step Three",
    subtitle: "AI Mental Journaling & AI Therapy Chatbot",
  ),
];
