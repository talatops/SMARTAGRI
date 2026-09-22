import 'package:flutter/material.dart';

@immutable
class WeatherSnapshot {
  final double temperatureC;
  final String condition;
  final double rainChancePercent;
  final double windKmh;
  final double humidityPercent;

  const WeatherSnapshot({
    required this.temperatureC,
    required this.condition,
    required this.rainChancePercent,
    required this.windKmh,
    required this.humidityPercent,
  });
}
