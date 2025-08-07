import 'package:flutter/material.dart';
import 'dart:math' as math;

class SuperEllipseContainer extends StatelessWidget {
  final double width;
  final double height;
  final double exponent;
  final Widget? child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;

  const SuperEllipseContainer({
    super.key,
    required this.width,
    required this.height,
    this.exponent = 5.0,
    this.child,
    this.color,
    this.padding,
    this.margin,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipPath(
        clipper: SuperEllipseClipper(exponent: exponent),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: decoration ?? BoxDecoration(color: color),
          child: child,
        ),
      ),
    );
  }
}

class SuperEllipseClipper extends CustomClipper<Path> {
  final double exponent;

  SuperEllipseClipper({required this.exponent});

  @override
  Path getClip(Size size) {
    final path = Path();

    final a = size.width / 2;
    final b = size.height / 2;
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    bool firstPoint = true;

    for (int i = 0; i <= 360; i += 1) {
      final t = i * math.pi / 180;
      final cosT = math.cos(t);
      final sinT = math.sin(t);

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
    return path;
  }

  double _signedPow(double base, double exponent) {
    if (base >= 0) {
      return math.pow(base, exponent).toDouble();
    } else {
      return -math.pow(-base, exponent).toDouble();
    }
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return oldClipper is! SuperEllipseClipper ||
        oldClipper.exponent != exponent;
  }
}
