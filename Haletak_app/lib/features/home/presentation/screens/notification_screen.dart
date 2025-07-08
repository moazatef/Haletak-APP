import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final List<Map<String, String>> mockNotifications = [
    {
      'title': 'Mood Today',
      'description': 'You seem happy today! Keep it up!',
      'date': 'Today',
    },
    {
      'title': 'Mood Yesterday',
      'description':
          'You were feeling a bit stressed yesterday. Take some time to relax!',
      'date': 'Yesterday',
    },
    {
      'title': 'Mood Last Week',
      'description': 'Your mood was stable last week. Great job!',
      'date': 'Last Week',
    },
    {
      'title': 'Mood Last Month',
      'description':
          'You had some ups and downs last month. Remember to take care of yourself!',
      'date': 'Last Month',
    },
    {
      'title': 'Mood Last Year',
      'description':
          'You had a great year overall! Keep up the positive vibes!',
      'date': 'Last Year',
    },
    {
      'title': 'New Feature Alert',
      'description': 'Check out our new mood tracking feature!',
      'date': 'Today',
    },
    {
      'title': 'Weekly Summary',
      'description': 'Your weekly mood summary is ready. Check it out!',
      'date': 'This Week',
    },
    {
      'title': 'Monthly Challenge',
      'description': 'Join our monthly mood challenge for a chance to win!',
      'date': 'This Month',
    },
  ];

  NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: mockNotifications.length,
        itemBuilder: (context, index) {
          final notification = mockNotifications[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.notifications,
                color: Colors.teal,
                size: 32,
              ),
              title: Text(
                notification['title']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                notification['description']!,
                style: const TextStyle(fontSize: 14),
              ),
              trailing: Text(
                notification['date']!,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          );
        },
      ),
    );
  }
}
