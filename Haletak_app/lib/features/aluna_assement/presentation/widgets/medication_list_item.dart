import 'package:flutter/material.dart';
import 'package:aluna/core/theme/colors.dart';
import 'package:aluna/features/aluna_assement/data/model/medication_list_model.dart';

class MedicationListItem extends StatelessWidget {
  final MedicationListModel medication;
  final bool isSelected;
  final VoidCallback onTap;

  const MedicationListItem({
    super.key,
    required this.medication,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorStyles.mainColor.withOpacity(0.3)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? ColorStyles.mainColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              medication.name,
              style: TextStyle(
                color: ColorStyles.fontMainColor,
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            isSelected
                ? const Icon(Icons.radio_button_checked,
                    color: ColorStyles.mainColor)
                : const Icon(Icons.radio_button_off, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
