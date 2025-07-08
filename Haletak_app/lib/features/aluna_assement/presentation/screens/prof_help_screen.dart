// lib/presentation/screens/professional_help_screen.dart
// ignore_for_file: use_super_parameters, use_build_context_synchronously

import 'package:aluna/core/routing/routes.dart';
import 'package:aluna/features/aluna_assement/data/service/user_age_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors.dart';

class ProfessionalHelpScreen extends StatefulWidget {
  final Function()? onContinue;

  const ProfessionalHelpScreen({Key? key, this.onContinue}) : super(key: key);

  @override
  State<ProfessionalHelpScreen> createState() => _ProfessionalHelpScreenState();
}

class _ProfessionalHelpScreenState extends State<ProfessionalHelpScreen> {
  final UserService _userService = UserService();
  bool? _hasSoughtHelp;

  void _saveResponseAndContinue() async {
    if (_hasSoughtHelp == null) {
      // Show error or prompt user to make a selection
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an option')),
      );
      return;
    }

    try {
      await _userService.saveUserProfessionalHelpStatus(_hasSoughtHelp!);
      if (widget.onContinue != null) {
        widget.onContinue!();
        Navigator.pushNamed(context, Routes.physicalExpScreen);
      } else {
        // Navigate to next screen if onContinue callback is not provided
        Navigator.pushNamed(context, Routes.physicalExpScreen);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.grey.shade300), // Circular border
                      ),
                      child:
                          const Icon(Icons.arrow_back, color: Colors.black54),
                    ),
                    onPressed: () =>
                        Navigator.pop(context), // Back button action
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
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: ColorStyles
                              .mainColor, // Background color for step tracker
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          '5 of 13', // Update the progress step dynamically if needed
                          style: TextStyle(
                            color: ColorStyles.fontButtonColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Have you sought professional help before?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorStyles.fontMainColor,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Center(
                  child: Container(
                    width: 200.w,
                    height: 200.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 180.w,
                          height: 180.h,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Image.asset(
                          'assets/images/female3.png', // Make sure you have this image in your assets
                          width: 200.w,
                          height: 200.h,
                          fit: BoxFit.contain,
                        ),
                        const Positioned(
                          top: 30,
                          right: 50,
                          child: Text(
                            '?',
                            style: TextStyle(
                              color: ColorStyles.mainColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Positioned(
                          bottom: 50,
                          right: 30,
                          child: Text(
                            '?',
                            style: TextStyle(
                              color: ColorStyles.mainColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 50,
                          bottom: 70,
                          child: Text(
                            '?',
                            style: TextStyle(
                              color: ColorStyles.mainColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSelectionButton(
                    text: 'Yes',
                    isSelected: _hasSoughtHelp == true,
                    onTap: () {
                      setState(() {
                        _hasSoughtHelp = true;
                      });
                    },
                  ),
                  _buildSelectionButton(
                    text: 'No',
                    isSelected: _hasSoughtHelp == false,
                    textColor: const Color.fromARGB(255, 255, 255, 255),
                    onTap: () {
                      setState(() {
                        _hasSoughtHelp = false;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _saveResponseAndContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorStyles.mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: Colors.white),
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

  Widget _buildSelectionButton({
    required String text,
    required bool isSelected,
    Color textColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 50,
        decoration: BoxDecoration(
          color:
              isSelected ? ColorStyles.mainColor : Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? ColorStyles.mainColor
                : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
