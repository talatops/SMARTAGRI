import 'package:flutter/material.dart';

import '../../../../core/utils/enums.dart';

@immutable
class FieldTelemetry {
  final double temperatureC;
  final double humidityPercent;
  final MetricStatus temperatureStatus;
  final MetricStatus humidityStatus;

  const FieldTelemetry({
    required this.temperatureC,
    required this.humidityPercent,
    required this.temperatureStatus,
    required this.humidityStatus,
  });
}
