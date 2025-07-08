// lib/presentation/screens/health_goal_screen.dart
import 'package:aluna/core/theme/colors.dart';
import 'package:aluna/features/aluna_assement/logic/health_goal_provider.dart';
import 'package:aluna/features/aluna_assement/presentation/widgets/custom_button_assment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/health_goal_option.dart';

class HealthGoalScreen extends ConsumerWidget {
  const HealthGoalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthGoalState = ref.watch(healthGoalProvider);
    final healthGoalNotifier = ref.read(healthGoalProvider.notifier);

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
                '1 of 13',
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
            SizedBox(height: 16.h),
            Text(
              "What's your health goal\nfor today?",
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: ColorStyles.fontMainColor,
              ),
            ),
            SizedBox(height: 32.h),
            HealthGoalOption(
              icon: Icons.favorite_border,
              label: 'I wanna reduce stress',
              isSelected: healthGoalState.selectedGoal == 'reduce_stress',
              onTap: () => healthGoalNotifier.setGoal('reduce_stress'),
            ),
            SizedBox(height: 12.h),
            HealthGoalOption(
              icon: Icons.psychology,
              label: 'I wanna try AI Therapy',
              isSelected: healthGoalState.selectedGoal == 'ai_therapy',
              onTap: () => healthGoalNotifier.setGoal('ai_therapy'),
            ),
            SizedBox(height: 12.h),
            HealthGoalOption(
              icon: Icons.healing,
              label: 'I want to cope with trauma',
              isSelected: healthGoalState.selectedGoal == 'cope_trauma',
              onTap: () => healthGoalNotifier.setGoal('cope_trauma'),
            ),
            SizedBox(height: 12.h),
            HealthGoalOption(
              icon: Icons.person,
              label: 'I want to be a better person',
              isSelected: healthGoalState.selectedGoal == 'better_person',
              onTap: () => healthGoalNotifier.setGoal('better_person'),
            ),
            SizedBox(height: 12.h),
            HealthGoalOption(
              icon: Icons.remove_red_eye,
              label: 'Just trying out the app, mate!',
              isSelected: healthGoalState.selectedGoal == 'trying_app',
              onTap: () => healthGoalNotifier.setGoal('trying_app'),
            ),
            const Spacer(),
            CustomButtonAssment(
              label: 'Continue',
              icon: Icons.arrow_forward,
              onPressed: healthGoalState.selectedGoal.isEmpty
                  ? null
                  : () => healthGoalNotifier.saveGoalToFirebase(context),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
