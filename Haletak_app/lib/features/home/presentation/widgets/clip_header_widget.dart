import 'package:flutter/material.dart';

class BarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Constants for curve control
    double cornerRadius = 40;

    // Start from top-left
    path.lineTo(0, 0);
    path.lineTo(0, size.height - cornerRadius);

    // Bottom-left corner curve
    path.quadraticBezierTo(0, size.height, cornerRadius, size.height);

    // Bottom straight line
    path.lineTo(size.width - cornerRadius, size.height);

    // Bottom-right corner curve
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - cornerRadius);

    // Complete the path
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
