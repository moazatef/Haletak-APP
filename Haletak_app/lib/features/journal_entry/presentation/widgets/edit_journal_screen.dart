// lib/features/journal/presentation/screens/edit_journal_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors.dart';
import '../../data/model/journal_entry.dart';
import '../../data/services/journal_service.dart';
import '../widgets/emotion_selector.dart';
import '../widgets/journal_header.dart';
import '../widgets/stressor_selector.dart';

class EditJournalScreen extends StatefulWidget {
  final int userId;
  final Journal journal;

  const EditJournalScreen({
    super.key,
    required this.journal,
    required this.userId,
  });

  @override
  _EditJournalScreenState createState() => _EditJournalScreenState();
}

class _EditJournalScreenState extends State<EditJournalScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late int _stressLevel;
  late String _selectedEmotion;
  late String _selectedStressor;
  bool _isLoading = false;

  late JournalService _journalService;

  @override
  void initState() {
    super.initState();
    _journalService = JournalService(
        token: '3|XBjswW4StP3cidCcsZDuzq3WyWeALNkI1e91Ihpv4d1c27df');

    // Initialize controllers with existing data
    _titleController = TextEditingController(text: widget.journal.title);
    _contentController = TextEditingController(text: widget.journal.text);
    _stressLevel = widget.journal.stressLevel ?? 3;
    _selectedEmotion = widget.journal.emotion ?? 'Neutral';
    _selectedStressor = widget.journal.stressor ?? 'Loneliness';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _updateJournal() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedJournal = Journal(
        id: widget.journal.id,
        title: _titleController.text,
        text: _contentController.text,
        stressLevel: _stressLevel,
        emotion: _selectedEmotion,
        stressor: _selectedStressor,
        createdAt: widget.journal.createdAt,
      );

      await _journalService.updateJournal(
        widget.userId,
        widget.journal.id!,
        updatedJournal,
      );

      // Success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Journal updated successfully')),
        );
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: Column(
        children: [
          JournalHeader(
            title: 'Edit Journal',
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      'Journal Title',
                      style: TextStyle(
                        color: ColorStyles.fontMainColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/file.png',
                            width: 20.sp,
                            height: 20.sp,
                            color: ColorStyles.fontMainColor,
                          ),
                          SizedBox(width: 5.w),
                          Expanded(
                            child: TextField(
                              controller: _titleController,
                              decoration: const InputDecoration(
                                hintText: 'Enter a title for your journal',
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          Image.asset(
                            'assets/images/feather-pen.png',
                            width: 25.sp,
                            height: 25.sp,
                            color: ColorStyles.fontMainColor,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Write Your Entry',
                      style: TextStyle(
                        color: ColorStyles.fontMainColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(
                          color: _contentController.text.isNotEmpty
                              ? ColorStyles.mainColor
                              : Colors.grey.shade200,
                        ),
                        boxShadow: _contentController.text.isNotEmpty
                            ? [
                                const BoxShadow(
                                  color: ColorStyles.fontSmallBoldColor,
                                  blurRadius: 5,
                                  offset: Offset(0.5, 0.5),
                                )
                              ]
                            : null,
                      ),
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        children: [
                          TextField(
                            controller: _contentController,
                            maxLines: 5,
                            onChanged: (text) => setState(() {}),
                            textInputAction: TextInputAction.done,
                            onSubmitted: (text) {
                              FocusScope.of(context).unfocus();
                            },
                            decoration: const InputDecoration(
                              hintText: "Write your journal entry here...",
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          SizedBox(height: 15.h),
                        ],
                      ),
                    ),
                    SizedBox(height: 25.h),
                    Text(
                      'Stress Level',
                      style: TextStyle(
                        color: ColorStyles.fontMainColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 8.h,
                        activeTrackColor: ColorStyles.mainColor,
                        inactiveTrackColor: Colors.grey.shade300,
                        thumbColor: Colors.white,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 10.r),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 20.r),
                      ),
                      child: Column(
                        children: [
                          Slider(
                            value: _stressLevel.toDouble(),
                            min: 1,
                            max: 5,
                            divisions: 4,
                            onChanged: (value) {
                              setState(() {
                                _stressLevel = value.toInt();
                              });
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('1'),
                                Text('3'),
                                Text('5'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    EmotionSelector(
                      selectedEmotion: _selectedEmotion,
                      onEmotionSelected: (emotion) {
                        setState(() {
                          _selectedEmotion = emotion;
                        });
                      },
                    ),
                    SizedBox(height: 20.h),
                    StressorSelector(
                      selectedStressor: _selectedStressor,
                      onStressorSelected: (stressor) {
                        setState(() {
                          _selectedStressor = stressor;
                        });
                      },
                    ),
                    SizedBox(height: 30.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _updateJournal,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorStyles.mainColor,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                                strokeWidth: 3.w,
                              )
                            : Text(
                                'Update Journal',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
