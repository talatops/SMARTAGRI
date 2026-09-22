import 'package:flutter/material.dart';

import '../../../../core/utils/enums.dart';
import 'crop_profile.dart';
import 'soil_reading.dart';

@immutable
class CompositeMoisture {
  final double score;

  const CompositeMoisture({required this.score});

  double get fraction => (score / 100).clamp(0.0, 1.0);

  MetricStatus statusFor(CropProfile crop) => crop.statusOf(score);

  static CompositeMoisture calculate(List<SoilReading> readings) {
    if (readings.isEmpty) return const CompositeMoisture(score: 0);
    final sum = readings.fold<double>(0, (a, r) => a + r.moisturePercent);
    return CompositeMoisture(score: sum / readings.length);
  }
}
