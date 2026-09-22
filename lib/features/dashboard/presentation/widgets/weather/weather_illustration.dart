import 'dart:math' as math;

import 'package:flutter/material.dart';

class WeatherIllustration extends StatelessWidget {
  final double size;

  const WeatherIllustration({super.key, this.size = 92});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 0.78,
      child: CustomPaint(painter: const _WeatherPainter()),
    );
  }
}

class _WeatherPainter extends CustomPainter {
  const _WeatherPainter();

  static const _sun = Color(0xFFFFC93C);
  static const _sunCore = Color(0xFFFFD966);
  static const _cloudLight = Color(0xFFF2F6FA);
  static const _cloudShade = Color(0xFFD3DEE9);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final sunCenter = Offset(w * 0.70, h * 0.32);
    final sunRadius = w * 0.17;

    final rayPaint = Paint()
      ..color = _sun
      ..strokeWidth = w * 0.032
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 8; i++) {
      final angle = (math.pi * 2 / 8) * i - math.pi / 8;
      final inner = sunCenter + Offset(math.cos(angle), math.sin(angle)) * (sunRadius * 1.45);
      final outer = sunCenter + Offset(math.cos(angle), math.sin(angle)) * (sunRadius * 1.95);
      canvas.drawLine(inner, outer, rayPaint);
    }

    canvas.drawCircle(sunCenter, sunRadius, Paint()..color = _sun);
    canvas.drawCircle(
      sunCenter.translate(-sunRadius * 0.18, -sunRadius * 0.18),
      sunRadius * 0.72,
      Paint()..color = _sunCore,
    );

    final cloud = Path();
    final baseY = h * 0.80;
    final leftX = w * 0.08;
    final rightX = w * 0.74;

    cloud.addOval(Rect.fromCircle(center: Offset(w * 0.30, h * 0.50), radius: w * 0.20));
    cloud.addOval(Rect.fromCircle(center: Offset(w * 0.50, h * 0.44), radius: w * 0.24));
    cloud.addOval(Rect.fromCircle(center: Offset(w * 0.62, h * 0.60), radius: w * 0.17));
    cloud.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(leftX, h * 0.56, rightX, baseY),
        Radius.circular(h * 0.16),
      ),
    );

    canvas.drawPath(cloud, Paint()..color = _cloudLight);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(leftX + w * 0.03, baseY - h * 0.11, rightX - w * 0.03, baseY),
        Radius.circular(h * 0.09),
      ),
      Paint()..color = _cloudShade.withValues(alpha: 0.55),
    );
  }

  @override
  bool shouldRepaint(_WeatherPainter oldDelegate) => false;
}
