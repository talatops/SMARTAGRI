import 'package:flutter/material.dart';

import '../../../../core/utils/enums.dart';

@immutable
class SensorHistory {
  static const hoursInWindow = Duration.hoursPerDay;

  final Map<HistorySeries, List<double>> readings;

  const SensorHistory({required this.readings});

  List<double> valuesOf(HistorySeries series) => readings[series] ?? const [];

  static int hourAt(int index) => (index + 1) % Duration.hoursPerDay;
}
