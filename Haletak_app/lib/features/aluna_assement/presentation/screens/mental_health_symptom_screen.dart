// ignore_for_file: use_build_context_synchronously

import 'package:aluna/core/routing/routes.dart';
import 'package:aluna/core/theme/colors.dart';
import 'package:aluna/features/aluna_assement/data/model/mental_health_symptom_model.dart';
import 'package:aluna/features/aluna_assement/data/service/mental_health_symptom_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MentalHealthScreen extends StatefulWidget {
  const MentalHealthScreen({super.key});

  @override
  _MentalHealthScreenState createState() => _MentalHealthScreenState();
}

class _MentalHealthScreenState extends State<MentalHealthScreen> {
  final MentalHealthService _mentalHealthService = MentalHealthService();
  TextEditingController customSymptomController = TextEditingController();

  // Predefined symptoms
  List<MentalHealthSymptom> symptoms = [
    MentalHealthSymptom(symptom: "Feeling Sad"),
    MentalHealthSymptom(symptom: "Anxiety"),
    MentalHealthSymptom(symptom: "Overthinking"),
  ];

  // Symptoms that cannot be deleted
  final List<String> lockedSymptoms = ["Anxiety", "Depressed"];

  void _toggleSymptom(int index) {
    setState(() {
      symptoms[index] = MentalHealthSymptom(
        symptom: symptoms[index].symptom,
        isSelected: !symptoms[index].isSelected,
      );
    });
  }

  void _addCustomSymptom() {
    String newSymptom = customSymptomController.text.trim();
    if (newSymptom.isNotEmpty) {
      setState(() {
        symptoms
            .add(MentalHealthSymptom(symptom: newSymptom, isSelected: true));
        customSymptomController.clear();
      });
    }
  }

  void _deleteSymptom(int index) {
    if (!lockedSymptoms.contains(symptoms[index].symptom)) {
      setState(() {
        symptoms.removeAt(index);
      });
    }
  }

  Future<void> _saveAndContinue() async {
    await _mentalHealthService.saveMentalHealthSymptoms(symptoms);
    Navigator.pushNamed(context, Routes.userStressLevel);
    // Replace with your next screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black54),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Assessment',
          style: TextStyle(
            color: ColorStyles.fontMainColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: ColorStyles.mainColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                '11 of 13',
                style: TextStyle(
                  color: ColorStyles.fontButtonColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Do you have other mental health symptoms?",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: ColorStyles.fontMainColor),
              ),
              const SizedBox(height: 20),
              Center(
                  child: Image.asset("assets/images/fem_cry.png",
                      height: 200)), // Placeholder image
              const SizedBox(height: 20),

              // Symptoms List
              Wrap(
                spacing: 8,
                children: symptoms.map((s) {
                  return ChoiceChip(
                    label: Text(s.symptom),
                    selected: s.isSelected,
                    onSelected: (selected) =>
                        _toggleSymptom(symptoms.indexOf(s)),
                    selectedColor: ColorStyles.cardColor,
                    backgroundColor: Colors.grey[300],
                    labelStyle:
                        const TextStyle(color: ColorStyles.fontMainColor),
                  );
                }).toList(),
              ),

              const SizedBox(height: 10),

              // Custom Symptom Input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: customSymptomController,
                      decoration: const InputDecoration(
                        hintText: "Type your own symptom...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _addCustomSymptom,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorStyles.mainColor),
                    child: const Icon(Icons.add,
                        color: ColorStyles.fontButtonColor),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Most Common Symptoms
              const Text("Most Common:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: symptoms.map((s) {
                  return Chip(
                    label: Text(s.symptom),
                    backgroundColor: Colors.orangeAccent,
                    deleteIcon: lockedSymptoms.contains(s.symptom)
                        ? null
                        : const Icon(Icons.close, size: 16),
                    onDeleted: lockedSymptoms.contains(s.symptom)
                        ? null
                        : () => _deleteSymptom(symptoms.indexOf(s)),
                  );
                }).toList(),
              ),

              SizedBox(height: 100.h),
              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: _saveAndContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorStyles.mainColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Continue",
                            style: TextStyle(
                                fontSize: 16,
                                color: ColorStyles.fontButtonColor)),
                        SizedBox(width: 5),
                        Icon(Icons.arrow_forward,
                            color: ColorStyles.fontButtonColor),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
