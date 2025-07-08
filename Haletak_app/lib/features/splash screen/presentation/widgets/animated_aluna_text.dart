import 'package:flutter/material.dart';

class AnimatedAlunaText extends StatefulWidget {
  const AnimatedAlunaText({super.key});

  @override
  _AnimatedAlunaTextState createState() => _AnimatedAlunaTextState();
}

class _AnimatedAlunaTextState extends State<AnimatedAlunaText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = Tween<double>(begin: 0.5, end: 1.5).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _animation,
        child: const Text(
          'Haletak',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Color(0xFF54B6A8),
          ),
        ),
      ),
    );
  }
}
