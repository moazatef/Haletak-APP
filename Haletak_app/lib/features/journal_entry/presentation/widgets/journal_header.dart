import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';
import '../../../../features/home/presentation/widgets/clip_header_widget.dart';

class JournalHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const JournalHeader({
    super.key,
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: BarClipper(),
          child: Container(
            height: 180.h,
            color: ColorStyles.mainColor,
          ),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child:
                            const Icon(Icons.arrow_back, color: Colors.black54),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      title,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
