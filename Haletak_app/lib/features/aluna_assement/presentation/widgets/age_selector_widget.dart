import 'package:aluna/core/theme/colors.dart';
import 'package:flutter/material.dart';

class AgeSelectorWidget extends StatefulWidget {
  final int selectedAge;
  final Function(int) onAgeSelected;

  const AgeSelectorWidget(
      {super.key, required this.selectedAge, required this.onAgeSelected});

  @override
  State<AgeSelectorWidget> createState() => _AgeSelectorWidgetState();
}

class _AgeSelectorWidgetState extends State<AgeSelectorWidget> {
  late final ScrollController _scrollController;
  final List<int> _ages =
      List.generate(50, (index) => index + 16); // Ages 16-118

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initialIndex = _ages.indexOf(widget.selectedAge);
      if (initialIndex != -1) {
        const itemHeight = 80.0;
        final centerOffset = MediaQuery.of(context).size.height / 2 - 200;
        _scrollController.jumpTo(initialIndex * itemHeight - centerOffset);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _ages.length,
        itemBuilder: (context, index) {
          final age = _ages[index];
          final isSelected = age == widget.selectedAge;

          return GestureDetector(
            onTap: () => widget.onAgeSelected(age),
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isSelected ? 120 : 60,
                height: 80,
                decoration: BoxDecoration(
                  color:
                      isSelected ? ColorStyles.mainColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Text(
                    age.toString(),
                    style: TextStyle(
                      fontSize: isSelected ? 42 : 28,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? ColorStyles.fontButtonColor
                          : Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
