import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

class SuggestionChips extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onSuggestionTap;

  const SuggestionChips({
    super.key,
    required this.suggestions,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(
                suggestions[index],
                style: const TextStyle(
                  color: ColorStyles.mainColor,
                  fontSize: 14,
                ),
              ),
              backgroundColor: ColorStyles.mainColor.withOpacity(0.1),
              side: BorderSide(
                color: ColorStyles.mainColor.withOpacity(0.3),
              ),
              onPressed: () => onSuggestionTap(suggestions[index]),
            ),
          );
        },
      ),
    );
  }
}
