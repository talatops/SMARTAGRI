import 'package:flutter/material.dart';

import '../../../../core/utils/enums.dart';

@immutable
class SensorHistory {
  static const hoursInWindow = Duration.hoursPerDay;

  final Map<HistorySeries, List<double>> readings;

  const SensorHistory({required this.readings});

  List<double> valuesOf(HistorySeries series) => readings[series] ?? const [];

  double? valueAt(HistorySeries series, int hourOfDay) {
    final values = valuesOf(series);
    final index = indexOfHour(hourOfDay);
    return index < values.length ? values[index] : null;
  }

  static int indexOfHour(int hourOfDay) => (hourOfDay - 1) % hoursInWindow;
}
