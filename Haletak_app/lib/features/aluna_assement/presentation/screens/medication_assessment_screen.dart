import 'package:aluna/core/routing/routes.dart';
import 'package:aluna/core/theme/colors.dart';
import 'package:aluna/features/aluna_assement/data/service/medication_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicationAssessmentScreen extends StatefulWidget {
  const MedicationAssessmentScreen({super.key});

  @override
  State<MedicationAssessmentScreen> createState() =>
      _MedicationAssessmentScreenState();
}

class _MedicationAssessmentScreenState
    extends State<MedicationAssessmentScreen> {
  final MedicationService _medicationService = MedicationService();
  String? _selectedOption;

  // Options for medication types
  final List<Map<String, dynamic>> _medicationOptions = [
    {
      'id': 'prescribed',
      'title': 'Prescribed\nMedications',
      'img': 'assets/images/PrescribedMedications.png',
    },
    {
      'id': 'otc',
      'title': 'Over the Counter\nSupplements',
      'img': 'assets/images/OvertheCounterSupplements.png',
    },
    {
      'id': 'none',
      'title': 'I\'m not taking any',
      'img': 'assets/images/Imnottakingany.png',
    },
    {
      'id': 'prefer_not_to_say',
      'title': 'Prefer not to say',
      'img': 'assets/images/prefernotsay.png',
    },
  ];

  void _saveMedicationInfo() {
    if (_selectedOption == null) return;

    try {
      // Save medication info
      _medicationService.saveMedicationInfo(_selectedOption!);

      // Navigate to next screen
      Navigator.pushNamed(context, Routes.medicationListScreen);
    } catch (e) {
      // Show error if saving fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header section
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        color: ColorStyles.mainColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Assessment',
                        style: TextStyle(
                          color: ColorStyles.fontMainColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ColorStyles.mainColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      '9 of 13',
                      style: TextStyle(
                        color: ColorStyles.fontMainColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Question text
              const Text(
                'Are you taking any medications?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorStyles.fontMainColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 32),

              // Medication options grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _medicationOptions.length,
                  itemBuilder: (context, index) {
                    final option = _medicationOptions[index];
                    final isSelected = _selectedOption == option['id'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedOption = option['id'];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              isSelected ? ColorStyles.mainColor : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              option['img'],
                              height: 18.h,
                              width: 18.w,
                              color: isSelected
                                  ? Colors.white
                                  : ColorStyles.fontMainColor,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              option['title'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : ColorStyles.mainColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed:
                      _selectedOption == null ? null : _saveMedicationInfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorStyles.mainColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor:
                        ColorStyles.mainColor.withOpacity(0.5),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
