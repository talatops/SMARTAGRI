import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_durations.dart';

class CircularGauge extends StatelessWidget {
  final double value;
  final double size;
  final double strokeWidth;

  final double startAngle;
  final double sweepAngle;

  final Color trackColor;
  final Color? progressColor;

  final List<Color>? gradientColors;
  final List<double>? gradientStops;

  final Widget? center;
  final bool animate;
  final bool showTrack;

  final bool anchorAtEnd;

  final bool fullRing;

  const CircularGauge({
    super.key,
    required this.value,
    required this.size,
    required this.strokeWidth,
    this.startAngle = 120,
    this.sweepAngle = 300,
    this.trackColor = AppColors.gaugeTrack,
    this.progressColor,
    this.gradientColors,
    this.gradientStops,
    this.center,
    this.animate = true,
    this.showTrack = true,
    this.anchorAtEnd = true,
    this.fullRing = false,
  });

  @override
  Widget build(BuildContext context) {
    final centered = center == null
        ? null
        : Center(
            child: Padding(padding: EdgeInsets.all(strokeWidth + 2), child: center),
          );

    Widget paint(double v) => CustomPaint(
      size: Size.square(size),
      painter: _GaugePainter(
        value: v,
        strokeWidth: strokeWidth,
        startAngle: startAngle,
        sweepAngle: sweepAngle,
        trackColor: trackColor,
        progressColor: progressColor ?? AppColors.gaugeBlue,
        gradientColors: gradientColors,
        gradientStops: gradientStops,
        showTrack: showTrack,
        anchorAtEnd: anchorAtEnd,
        fullRing: fullRing,
      ),
      child: centered,
    );

    return SizedBox(
      width: size,
      height: size,
      child: animate
          ? TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: value.clamp(0.0, 1.0)),
              duration: AppDurations.gauge,
              curve: Curves.easeOutCubic,
              builder: (_, v, _) => paint(v),
            )
          : paint(value.clamp(0.0, 1.0)),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  final double strokeWidth;
  final double startAngle;
  final double sweepAngle;
  final Color trackColor;
  final Color progressColor;
  final List<Color>? gradientColors;
  final List<double>? gradientStops;
  final bool showTrack;
  final bool anchorAtEnd;
  final bool fullRing;

  const _GaugePainter({
    required this.value,
    required this.strokeWidth,
    required this.startAngle,
    required this.sweepAngle,
    required this.trackColor,
    required this.progressColor,
    required this.gradientColors,
    required this.gradientStops,
    required this.showTrack,
    required this.anchorAtEnd,
    required this.fullRing,
  });

  static double _rad(double degrees) => degrees * math.pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    if (rect.width <= 0 || rect.height <= 0) return;

    final startRad = _rad(startAngle);
    final sweepRad = _rad(sweepAngle);

    if (showTrack) {
      canvas.drawArc(
        rect,
        startRad,
        sweepRad,
        false,
        Paint()
          ..color = trackColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }

    final progressSweep = fullRing ? sweepRad : sweepRad * value.clamp(0.0, 1.0);
    if (progressSweep <= 0) return;

    final progressStart = (fullRing || !anchorAtEnd)
        ? startRad
        : startRad + sweepRad - progressSweep;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final colors = gradientColors;
    if (colors != null && colors.length >= 2) {
      paint.shader = SweepGradient(
        startAngle: 0,
        endAngle: sweepRad,
        colors: colors,
        stops: gradientStops,
        transform: GradientRotation(progressStart),
      ).createShader(rect);
    } else {
      paint.color = progressColor;
    }

    canvas.drawArc(rect, progressStart, progressSweep, false, paint);
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.value != value ||
      old.strokeWidth != strokeWidth ||
      old.startAngle != startAngle ||
      old.sweepAngle != sweepAngle ||
      old.trackColor != trackColor ||
      old.progressColor != progressColor ||
      old.showTrack != showTrack ||
      old.anchorAtEnd != anchorAtEnd ||
      old.fullRing != fullRing;
}
