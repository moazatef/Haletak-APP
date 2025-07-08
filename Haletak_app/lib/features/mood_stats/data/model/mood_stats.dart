// lib/features/mood_stats/data/model/mood_stats.dart
import 'package:aluna/features/journal_entry/data/model/journal_entry.dart';

class MoodStats {
  final List<DailyMood> dailyMoods;
  final Map<String, int> moodCounts;
  final DateTime startDate;
  final DateTime endDate;

  MoodStats({
    required this.dailyMoods,
    required this.moodCounts,
    required this.startDate,
    required this.endDate,
  });

  factory MoodStats.empty() {
    return MoodStats(
      dailyMoods: [],
      moodCounts: {},
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    );
  }
}

class DailyMood {
  final DateTime date;
  final String primaryMood;
  final int stressLevel;
  final String stressor;

  // For the mood chart visualization
  final double happyValue;
  final double neutralValue;
  final double depressedValue;
  final double anxietyValue;

  DailyMood({
    required this.date,
    required this.primaryMood,
    required this.stressLevel,
    required this.stressor,
    required this.happyValue,
    required this.neutralValue,
    required this.depressedValue,
    required this.anxietyValue,
  });

  factory DailyMood.fromJournal(Journal journal) {
    // Default values
    double happy = 0.0;
    double neutral = 0.0;
    double depressed = 0.0;

    // Determine mood values based on the journal's emotion or ML response
    String primaryMood =
        journal.mlResponse?.predictedMood ?? journal.emotion ?? 'Neutral';

    // Set values for visualization based on primary mood
    if (primaryMood.toLowerCase().contains('happy')) {
      happy = journal.stressLevel != null
          ? (5 - journal.stressLevel!) / 5 * 100
          : 70;
      neutral = 30;
      depressed = 10;
    } else if (primaryMood.toLowerCase().contains('sad') ||
        primaryMood.toLowerCase().contains('depress')) {
      happy = 10;
      neutral = 30;
      depressed =
          journal.stressLevel != null ? journal.stressLevel! / 5 * 100 : 70;
    } else {
      happy = 20;
      neutral = journal.stressLevel != null
          ? (5 - journal.stressLevel!) / 5 * 100
          : 60;
      depressed = 20;
    }

    return DailyMood(
      date: journal.createdAt,
      primaryMood: primaryMood,
      stressLevel: journal.stressLevel ?? 3,
      stressor: journal.stressor ?? 'Undefined',
      happyValue: happy,
      neutralValue: neutral,
      depressedValue: depressed,
      anxietyValue: 0.0,
    );
  }
}

// Time period enum for filtering
enum TimePeriod {
  day,
  week,
  month,
  year,
  allTime,
}

// Extension to get display text
extension TimePeriodExtension on TimePeriod {
  String get displayText {
    switch (this) {
      case TimePeriod.day:
        return '1 Day';
      case TimePeriod.week:
        return '1 Week';
      case TimePeriod.month:
        return '1 Month';
      case TimePeriod.year:
        return '1 Year';
      case TimePeriod.allTime:
        return 'All Time';
    }
  }
}
