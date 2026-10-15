import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import '../utils/app_assets.dart';
import '../utils/app_colors.dart';
import '../utils/app_dimensions.dart';
import '../utils/app_durations.dart';
import '../utils/app_strings.dart';

class AppLoader extends StatefulWidget {
  const AppLoader({super.key});

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> with TickerProviderStateMixin {
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: AppDurations.loaderSpin,
  )..repeat();

  late final AnimationController _slide = AnimationController(
    vsync: this,
    duration: AppDurations.loaderSlide,
  )..repeat();

  @override
  void dispose() {
    _spin.dispose();
    _slide.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final titleSize = (viewportWidth * AppDimensions.loaderTitleViewportFraction)
        .clamp(AppDimensions.loaderTitleMin, AppDimensions.loaderTitleMax);
    final taglineSize = (viewportWidth * AppDimensions.loaderTaglineViewportFraction)
        .clamp(AppDimensions.loaderTaglineMin, AppDimensions.loaderTaglineMax);
    final barWidth = math.min(
      AppDimensions.loaderBarWidth,
      viewportWidth * AppDimensions.loaderBarViewportFraction,
    );
    final titleStyle = AppTextStyles.loaderTitle.copyWith(fontSize: titleSize);

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.scaffoldGradient),
      padding: const EdgeInsets.all(AppDimensions.s24),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppDimensions.loaderMaxWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppAssets.iradaLogo,
              width: AppDimensions.loaderBrandWidth,
              filterQuality: FilterQuality.medium,
            ),
            const SizedBox(height: AppDimensions.loaderBrandGap),
            SizedBox.square(
              dimension: AppDimensions.loaderRingSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: RotationTransition(
                      turns: _spin,
                      child: const CustomPaint(painter: _RingPainter()),
                    ),
                  ),
                  const CustomPaint(
                    size: Size.square(AppDimensions.loaderLogoSize),
                    painter: _LeafPainter(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.loaderLogoGap),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: '${AppStrings.appNamePrefix} '),
                  TextSpan(
                    text: AppStrings.appNameSuffix,
                    style: titleStyle.copyWith(color: AppColors.success),
                  ),
                ],
              ),
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.s10),
            Text(
              [
                AppStrings.tagline1,
                AppStrings.tagline2,
                AppStrings.tagline3,
              ].join(AppStrings.taglineSeparator),
              style: AppTextStyles.loaderTagline.copyWith(fontSize: taglineSize),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.loaderBarGap),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.loaderBarHeight),
              child: Container(
                width: barWidth,
                height: AppDimensions.loaderBarHeight,
                color: AppColors.loaderBarTrack,
                child: AnimatedBuilder(
                  animation: _slide,
                  builder: (context, _) {
                    final progress = Curves.easeInOut.transform(_slide.value);
                    final start = -AppDimensions.loaderBarFillFraction;
                    return Stack(
                      children: [
                        Positioned(
                          left: barWidth * (start + (1 - start) * progress),
                          top: 0,
                          bottom: 0,
                          width: barWidth * AppDimensions.loaderBarFillFraction,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: AppColors.loaderBarGradient,
                              borderRadius: BorderRadius.circular(AppDimensions.loaderBarHeight),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.s14),
            const Text(
              AppStrings.loadingDashboard,
              style: AppTextStyles.loaderStatus,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = AppDimensions.loaderRingStroke;
    final rect = Rect.fromLTWH(
      stroke / 2,
      stroke / 2,
      size.width - stroke,
      size.height - stroke,
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    canvas.drawArc(rect, 0, math.pi * 2, false, paint..color = AppColors.loaderRingTrack);
    canvas.drawArc(rect, -math.pi * 3 / 4, math.pi / 2, false, paint..color = AppColors.primaryBlue);
    canvas.drawArc(rect, -math.pi / 4, math.pi / 2, false, paint..color = AppColors.success);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) => false;
}

class _LeafPainter extends CustomPainter {
  const _LeafPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / AppDimensions.loaderLogoViewBox;
    canvas.scale(scale);

    final leaf = Path()
      ..moveTo(11, 20)
      ..arcToPoint(const Offset(9.8, 6.1), radius: const Radius.circular(7))
      ..cubicTo(15.5, 5, 17, 4.48, 19, 2)
      ..cubicTo(20, 4, 21, 6.18, 21, 10)
      ..cubicTo(21, 15.5, 16.22, 20, 11, 20)
      ..close();
    final stem = Path()
      ..moveTo(2, 21)
      ..cubicTo(2, 18, 3.85, 15.64, 7.08, 15)
      ..cubicTo(9.5, 14.52, 12, 13, 13, 12);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppDimensions.loaderLogoStroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppDimensions.loaderLogoStroke
      ..color = AppColors.loaderLogoGlow
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, AppDimensions.loaderLogoGlowSigma / scale);

    for (final path in [leaf, stem]) {
      canvas.drawPath(path, glow);
      canvas.drawPath(path, paint..color = AppColors.success);
    }
  }

  @override
  bool shouldRepaint(covariant _LeafPainter oldDelegate) => false;
}
