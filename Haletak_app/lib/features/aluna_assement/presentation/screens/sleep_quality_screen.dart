// ignore_for_file: use_build_context_synchronously

import 'package:aluna/core/routing/routes.dart';
import 'package:aluna/features/aluna_assement/data/model/sleep_quality_model.dart';
import 'package:aluna/features/aluna_assement/data/service/sleep_quality_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/sleep_quality_slider.dart';
import 'package:aluna/core/theme/colors.dart';

class SleepQualityScreen extends StatefulWidget {
  const SleepQualityScreen({super.key});

  @override
  _SleepQualityScreenState createState() => _SleepQualityScreenState();
}

class _SleepQualityScreenState extends State<SleepQualityScreen> {
  final SleepQualityService _sleepQualityService = SleepQualityService();
  late SleepQualityOption _selectedOption;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final savedQuality = await _sleepQualityService.getSleepQuality();

      if (savedQuality != null) {
        final matchingOption = sleepQualityOptions.firstWhere(
          (option) => option.rating == savedQuality.rating,
          orElse: () => sleepQualityOptions[2],
        );
        setState(() {
          _selectedOption = matchingOption;
          _isLoading = false;
        });
      } else {
        setState(() {
          _selectedOption = sleepQualityOptions[2];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading sleep quality: $e');
      setState(() {
        _selectedOption = sleepQualityOptions[2];
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSleepQuality() async {
    try {
      final hoursRange = _selectedOption.hoursRange;
      int hours;

      if (hoursRange.contains('-')) {
        final parts = hoursRange.split('-');
        final min = int.parse(parts[0]);
        final max = int.parse(parts[1]);
        hours = ((min + max) / 2).round();
      } else if (hoursRange.contains('<')) {
        hours = 2;
      } else {
        hours = int.parse(hoursRange);
      }

      final sleepQuality = SleepQuality(
        rating: _selectedOption.rating,
        hoursRange: _selectedOption.hoursRange,
        hours: hours,
      );

      await _sleepQualityService.saveSleepQuality(sleepQuality);
      Navigator.pushNamed(context, Routes.medicationScreen);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving: $e')),
      );
    }
  }

  final List<SleepQualityOption> sleepQualityOptions = [
    SleepQualityOption(
      rating: 'Excellent',
      hoursRange: '7-9',
      displayHours: '7-9 HOURS',
      emojiWidget:
          Image.asset('assets/images/moodoverjoyed.png', width: 50, height: 50),
      value: 4,
    ),
    SleepQualityOption(
      rating: 'Good',
      hoursRange: '6-7',
      displayHours: '6-7 HOURS',
      emojiWidget:
          Image.asset('assets/images/moodhappy.png', width: 50, height: 50),
      value: 3,
    ),
    SleepQualityOption(
      rating: 'Fair',
      hoursRange: '5',
      displayHours: '5 HOURS',
      emojiWidget:
          Image.asset('assets/images/moodneutral.png', width: 50, height: 50),
      value: 2,
    ),
    SleepQualityOption(
      rating: 'Poor',
      hoursRange: '3-4',
      displayHours: '3-4 HOURS',
      emojiWidget:
          Image.asset('assets/images/moodsad.png', width: 50, height: 50),
      value: 1,
    ),
    SleepQualityOption(
      rating: 'Worst',
      hoursRange: '<3',
      displayHours: '<3 HOURS',
      emojiWidget:
          Image.asset('assets/images/mooddepressed.png', width: 50, height: 50),
      value: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black54),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Assessment',
          style: TextStyle(
            color: ColorStyles.fontMainColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: ColorStyles.mainColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                '8 of 13',
                style: TextStyle(
                  color: ColorStyles.fontButtonColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'How would you rate your sleep quality?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: ColorStyles.fontMainColor,
                ),
              ),
            ),
            const SizedBox(height: 40),
            SleepQualitySlider(
              options: sleepQualityOptions,
              initialValue: _selectedOption,
              onChanged: (option) {
                setState(() {
                  _selectedOption = option;
                });
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: _saveSleepQuality,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorStyles.mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      const Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
