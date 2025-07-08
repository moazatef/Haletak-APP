// lib/features/journal/presentation/widgets/date_selector.dart
import 'package:aluna/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final List<DateTime>?
      datesWithEntries; // Optional list of dates that have entries

  const DateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.datesWithEntries,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late DateTime _currentStartDate;
  late DateTime _currentEndDate;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _initializeDateRange();
  }

  @override
  void didUpdateWidget(covariant DateSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _selectedDate = widget.selectedDate;
      _initializeDateRange();
    }
  }

  void _initializeDateRange() {
    // Show 2 weeks by default (1 week before and after selected date)
    _currentStartDate = _selectedDate.subtract(const Duration(days: 7));
    _currentEndDate = _selectedDate.add(const Duration(days: 7));
  }

  List<DateTime> _getDaysInRange() {
    final days = <DateTime>[];
    DateTime current = _currentStartDate;

    while (current.isBefore(_currentEndDate) ||
        current.isAtSameMomentAs(_currentEndDate)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }
    return days;
  }

  void _loadMoreDates(bool loadEarlier) {
    setState(() {
      if (loadEarlier) {
        _currentStartDate = _currentStartDate.subtract(const Duration(days: 7));
      } else {
        _currentEndDate = _currentEndDate.add(const Duration(days: 7));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final daysInRange = _getDaysInRange();

    return Column(
      children: [
        // Month/year indicator
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, size: 24.sp),
                onPressed: () => _loadMoreDates(true),
              ),
              Text(
                DateFormat('MMMM yyyy').format(_selectedDate),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorStyles.fontMainColor,
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, size: 24.sp),
                onPressed: () => _loadMoreDates(false),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        // Date selector
        Container(
          margin: EdgeInsets.symmetric(vertical: 8.h),
          height: 80.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: daysInRange.length,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemBuilder: (context, index) {
              final day = daysInRange[index];
              final isSelected = day.day == _selectedDate.day &&
                  day.month == _selectedDate.month &&
                  day.year == _selectedDate.year;

              final dayName = DateFormat('E').format(day).substring(0, 3);
              final dayNumber = day.day.toString();

              final isToday = day.day == DateTime.now().day &&
                  day.month == DateTime.now().month &&
                  day.year == DateTime.now().year;

              final hasEntries = widget.datesWithEntries?.any((entryDate) =>
                      entryDate.day == day.day &&
                      entryDate.month == day.month &&
                      entryDate.year == day.year) ??
                  false;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = day;
                  });
                  widget.onDateSelected(day);
                },
                child: Container(
                  width: 48.w,
                  margin: EdgeInsets.only(right: 8.w),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? ColorStyles.mainColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayName,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isSelected
                              ? Colors.white
                              : ColorStyles.fontMainColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 28.w,
                            height: 28.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isToday
                                  ? ColorStyles.mainColor.withOpacity(0.2)
                                  : Colors.transparent,
                              border: isSelected
                                  ? Border.all(
                                      color: Colors.white,
                                      width: 2.w,
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                dayNumber,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: isSelected
                                      ? Colors.white
                                      : ColorStyles.fontMainColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          if (hasEntries && !isSelected)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 6.w,
                                height: 6.w,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorStyles.mainColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
