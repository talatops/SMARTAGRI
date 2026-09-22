import 'package:flutter/material.dart';

import '../../../../core/utils/enums.dart';

@immutable
class FieldWaterLevel {
  final double centimeters;
  final MetricStatus status;

  const FieldWaterLevel({required this.centimeters, required this.status});
}
