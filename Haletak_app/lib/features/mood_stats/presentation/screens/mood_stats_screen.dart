// lib/features/mood_stats/presentation/screens/mood_stats_screen.dart
import 'package:aluna/core/theme/colors.dart';
import 'package:aluna/features/mood_stats/data/model/mood_stats.dart';
import 'package:aluna/features/mood_stats/data/services/mood_stats_service.dart';
import 'package:aluna/features/mood_stats/presentation/widgets/time_period_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class MoodStatsScreen extends StatefulWidget {
  const MoodStatsScreen({super.key});

  @override
  _MoodStatsScreenState createState() => _MoodStatsScreenState();
}

class _MoodStatsScreenState extends State<MoodStatsScreen> {
  late MoodStatsService _moodStatsService;
  MoodStats? _moodStats;
  bool _isLoading = true;
  TimePeriod _selectedPeriod = TimePeriod.week;
  final String _currentMonth = DateFormat('MMMM').format(DateTime.now());

  final Map<String, List<String>> _suggestions = {
    'Depressed': [
      'Go for a walk in nature',
      'Call a friend or family member',
      'Write down your thoughts in a journal',
      'Try a relaxation exercise',
      'Engage in a hobby you enjoy'
    ],
    'Stressed': [
      'Practice deep breathing for 5 minutes',
      'Make a to-do list to organize tasks',
      'Take short breaks during work',
      'Listen to calming music',
      'Try progressive muscle relaxation'
    ],
    'Anxious': [
      'Ground yourself with the 5-4-3-2-1 technique',
      'Limit caffeine intake',
      'Practice mindfulness meditation',
      'Challenge anxious thoughts with facts',
      'Establish a bedtime routine'
    ],
    'Happy': [
      'Share your positive mood with others',
      'Do something creative',
      'Help someone else',
      'Celebrate small wins',
      'Express gratitude'
    ],
    'Neutral': [
      'Try something new to spark interest',
      'Reflect on recent experiences',
      'Plan something to look forward to',
      'Check in with your needs',
      'Engage in light physical activity'
    ],
  };

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    try {
      _moodStatsService = await MoodStatsService.create();
      await _loadMoodStats();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load mood stats: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _loadMoodStats() async {
    setState(() => _isLoading = true);

    try {
      final stats = await _moodStatsService.getMoodStats(_selectedPeriod);
      setState(() {
        _moodStats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load mood stats: ${e.toString()}')),
        );
      }
    }
  }

  void _onPeriodSelected(TimePeriod period) {
    setState(() {
      _selectedPeriod = period;
    });
    _loadMoodStats();
  }

  Color _getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return const Color(0xFF4CAF50);
      case 'sad':
      case 'depressed':
        return const Color(0xFFF44336);
      case 'anxious':
        return const Color(0xFF9C27B0);
      case 'stressed':
        return const Color(0xFF607D8B);
      case 'neutral':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF607D8B);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with back button
            Padding(
              padding: EdgeInsets.only(left: 20.w, top: 16.h, right: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ColorStyles.cardColor.withOpacity(0.3),
                          width: 1.w,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18.sp,
                        color: ColorStyles.fontMainColor,
                      ),
                    ),
                  ),
                  // Stats icon
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorStyles.cardColor.withOpacity(0.2),
                    ),
                    child: Icon(
                      Icons.bar_chart_rounded,
                      size: 22.sp,
                      color: ColorStyles.fontMainColor,
                    ),
                  ),
                ],
              ),
            ),

            // Title
            Padding(
              padding: EdgeInsets.only(left: 20.w, top: 16.h),
              child: Text(
                'Mood Stats',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorStyles.fontMainColor,
                ),
              ),
            ),

            // Subtitle
            Padding(
              padding: EdgeInsets.only(left: 20.w, top: 4.h),
              child: Text(
                'Track your mood patterns and insights',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: ColorStyles.fontMainColor.withOpacity(0.7),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Time period selector
            TimePeriodSelector(
              selectedPeriod: _selectedPeriod,
              onPeriodSelected: _onPeriodSelected,
            ),

            SizedBox(height: 16.h),

            // Main content area
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _moodStats == null || _moodStats!.dailyMoods.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.sentiment_neutral,
                                size: 64.sp,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'No mood data available',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Start writing in your journal to track your mood',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[500],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              // Mood chart section
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 16.w),
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Mood Overview',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    SizedBox(
                                      height: 200.h,
                                      child: _buildBarChart(),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 16.h),

                              // Daily mood details
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 16.w),
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Daily Mood Details',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    ..._buildDailyMoodDetails(),
                                  ],
                                ),
                              ),

                              SizedBox(height: 20.h),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    if (_moodStats == null || _moodStats!.dailyMoods.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _moodStats!.dailyMoods.length,
      itemBuilder: (context, index) {
        final dailyMood = _moodStats!.dailyMoods[index];
        final day = DateFormat('E').format(dailyMood.date).substring(0, 1);
        final height = dailyMood.stressLevel * 30.0;
        final color = _getMoodColor(dailyMood.primaryMood);

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 30.w,
                height: height,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(8.r),
                  ),
                ),
                child: Center(
                  child: Text(
                    dailyMood.stressLevel.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                day,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildDailyMoodDetails() {
    if (_moodStats == null || _moodStats!.dailyMoods.isEmpty) {
      return [const Text('No mood data available')];
    }

    return _moodStats!.dailyMoods.map((dailyMood) {
      final color = _getMoodColor(dailyMood.primaryMood);

      return Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEEE, MMM d').format(dailyMood.date),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: color.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    dailyMood.primaryMood,
                    style: TextStyle(
                      color: color,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.mood_bad_sharp,
                  size: 16.sp,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 8.w),
                Text(
                  'Stress Level: ${dailyMood.stressLevel}/5',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  size: 16.sp,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 8.w),
                Text(
                  'Stressor: ${dailyMood.stressor}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            if (_suggestions.containsKey(dailyMood.primaryMood))
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.lightbulb_outline,
                      size: 20.sp,
                      color: Colors.amber[600],
                    ),
                    onPressed: () {
                      _showSuggestionsDialog(dailyMood.primaryMood);
                    },
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Suggestions available',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
          ],
        ),
      );
    }).toList();
  }

  void _showSuggestionsDialog(String mood) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Suggestions for $mood'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _suggestions[mood]?.length ?? 0,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(
                    Icons.check_circle_outline,
                    color: Colors.blue[400],
                  ),
                  title: Text(_suggestions[mood]![index]),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
