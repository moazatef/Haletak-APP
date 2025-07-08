import 'package:aluna/core/routing/routes.dart';
import 'package:aluna/core/theme/colors.dart';
import 'package:aluna/features/aluna_assement/data/service/user_stresss_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StressLevelScreen extends StatefulWidget {
  const StressLevelScreen({super.key});

  @override
  _StressLevelScreenState createState() => _StressLevelScreenState();
}

class _StressLevelScreenState extends State<StressLevelScreen> {
  int _selectedLevel = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.backgroundColor, // Apply custom color
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
                '12 of 13',
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Title
            const Text(
              "How would you rate your stress level?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: ColorStyles.fontMainColor,
              ),
            ),
            const SizedBox(height: 24),

            // Selected Stress Level
            Text(
              _selectedLevel.toString(),
              style: const TextStyle(
                fontSize: 120,
                fontWeight: FontWeight.bold,
                color: ColorStyles.fontMainColor,
              ),
            ),

            const SizedBox(height: 20),

            // Horizontal Selection
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: ColorStyles.mainColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  int value = index + 1;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLevel = value;
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: _selectedLevel == value
                          ? ColorStyles.mainColor
                          : Colors.transparent,
                      radius: 20,
                      child: Text(
                        value.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _selectedLevel == value
                              ? Colors.white
                              : ColorStyles.fontMainColor,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            // Stress Level Description
            Text(
              _getStressDescription(_selectedLevel),
              style: const TextStyle(
                fontSize: 20,
                color: ColorStyles.fontMainColor,
                fontWeight: FontWeight.w500,
              ),
            ),

            const Spacer(),
            // Continue Button
            ElevatedButton(
              onPressed: () {
                StressLevelService.saveStressLevel(_selectedLevel);
                Navigator.pushNamed(context, Routes.aiSoundAnalysisScreen);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorStyles.mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Continue ",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  const Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
            SizedBox(height: 14.h),
          ],
        ),
      ),
    );
  }

  String _getStressDescription(int level) {
    switch (level) {
      case 1:
        return "Very Relaxed";
      case 2:
        return "Slightly Stressed";
      case 3:
        return "Moderately Stressed";
      case 4:
        return "Highly Stressed";
      case 5:
        return "Extremely Stressed Out.";
      default:
        return "";
    }
  }
}
