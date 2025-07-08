import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/colors.dart';
import '../../data/model/journal_entry.dart';

class JournalItem extends StatelessWidget {
  final Journal journal;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const JournalItem({
    super.key,
    required this.journal,
    required this.onDelete,
    required this.onEdit,
  });

  // Get the predicted mood from ML response or fallback to manual emotion
  String _getDisplayMood() {
    if (journal.mlResponse != null) {
      return journal.mlResponse!.predictedMood;
    }
    return journal.emotion ?? 'Neutral';
  }

  Color _getMoodColor() {
    final mood = _getDisplayMood().toLowerCase();

    if (mood.contains('happy')) return const Color(0xFF8BC34A);
    if (mood.contains('normal')) return const Color(0xFF2196F3);
    if (mood.contains('depress')) return const Color(0xFFCE93D8);
    if (mood.contains('stress')) return Colors.orange;
    if (mood.contains('anxiety')) return const Color(0xFFEF9A9A);
    if (mood.contains('sad')) return const Color(0xFF607D8B);

    // Fallback colors for manual emotions
    switch (journal.emotion) {
      case 'Very Happy':
        return Colors.lightGreen;
      case 'Happy':
        return const Color(0xFFFFC107);
      case 'Neutral':
        return const Color(0xFFBCAAA4);
      case 'Sad':
        return Colors.orange;
      case 'Very Sad':
        return Colors.purple.shade200;
      default:
        return Colors.grey;
    }
  }

  IconData _getStressorIcon() {
    switch (journal.stressor) {
      case 'Loneliness':
        return Icons.person_off;
      case 'Money Issue':
        return Icons.money_off;
      case 'Pain':
        return Icons.healing;
      case 'Family Issue':
        return Icons.family_restroom;
      case 'Work Issue':
        return Icons.work_off;
      case 'Relationship Issue':
        return Icons.heart_broken;
      case 'Health Issue':
        return Icons.medical_services;
      case 'Other':
      default:
        return Icons.more_horiz;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('h:mm a').format(journal.createdAt);
    final moodColor = _getMoodColor();
    final displayMood = _getDisplayMood();

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line and circle
          Column(
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: moodColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getStressorIcon(),
                  color: Colors.white,
                  size: 14.sp,
                ),
              ),
              Container(
                width: 2.w,
                height: 100.h,
                color: Colors.grey.withOpacity(0.3),
              ),
            ],
          ),
          SizedBox(width: 12.w),
          // Journal content
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title with mood tag
                      Row(
                        children: [
                          Text(
                            journal.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: ColorStyles.fontMainColor,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: moodColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              displayMood,
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: moodColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Options menu
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.grey.shade600,
                          size: 20.sp,
                        ),
                        onSelected: (value) {
                          if (value == 'edit') {
                            onEdit();
                          } else if (value == 'delete') {
                            onDelete();
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // Journal content
                  Text(
                    journal.text,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorStyles.fontSmallBoldColor,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.h),
                  // Confidence indicator if ML response exists
                  if (journal.mlResponse != null) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.psychology,
                          color: moodColor,
                          size: 14.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${journal.mlResponse!.confidence.toStringAsFixed(1)}% confident',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                  ],
                  // Metadata (suggestions & time)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: ColorStyles.mainColor,
                            size: 16.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${journal.stressLevel ?? 3} Suggestions',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: ColorStyles.mainColor,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        formattedTime,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
