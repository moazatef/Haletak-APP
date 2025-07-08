// lib/features/mood_stats/presentation/widgets/mood_history_calendar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:aluna/features/mood_stats/data/model/mood_stats.dart';

class MoodHistoryCalendar extends StatelessWidget {
  final List<DailyMood> dailyMoods;
  final Function(String) onMonthChanged;

  const MoodHistoryCalendar({
    super.key,
    required this.dailyMoods,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Get data for the past week
    final List<DailyMood> weekMoods = _getLastWeekMoods();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day of week headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDayHeader('Mon'),
              _buildDayHeader('Tue'),
              _buildDayHeader('Wed'),
              _buildDayHeader('Thu'),
              _buildDayHeader('Fri'),
              _buildDayHeader('Sat'),
              _buildDayHeader('Sun'),
            ],
          ),

          SizedBox(height: 8.h),

          // Emoji mood indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              if (index < weekMoods.length) {
                return _buildMoodEmoji(weekMoods[index]);
              } else {
                return _buildEmptyEmoji();
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDayHeader(String day) {
    return SizedBox(
      width: 40.w,
      child: Text(
        day,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildMoodEmoji(DailyMood mood) {
    // Convert primary mood to appropriate emoji
    String emoji = _getMoodEmoji(mood.primaryMood);
    Color backgroundColor = _getMoodColor(mood.primaryMood);

    return Column(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Text(
            emoji,
            style: TextStyle(
              fontSize: 20.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyEmoji() {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
    );
  }

  String _getMoodEmoji(String mood) {
    final lowerMood = mood.toLowerCase();

    if (lowerMood.contains('happy') || lowerMood.contains('joy')) {
      return '😀';
    } else if (lowerMood.contains('neutral') || lowerMood.contains('calm')) {
      return '😐';
    } else if (lowerMood.contains('sad') || lowerMood.contains('depress')) {
      return '😔';
    } else if (lowerMood.contains('anxious') || lowerMood.contains('stress')) {
      return '😰';
    } else if (lowerMood.contains('angry')) {
      return '😠';
    } else {
      return '😐'; // Default neutral
    }
  }

  Color _getMoodColor(String mood) {
    final lowerMood = mood.toLowerCase();

    if (lowerMood.contains('happy') || lowerMood.contains('joy')) {
      return const Color(0xFF9CB380); // Green
    } else if (lowerMood.contains('neutral') || lowerMood.contains('calm')) {
      return const Color(0xFFA67C52); // Brown
    } else if (lowerMood.contains('sad') || lowerMood.contains('depress')) {
      return const Color(0xFFE67E22); // Orange
    } else if (lowerMood.contains('anxious') || lowerMood.contains('stress')) {
      return Colors.purple;
    } else if (lowerMood.contains('angry')) {
      return Colors.red;
    } else {
      return Colors.grey; // Default
    }
  }

  List<DailyMood> _getLastWeekMoods() {
    if (dailyMoods.isEmpty) {
      return [];
    }

    // Get today's date
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    // Get Monday of this week
    final int weekday = today.weekday; // 1 = Monday, 7 = Sunday
    final mondayDate = todayDate.subtract(Duration(days: weekday - 1));

    // Filter moods from Monday to today
    final List<DailyMood> weekMoods = [];

    // Create a map of existing moods by date string
    final Map<String, DailyMood> moodsByDate = {};
    for (var mood in dailyMoods) {
      final dateStr = DateFormat('yyyy-MM-dd').format(mood.date);
      moodsByDate[dateStr] = mood;
    }

    // Get moods for each day of the week or null if not available
    for (int i = 0; i < 7; i++) {
      final date = mondayDate.add(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(date);

      if (moodsByDate.containsKey(dateStr)) {
        weekMoods.add(moodsByDate[dateStr]!);
      }
    }

    return weekMoods;
  }
}
