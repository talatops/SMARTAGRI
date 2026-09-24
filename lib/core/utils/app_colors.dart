import 'package:flutter/material.dart';

abstract final class AppColors {
  static const scaffoldTop = Color(0xFF060D1A);
  static const scaffoldBottom = Color(0xFF0A1424);
  static const cardBg = Color(0xFF0E1B2E);
  static const cardBgElevated = Color(0xFF11213A);
  static const cardBorder = Color(0xFF1B3550);
  static const tileBg = Color(0xFF0C1829);
  static const tileBorder = Color(0xFF17304C);
  static const divider = Color(0xFF16293F);

  static const primaryBlue = Color(0xFF1FA2FF);
  static const cyan = Color(0xFF29B6F6);
  static const success = Color(0xFF2ECC71);
  static const successBright = Color(0xFF24D17E);
  static const amber = Color(0xFFF5B942);
  static const danger = Color(0xFFE5484D);

  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF93A5BC);
  static const textTertiary = Color(0xFF5E7490);

  static const gaugeTrack = Color(0xFF1B3A5E);
  static const gaugeBlue = Color(0xFF1FA2FF);
  static const gaugeGreen = Color(0xFF2ECC71);

  static const cropWheat = Color(0xFFF5B942);
  static const cropRice = Color(0xFF8BC34A);
  static const cropCotton = Color(0xFFE8EDF2);
  static const cropSugarcane = Color(0xFF7CB342);
  static const cropMaize = Color(0xFFFFC107);

  static const chartBlue = cyan;
  static const chartYellow = Color(0xFFFFD54F);
  static const chartPurple = Color(0xFF9C7CFF);
  static const chartGreen = Color(0xFF2EE6A6);
  static const chartGrid = Color(0xFF142740);
  static const chartCrosshair = Color(0xCCFFFFFF);

  static Color pillFill(Color c) => c.withValues(alpha: 0.12);
  static Color pillBorder(Color c) => c.withValues(alpha: 0.40);
  static Color glow(Color c) => c.withValues(alpha: 0.35);
  static Color softTint(Color c) => c.withValues(alpha: 0.10);

  static Color get hoverFill => Colors.white.withValues(alpha: 0.04);

  static const scaffoldGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [scaffoldTop, scaffoldBottom],
  );

  static const compositeGaugeColors = [gaugeBlue, cyan, successBright, gaugeGreen];

  static const loaderRingTrack = Color(0x0FFFFFFF);
  static const loaderBarTrack = Color(0x12FFFFFF);
  static const loaderLogoGlow = Color(0x732ECC71);

  static const loaderBarGradient = LinearGradient(colors: [primaryBlue, cyan, success]);

  static const shimmerBase = Color(0xFF15273E);
  static const shimmerHighlight = Color(0xFF24405F);

  static LinearGradient shimmerGradient(GradientTransform transform) => LinearGradient(
    begin: const Alignment(-1, -0.3),
    end: const Alignment(1, 0.3),
    colors: const [shimmerBase, shimmerBase, shimmerHighlight, shimmerBase, shimmerBase],
    stops: const [0, 0.35, 0.5, 0.65, 1],
    transform: transform,
  );
}
