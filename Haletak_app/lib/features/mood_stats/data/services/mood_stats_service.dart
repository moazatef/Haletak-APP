// lib/features/mood_stats/data/service/mood_stats_service.dart
import 'package:aluna/features/auth/data/service/auth_service.dart';
import 'package:aluna/features/journal_entry/data/model/journal_entry.dart';
import 'package:aluna/features/journal_entry/data/services/journal_service.dart';
import 'package:flutter/foundation.dart';

import '../model/mood_stats.dart';

class MoodStatsService {
  final JournalService _journalService;

  MoodStatsService({required JournalService journalService})
      : _journalService = journalService;

  static Future<MoodStatsService> create() async {
    final token = await AuthService().getToken();
    if (token == null) {
      throw Exception('User not authenticated');
    }
    return MoodStatsService(journalService: JournalService(token: token));
  }

  // Get mood statistics for a specific time period
  Future<MoodStats> getMoodStats(TimePeriod period) async {
    try {
      // Get all journals
      final journals = await _journalService.getJournals();

      // Filter journals based on the selected time period
      final filteredJournals = _filterJournalsByPeriod(journals, period);

      // Group and process journals to create daily mood data
      final dailyMoods = _processDailyMoods(filteredJournals);

      // Count mood frequencies
      final moodCounts = _countMoods(dailyMoods);

      return MoodStats(
        dailyMoods: dailyMoods,
        moodCounts: moodCounts,
        startDate: dailyMoods.isNotEmpty
            ? dailyMoods
                .map((mood) => mood.date)
                .reduce((a, b) => a.isBefore(b) ? a : b)
            : DateTime.now(),
        endDate: dailyMoods.isNotEmpty
            ? dailyMoods
                .map((mood) => mood.date)
                .reduce((a, b) => a.isAfter(b) ? a : b)
            : DateTime.now(),
      );
    } catch (e) {
      debugPrint('Error getting mood stats: $e');
      rethrow;
    }
  }

  // Filter journals based on time period
  List<Journal> _filterJournalsByPeriod(
      List<Journal> journals, TimePeriod period) {
    final now = DateTime.now();
    DateTime startDate;

    switch (period) {
      case TimePeriod.day:
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case TimePeriod.week:
        startDate = DateTime(now.year, now.month, now.day - 7);
        break;
      case TimePeriod.month:
        startDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case TimePeriod.year:
        startDate = DateTime(now.year - 1, now.month, now.day);
        break;
      case TimePeriod.allTime:
        return journals; // Return all journals for all time
    }

    return journals
        .where((journal) =>
            journal.createdAt.isAfter(startDate) ||
            journal.createdAt.isAtSameMomentAs(startDate))
        .toList();
  }

  // Process journals into daily moods
  List<DailyMood> _processDailyMoods(List<Journal> journals) {
    // Group journals by day
    final Map<String, List<Journal>> journalsByDay = {};

    for (final journal in journals) {
      final dateKey =
          '${journal.createdAt.year}-${journal.createdAt.month}-${journal.createdAt.day}';
      if (!journalsByDay.containsKey(dateKey)) {
        journalsByDay[dateKey] = [];
      }
      journalsByDay[dateKey]!.add(journal);
    }

    // Convert each day's journals into a DailyMood
    List<DailyMood> dailyMoods = [];
    journalsByDay.forEach((dateKey, dayJournals) {
      // Sort journals by creation time
      dayJournals.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // Use the most recent journal for the day to determine mood
      if (dayJournals.isNotEmpty) {
        dailyMoods.add(DailyMood.fromJournal(dayJournals.first));
      }
    });

    // Sort by date
    dailyMoods.sort((a, b) => a.date.compareTo(b.date));
    return dailyMoods;
  }

  // Count frequencies of different moods
  Map<String, int> _countMoods(List<DailyMood> dailyMoods) {
    final Map<String, int> moodCounts = {};

    for (final mood in dailyMoods) {
      final primaryMood = mood.primaryMood;
      moodCounts[primaryMood] = (moodCounts[primaryMood] ?? 0) + 1;
    }

    return moodCounts;
  }
}
