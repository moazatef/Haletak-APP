// lib/presentation/widgets/gender_option_card.dart
import 'package:aluna/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenderOptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String imagePath;
  final bool isSelected;
  final Color backgroundColor;
  final VoidCallback onTap;

  const GenderOptionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.imagePath,
    required this.isSelected,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 200.h,
        decoration: BoxDecoration(
          color: ColorStyles.fontButtonColor,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected ? ColorStyles.mainColor : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 16.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: ColorStyles.mainColor,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              icon,
              size: 20.sp,
              color: Colors.grey.shade700,
            ),
            const Spacer(),
            // Right side avatar image with colored background
            Container(
              width: 150.w,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24.r),
                    bottomRight: Radius.circular(24.r),
                    topLeft: Radius.circular(24.r),
                    bottomLeft: Radius.circular(24.r)),
              ),
              child: Stack(
                children: [
                  // Sparkles/stars
                  Positioned(
                    top: 10.h,
                    right: 20.w,
                    child: Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20.sp,
                    ),
                  ),
                  Positioned(
                    top: 30.h,
                    right: 40.w,
                    child: Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20.sp,
                    ),
                  ),
                  // Avatar image
                  Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      imagePath,
                      height: 300.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
