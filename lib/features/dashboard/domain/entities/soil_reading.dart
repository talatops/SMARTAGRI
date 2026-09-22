import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/enums.dart';
import 'crop_profile.dart';

@immutable
class SoilReading {
  final SoilDepth depth;
  final double moisturePercent;
  final IconData icon;

  const SoilReading({required this.depth, required this.moisturePercent, required this.icon});

  double get fraction => (moisturePercent / 100).clamp(0.0, 1.0);

  Color get gaugeColor => moisturePercent >= 60 ? AppColors.gaugeGreen : AppColors.gaugeBlue;

  MetricStatus statusFor(CropProfile crop) => crop.statusOf(moisturePercent);
}
