import 'package:aluna/features/camera-feature/presentation/screens/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors.dart';
import '../../../chatbot/presentation/screens/chat_screen.dart';
import '../../../mood-check-in/presentation/screens/mood_screen.dart';
import '../../data/model/user_model.dart';
import '../widgets/metric_card.dart';
import '../widgets/mindful_tracker.dart';
import '../widgets/mood_tracker_widget.dart';
import '../widgets/nav_bar.dart';
import '../widgets/user_header.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeContent(username: widget.username),
      const MoodScreen(),
      const CameraScreen(),
      const ChatScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _pages[_selectedIndex],
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final String username;
  const HomeContent({super.key, required this.username});

  Future<User> _fetchUser() async {
    await Future.delayed(const Duration(seconds: 1));
    return User(
      username: username.isNotEmpty ? username : "User",
      mood: "Stressed",
      energy: "40",
      status: "Active",
      profileImageUrl: "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _fetchUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(ColorStyles.mainColor),
          ));
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error loading data"));
        } else if (snapshot.hasData) {
          return _buildHomeContent(snapshot.data!);
        } else {
          return const Center(child: Text("No data available"));
        }
      },
    );
  }

  Widget _buildHomeContent(User user) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserHeader(user: user),
          const SizedBox(height: 16),
          const SectionTitle(title: "Mental Health Metrics"),
          const SizedBox(height: 16),
          const MetricsRow(),
          const SizedBox(height: 16),
          MindfulTrackerCard(
            title: "Mindful Hours",
            subtitle: "2.5h/8h Today",
            icon: Icons.access_time,
            iconBackgroundColor: ColorStyles.mainColor.withOpacity(0.1),
            iconColor: ColorStyles.mainColor,
            trailingWidget: const Icon(
              Icons.show_chart,
              color: ColorStyles.mainColor,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          const MoodTrackerCard()
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class MetricsRow extends StatelessWidget {
  const MetricsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          MoodStatsCard(
            width: double.infinity,
            height: 130.h,
            routeName: '/moodStatsScreen',
            title: const Text(
              "Mood Statistics",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ColorStyles.fontMainColor,
              ),
            ),
            subtitle: const Text(
              "Track your mood over time",
              style: TextStyle(
                fontSize: 14,
                color: ColorStyles.fontMainColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          MoodStatsCard(
            width: double.infinity,
            height: 130.h,
            routeName: '/heartRateScreen',
            title: const Text(
              "Heart Rate Monitor",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ColorStyles.fontMainColor,
              ),
            ),
            subtitle: const Text(
              "Monitor your heart rate ",
              style: TextStyle(
                fontSize: 14,
                color: ColorStyles.fontMainColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
