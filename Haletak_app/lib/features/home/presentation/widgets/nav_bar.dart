import 'package:aluna/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: GNav(
            gap: 8,
            activeColor: Colors.white,
            color: Colors.grey[800],
            iconSize: 24,
            tabBackgroundColor: ColorStyles.mainColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.mood, text: 'Mood Check-In'),
              GButton(icon: Icons.camera_alt, text: 'Camera'),
              GButton(icon: Icons.chat, text: 'Chatbot'),
            ],
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,
          ),
        ),
      ),
    );
  }
}
