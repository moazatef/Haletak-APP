// lib/features/journal/presentation/widgets/stressor_selector.dart
import 'package:aluna/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StressorOption {
  final String name;

  StressorOption({
    required this.name,
  });
}

class StressorSelector extends StatelessWidget {
  final String selectedStressor;
  final Function(String) onStressorSelected;

  StressorSelector({
    super.key,
    required this.selectedStressor,
    required this.onStressorSelected,
  });

  final List<StressorOption> stressors = [
    StressorOption(name: 'Loneliness'),
    StressorOption(name: 'Money Issue'),
    StressorOption(name: 'Pain'),
    StressorOption(name: 'Family Issue'),
    StressorOption(name: 'Work Issue'),
    StressorOption(name: 'Relationship Issue'),
    StressorOption(name: 'Health Issue'),
    StressorOption(name: 'Other'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Stressor',
          style: TextStyle(
            fontSize: 18.sp,
            color: ColorStyles.fontMainColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 5.h,
          children: stressors.map((stressor) {
            final isSelected = selectedStressor == stressor.name;
            return GestureDetector(
              onTap: () => onStressorSelected(stressor.name),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.lightGreen
                      : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      stressor.name,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    if (isSelected)
                      Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
