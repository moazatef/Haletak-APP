// ignore_for_file: use_build_context_synchronously

import 'package:aluna/core/routing/routes.dart';
import 'package:aluna/core/theme/colors.dart';
import 'package:aluna/features/aluna_assement/data/service/user_age_service.dart';
import 'package:aluna/features/aluna_assement/presentation/widgets/weight_slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeightSelectionScreen extends StatefulWidget {
  final Function()? onContinue;

  const WeightSelectionScreen({super.key, this.onContinue});

  @override
  State<WeightSelectionScreen> createState() => _WeightSelectionScreenState();
}

class _WeightSelectionScreenState extends State<WeightSelectionScreen> {
  final UserService _userService = UserService();
  int _selectedWeight = 70;

  void _saveWeightAndContinue() async {
    try {
      await _userService.saveUserWeight(_selectedWeight);
      if (widget.onContinue != null) {
        widget.onContinue!();
        Navigator.pushNamed(context, Routes.professionalHelpQuestion);
      } else {
        // Navigate to next screen if onContinue callback is not provided
        Navigator.pushNamed(context, Routes.professionalHelpQuestion);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                '4 of 13',
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
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Text(
              "What's your weight?",
              style: TextStyle(
                color: ColorStyles.fontMainColor,
                fontSize: 35.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: _selectedWeight.toString(),
                      style: TextStyle(
                        color: ColorStyles.mainColor,
                        fontSize: 80.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'kg',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            WeightSliderWidget(
              currentWeight: _selectedWeight,
              onWeightChanged: (weight) {
                setState(() {
                  _selectedWeight = weight;
                });
              },
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0.h),
              child: SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: _saveWeightAndContinue,
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
