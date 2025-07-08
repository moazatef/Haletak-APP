// lib/features/mood_stats/presentation/widgets/mood_chart.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../data/model/mood_stats.dart';

class MoodChart extends StatefulWidget {
  final List<DailyMood> dailyMoods;

  const MoodChart({
    super.key,
    required this.dailyMoods,
  });

  @override
  State<MoodChart> createState() => _MoodChartState();
}

class _MoodChartState extends State<MoodChart> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int? _selectedDayIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dailyMoods.isEmpty) {
      return SizedBox(
        height: 300.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 48.sp,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16.h),
              Text(
                'No mood data available',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 350.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[900]!.withOpacity(0.05),
            Colors.grey[800]!.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.grey[300]!.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          SizedBox(height: 12.h),
          _buildLegend(),
          SizedBox(height: 16.h),
          Expanded(child: _buildChart()),
          SizedBox(height: 12.h),
          _buildDayLabels(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.analytics,
            color: Colors.white,
            size: 20.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          'Mood Analytics',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      spacing: 6.w,
      children: [
        _buildLegendItem(
            'Happy', const Color(0xFF4CAF50), Icons.sentiment_satisfied),
        _buildLegendItem(
            'Neutral', const Color(0xFFFF9800), Icons.sentiment_neutral),
        _buildLegendItem('Depressed', const Color(0xFFF44336),
            Icons.sentiment_very_dissatisfied),
        _buildLegendItem(
            'Anxiety', const Color(0xFF9C27B0), Icons.sentiment_dissatisfied),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12.sp),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    return GestureDetector(
      onTapDown: (details) {
        final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final localPosition = renderBox.globalToLocal(details.globalPosition);
          _handleTap(localPosition);
        }
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            size: Size.infinite,
            painter: DominantMoodChartPainter(
              dailyMoods: widget.dailyMoods,
              animation: _animation.value,
              selectedDayIndex: _selectedDayIndex,
            ),
          );
        },
      ),
    );
  }

  void _handleTap(Offset position) {
    final displayData = widget.dailyMoods.length > 7
        ? widget.dailyMoods.sublist(widget.dailyMoods.length - 7)
        : widget.dailyMoods;

    if (displayData.isEmpty) return;

    final chartWidth = MediaQuery.of(context).size.width - 64.w;
    final barWidth = chartWidth / displayData.length;
    final tappedIndex = (position.dx / barWidth).floor();

    if (tappedIndex >= 0 && tappedIndex < displayData.length) {
      setState(() {
        _selectedDayIndex =
            _selectedDayIndex == tappedIndex ? null : tappedIndex;
      });
    }
  }

  Widget _buildDayLabels() {
    final displayData = widget.dailyMoods.length > 7
        ? widget.dailyMoods.sublist(widget.dailyMoods.length - 7)
        : widget.dailyMoods;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(displayData.length > 7 ? 7 : displayData.length,
          (index) {
        final isSelected = _selectedDayIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[100] : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            DateFormat('E').format(displayData[index].date).substring(0, 3),
            style: TextStyle(
              color: isSelected ? Colors.blue[700] : Colors.grey[600],
              fontSize: 11.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      }),
    );
  }
}

class DominantMoodChartPainter extends CustomPainter {
  final List<DailyMood> dailyMoods;
  final double animation;
  final int? selectedDayIndex;

  DominantMoodChartPainter({
    required this.dailyMoods,
    required this.animation,
    this.selectedDayIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final displayData = dailyMoods.length > 7
        ? dailyMoods.sublist(dailyMoods.length - 7)
        : dailyMoods;

    if (displayData.isEmpty) return;

    final double barWidth = (size.width * 0.8) / displayData.length;
    final double spacing = (size.width * 0.2) / (displayData.length + 1);

    // Draw grid lines
    _drawGrid(canvas, size);

    for (int i = 0; i < displayData.length; i++) {
      final mood = displayData[i];
      final x = spacing + i * (barWidth + spacing);
      final isSelected = selectedDayIndex == i;

      // Get dominant mood
      final dominantMood = _getDominantMood(mood);

      _drawBar(canvas, size, x, barWidth, dominantMood, animation, isSelected);
    }
  }

  DominantMoodData _getDominantMood(DailyMood mood) {
    final moods = [
      DominantMoodData('Happy', mood.happyValue, const Color(0xFF4CAF50),
          Icons.sentiment_satisfied),
      DominantMoodData('Neutral', mood.neutralValue, const Color(0xFFFF9800),
          Icons.sentiment_neutral),
      DominantMoodData('Depressed', mood.depressedValue,
          const Color(0xFFF44336), Icons.sentiment_very_dissatisfied),
      DominantMoodData('Anxiety', mood.anxietyValue, const Color(0xFF9C27B0),
          Icons.sentiment_dissatisfied),
    ];

    // Find the mood with highest value
    moods.sort((a, b) => b.value.compareTo(a.value));
    return moods.first;
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.15)
      ..strokeWidth = 0.5;

    for (int i = 1; i <= 4; i++) {
      final y = size.height * (i / 5);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _drawBar(Canvas canvas, Size size, double x, double width,
      DominantMoodData moodData, double animation, bool isSelected) {
    final height = (size.height * 0.8 * (moodData.value / 100)) * animation;
    final y = size.height * 0.9 - height;

    // Glow effect for selected bars
    if (isSelected) {
      final glowPaint = Paint()
        ..color = moodData.color.withOpacity(0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x - 2, y - 2, width + 4, height + 4),
          Radius.circular(6.r),
        ),
        glowPaint,
      );
    }

    // Gradient paint for bars
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        moodData.color.withOpacity(0.7),
        moodData.color,
        moodData.color.withOpacity(0.9),
      ],
    );

    final barPaint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(x, y, width, height));

    // Draw main bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, width, height),
        Radius.circular(4.r),
      ),
      barPaint,
    );

    // Add highlight on top
    final highlightPaint = Paint()..color = Colors.white.withOpacity(0.3);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, width, height * 0.3),
        Radius.circular(4.r),
      ),
      highlightPaint,
    );

    // Draw mood icon on bar (only if bar is tall enough)
    if (height > 20) {
      _drawMoodIcon(canvas, x + width / 2, y + height / 2, moodData.icon);
    }

    // Draw value label when selected
    if (isSelected) {
      _drawValueLabel(canvas, x + width / 2, y - 25, moodData);
    }

    // Animated floating indicator
    if (animation > 0.8) {
      final indicatorPaint = Paint()
        ..color = moodData.color
        ..style = PaintingStyle.fill;

      final indicatorY = y - 10 + (5 * (1 - animation));
      canvas.drawCircle(
        Offset(x + width / 2, indicatorY),
        3 * animation,
        indicatorPaint,
      );
    }
  }

  void _drawMoodIcon(Canvas canvas, double x, double y, IconData icon) {
    try {
      final textPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(icon.codePoint),
          style: TextStyle(
            fontFamily: icon.fontFamily,
            fontSize: 14.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    } catch (e) {
      // Fallback: draw a simple circle if icon rendering fails
      final iconPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), 6, iconPaint);
    }
  }

  void _drawValueLabel(
      Canvas canvas, double x, double y, DominantMoodData moodData) {
    try {
      final textStyle = TextStyle(
        color: Colors.grey[800],
        fontSize: 9.sp,
        fontWeight: FontWeight.bold,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: '${moodData.name}\n${moodData.value.toInt()}%',
          style: textStyle,
        ),
        textAlign: TextAlign.center,
      );

      textPainter.layout();

      // Background for text
      final bgPaint = Paint()..color = moodData.color.withOpacity(0.1);

      final bgRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x, y),
          width: textPainter.width + 12,
          height: textPainter.height + 8,
        ),
        Radius.circular(6.r),
      );

      canvas.drawRRect(bgRect, bgPaint);

      // Border for text background
      final borderPaint = Paint()
        ..color = moodData.color.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      canvas.drawRRect(bgRect, borderPaint);

      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    } catch (e) {
      // Fallback: just draw the percentage
      final fallbackPainter = TextPainter(
        text: TextSpan(
          text: '${moodData.value.toInt()}%',
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 8.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      fallbackPainter.layout();
      fallbackPainter.paint(
        canvas,
        Offset(x - fallbackPainter.width / 2, y),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class DominantMoodData {
  final String name;
  final double value;
  final Color color;
  final IconData icon;

  DominantMoodData(this.name, this.value, this.color, this.icon);
}
