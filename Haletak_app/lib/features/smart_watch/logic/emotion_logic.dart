class EmotionLogic {
  static String getEmotionFromBPM(int bpm) {
    if (bpm < 60) return "Calm";
    if (bpm < 80) return "Relaxed";
    if (bpm < 100) return "Neutral";
    if (bpm < 120) return "Anxious";
    return "Stressed";
  }

  static String getEmoji(String emotion) {
    switch (emotion) {
      case "Calm":
        return "😌";
      case "Relaxed":
        return "😊";
      case "Neutral":
        return "😐";
      case "Anxious":
        return "😟";
      case "Stressed":
        return "😣";
      default:
        return "❓";
    }
  }
}
