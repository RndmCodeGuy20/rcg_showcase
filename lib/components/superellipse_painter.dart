import 'package:flutter/material.dart';
import 'dart:math' as math;

class ConfigurableSuperEllipse extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double exponent;

  const ConfigurableSuperEllipse({
    super.key,
    required this.width,
    required this.height,
    this.color = Colors.blue,
    this.exponent = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: SuperEllipsePainter(color: color, exponent: exponent),
    );
  }
}

class SuperEllipsePainter extends CustomPainter {
  final Color color;
  final double exponent;

  SuperEllipsePainter({required this.color, required this.exponent});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // Your equation: |x/a|^n + |y/b|^n = 1
    // Where a = width/2, b = height/2, n = exponent
    final a = size.width / 2; // Semi-major axis (your 20 scaled to width)
    final b = size.height / 2; // Semi-minor axis (your 10 scaled to height)
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    bool firstPoint = true;

    // Generate points using parametric form to avoid numerical issues
    for (int i = 0; i <= 360; i += 1) {
      final t = i * math.pi / 180;

      // Parametric super ellipse equations
      final cosT = math.cos(t);
      final sinT = math.sin(t);

      // x = a * sign(cos(t)) * |cos(t)|^(2/n)
      // y = b * sign(sin(t)) * |sin(t)|^(2/n)
      final x = centerX + a * _signedPow(cosT, 2 / exponent);
      final y = centerY + b * _signedPow(sinT, 2 / exponent);

      if (firstPoint) {
        path.moveTo(x, y);
        firstPoint = false;
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  // Helper function to handle signed powers
  double _signedPow(double base, double exponent) {
    if (base >= 0) {
      return math.pow(base, exponent).toDouble();
    } else {
      return -math.pow(-base, exponent).toDouble();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! SuperEllipsePainter ||
        oldDelegate.color != color ||
        oldDelegate.exponent != exponent;
  }
}
