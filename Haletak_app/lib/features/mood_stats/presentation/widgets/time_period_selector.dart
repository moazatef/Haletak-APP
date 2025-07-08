// lib/features/mood_stats/presentation/widgets/time_period_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aluna/core/theme/colors.dart';
import 'package:aluna/features/mood_stats/data/model/mood_stats.dart';

class TimePeriodSelector extends StatelessWidget {
  final TimePeriod selectedPeriod;
  final Function(TimePeriod) onPeriodSelected;

  const TimePeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildPeriodButton(TimePeriod.day),
          SizedBox(width: 8.w),
          _buildPeriodButton(TimePeriod.week),
          SizedBox(width: 8.w),
          _buildPeriodButton(TimePeriod.month),
          SizedBox(width: 8.w),
          _buildPeriodButton(TimePeriod.year),
          SizedBox(width: 8.w),
          _buildPeriodButton(TimePeriod.allTime),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(TimePeriod period) {
    final isSelected = selectedPeriod == period;

    return InkWell(
      onTap: () => onPeriodSelected(period),
      borderRadius: BorderRadius.circular(36),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36),
          color: isSelected
              ? const Color.fromARGB(255, 52, 36, 84)
              : Colors.transparent,
        ),
        alignment: Alignment.center,
        child: Text(
          period.displayText,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : ColorStyles.fontMainColor,
          ),
        ),
      ),
    );
  }
}
