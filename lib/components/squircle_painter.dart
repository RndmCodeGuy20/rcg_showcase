import 'dart:math' as math;

import 'package:flutter/material.dart';

class SquirclePainter extends CustomPainter {
  final Color color;
  final double squareness; // 0 = circle, 1 = square

  SquirclePainter({required this.color, this.squareness = 0.5});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = math.min(centerX, centerY);

    // Using Fernandez Guasti's definition
    for (int i = 0; i <= 360; i++) {
      final angle = i * math.pi / 180;
      final cos = math.cos(angle);
      final sin = math.sin(angle);

      // Fernandez Guasti squircle formula
      final denominator = math.sqrt(1 + squareness * cos * cos * sin * sin);
      final x = centerX + radius * cos / denominator;
      final y = centerY + radius * sin / denominator;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
