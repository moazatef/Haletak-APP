import 'package:flutter/material.dart';

class MoodStatsCard extends StatelessWidget {
  final double? width;
  final double? height;

  final String routeName;
  final Text title;
  final Text subtitle;

  const MoodStatsCard({
    super.key,
    this.width,
    this.height,
    required this.routeName,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(24),
      color: Colors.white,
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
        child: Container(
          width: width ?? MediaQuery.of(context).size.width,
          height: height ?? 200,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              title,
              const SizedBox(height: 8),
              subtitle,
            ],
          ),
        ),
      ),
    );
  }
}
