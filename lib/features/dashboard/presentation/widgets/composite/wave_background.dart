import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';

class WaveBackground extends StatelessWidget {
  final double height;

  const WaveBackground({super.key, this.height = 86});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(painter: const _WavePainter()),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  const _WavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    _drawWave(canvas, size, verticalOffset: 0.40, alpha: 0.30, amplitude: 0.30);
    _drawWave(canvas, size, verticalOffset: 0.58, alpha: 0.22, amplitude: 0.26);
    _drawWave(canvas, size, verticalOffset: 0.76, alpha: 0.16, amplitude: 0.22);
  }

  void _drawWave(
    Canvas canvas,
    Size size, {
    required double verticalOffset,
    required double alpha,
    required double amplitude,
  }) {
    final baseY = size.height * verticalOffset;
    final amp = size.height * amplitude;

    final path = Path()..moveTo(0, baseY);
    path.cubicTo(
      size.width * 0.22,
      baseY - amp,
      size.width * 0.38,
      baseY + amp,
      size.width * 0.58,
      baseY - amp * 0.35,
    );
    path.cubicTo(
      size.width * 0.74,
      baseY - amp * 1.15,
      size.width * 0.88,
      baseY + amp * 0.55,
      size.width,
      baseY - amp * 0.2,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.primaryBlue.withValues(alpha: alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) => false;
}
