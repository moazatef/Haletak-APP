import 'package:aluna/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors.dart';

class ButttonOnBoarding extends StatelessWidget {
  const ButttonOnBoarding(
      {super.key,
      required Null Function() onPressed,
      required String text,
      required int height,
      required color});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorStyles.mainColor,
        padding: EdgeInsets.symmetric(horizontal: 100.w, vertical: 20.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, Routes.healthGoalScreen);
      },
      child: Text(
        "Get Started",
        style: TextStyle(
          fontSize: 18.sp,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
