// ignore_for_file: use_build_context_synchronously

import 'package:aluna/core/routing/routes.dart';
import 'package:aluna/core/theme/colors.dart';
import 'package:aluna/features/aluna_assement/data/service/user_age_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhysicalDistressScreen extends StatefulWidget {
  const PhysicalDistressScreen({super.key});

  @override
  State<PhysicalDistressScreen> createState() => _PhysicalDistressScreenState();
}

class _PhysicalDistressScreenState extends State<PhysicalDistressScreen> {
  String? selectedOption;
  final UserService _userService = UserService();

  void _savePhysicalDistressInfo() async {
    try {
      bool hasPhysicalDistress = selectedOption == 'yes';
      await _userService.updateUserField(
          'hasPhysicalDistress', hasPhysicalDistress);

      // Navigate to next screen
      Navigator.pushNamed(context, Routes.sleepQualityScreen);
    } catch (e) {
      // Show error if saving fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.backgroundColor,
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
                '6 of 13',
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                'Are you experiencing any physical distress?',
                style: TextStyle(
                  color: ColorStyles.fontMainColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
              _buildOption(
                title: 'Yes, one or multiple',
                description:
                    'I\'m experiencing physical pain in different places over my body.',
                value: 'yes',
              ),
              SizedBox(
                height: 16.h,
              ),
              _buildOption(
                title: 'No Physical Pain At All',
                description:
                    'I\'m not experiencing any physical pain in my body at all :)',
                value: 'no',
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed:
                      selectedOption == null ? null : _savePhysicalDistressInfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorStyles.mainColor,
                    disabledBackgroundColor:
                        ColorStyles.mainColor.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption({
    required String title,
    required String description,
    required String value,
    Color? color,
  }) {
    final isSelected = selectedOption == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = value;
        });
      },
      child: SizedBox(
        height: 150.h,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color ?? Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? ColorStyles.mainColor : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: ColorStyles.fontMainColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: ColorStyles.fontSmallBoldColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
