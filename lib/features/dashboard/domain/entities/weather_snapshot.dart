import 'package:flutter/material.dart';

import '../../../../core/utils/enums.dart';

@immutable
class WeatherSnapshot {
  final double temperatureC;
  final WeatherCondition condition;
  final bool isDay;
  final double rainChancePercent;
  final double windKmh;
  final double humidityPercent;

  const WeatherSnapshot({
    required this.temperatureC,
    required this.condition,
    required this.isDay,
    required this.rainChancePercent,
    required this.windKmh,
    required this.humidityPercent,
  });

  String get icon => condition.iconFor(isDay: isDay);
}
