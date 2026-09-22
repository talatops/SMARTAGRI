import 'package:flutter/material.dart';

import '../../../../core/utils/enums.dart';

@immutable
class CropProfile {
  final CropType type;
  final int minMoisture;
  final int maxMoisture;
  final IconData icon;
  final Color iconColor;

  const CropProfile({
    required this.type,
    required this.minMoisture,
    required this.maxMoisture,
    required this.icon,
    required this.iconColor,
  });

  String get name => type.label;

  bool contains(double value) => value >= minMoisture && value <= maxMoisture;

  bool isBelow(double value) => value < minMoisture;

  bool isAbove(double value) => value > maxMoisture;

  MetricStatus statusOf(double value) =>
      contains(value) ? MetricStatus.normal : MetricStatus.warning;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is CropProfile && other.type == type);

  @override
  int get hashCode => type.hashCode;
}
