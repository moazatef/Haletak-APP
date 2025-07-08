// lib/features/mood/presentation/screens/mood_reason_screen.dart
import 'package:aluna/core/theme/colors.dart';
import 'package:aluna/features/mood-check-in/logic/reson_provider.dart';
import 'package:aluna/features/mood-check-in/presentation/screens/reason_widgit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MoodReasonScreen extends ConsumerStatefulWidget {
  const MoodReasonScreen({super.key});

  @override
  ConsumerState<MoodReasonScreen> createState() => _MoodReasonScreenState();
}

class _MoodReasonScreenState extends ConsumerState<MoodReasonScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moodState = ref.watch(moodStateProvider);
    final moodNotifier = ref.read(moodStateProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            Text(
              "What's reason making you feel\nthis way?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Select reasons that reflected your emotions",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search & add reasons",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                moodNotifier.searchReasons(value);
              },
            ),
            SizedBox(height: 20.h),
            if (moodState.recentlyUsedReasons.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Recently used",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: moodState.recentlyUsedReasons
                    .map((reason) => ReasonChip(
                          reason: reason,
                          isSelected:
                              moodState.selectedReasons.contains(reason),
                          onSelected: (selected) {
                            moodNotifier.toggleReason(reason);
                          },
                        ))
                    .toList(),
              ),
            ],
            SizedBox(height: 16.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "All reasons",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  ...moodState.displayedReasons.map((reason) => ReasonChip(
                        reason: reason,
                        isSelected: moodState.selectedReasons.contains(reason),
                        onSelected: (selected) {
                          moodNotifier.toggleReason(reason);
                        },
                      )),
                  GestureDetector(
                    onTap: () {
                      moodNotifier.loadMoreReasons();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: 16.sp),
                          SizedBox(width: 4.w),
                          const Text("More"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: ElevatedButton(
                onPressed: moodState.selectedReasons.isNotEmpty
                    ? () {
                        moodNotifier.saveSelectedReasons();
                        Navigator.pushNamed(context, '/addJournalScreen');
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorStyles.mainColor,
                  minimumSize: Size(double.infinity, 56.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  disabledBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
                ),
                child: Text(
                  "Continue",
                  style: TextStyle(
                    color: ColorStyles.fontButtonColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
