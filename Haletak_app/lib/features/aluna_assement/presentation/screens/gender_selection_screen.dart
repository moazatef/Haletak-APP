// lib/presentation/screens/gender_selection_screen.dart
import 'package:aluna/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../logic/gender_selection_provider.dart';
import '../widgets/custom_button_assment.dart';
import '../widgets/gender_option_card.dart';

class GenderSelectionScreen extends ConsumerWidget {
  const GenderSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genderState = ref.watch(genderSelectionProvider);
    final genderNotifier = ref.read(genderSelectionProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.w),
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
              child: const Text(
                '2 of 13',
                style: TextStyle(
                  color: ColorStyles.fontButtonColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 24.h),
            Text(
              "What's your gender?",
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: ColorStyles.fontMainColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            GenderOptionCard(
              title: 'I am Male',
              icon: Icons.male,
              imagePath: 'assets/images/male.png',
              isSelected: genderState.selectedGender == 'male',
              backgroundColor:
                  const Color(0xFFD1E0C5), // Light green background
              onTap: () => genderNotifier.setGender('male'),
            ),
            SizedBox(height: 16.h),
            GenderOptionCard(
              title: 'I am Female',
              icon: Icons.female,
              imagePath: 'assets/images/female.png',
              isSelected: genderState.selectedGender == 'female',
              backgroundColor:
                  const Color(0xFFFBD3A5), // Light orange background
              onTap: () => genderNotifier.setGender('female'),
            ),
            SizedBox(height: 24.h),
            TextButton.icon(
              onPressed: () {
                genderNotifier.setGender('skip');
                genderNotifier.saveGenderToFirebase(context);
              },
              icon: Icon(Icons.close, color: Colors.grey.shade600),
              label: Text(
                'Prefer to skip, thanks',
                style: TextStyle(
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.green.shade50,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
            ),
            const Spacer(),
            CustomButtonAssment(
              label: 'Continue',
              icon: Icons.arrow_forward,
              onPressed: genderState.selectedGender.isEmpty ||
                      genderState.selectedGender == 'skip'
                  ? null
                  : () => genderNotifier.saveGenderToFirebase(context),
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
