import 'package:flutter/material.dart';

import 'composite_moisture.dart';
import 'crop_profile.dart';
import 'field_telemetry.dart';
import 'field_water_level.dart';
import 'irrigation_state.dart';
import 'soil_reading.dart';
import 'weather_snapshot.dart';

@immutable
class DashboardSnapshot {
  final List<SoilReading> soilReadings;
  final FieldWaterLevel waterLevel;
  final CompositeMoisture composite;
  final FieldTelemetry telemetry;
  final WeatherSnapshot weather;
  final List<CropProfile> crops;
  final CropProfile selectedCrop;
  final IrrigationState irrigation;
  final DateTime lastUpdated;
  final String location;

  const DashboardSnapshot({
    required this.soilReadings,
    required this.waterLevel,
    required this.composite,
    required this.telemetry,
    required this.weather,
    required this.crops,
    required this.selectedCrop,
    required this.irrigation,
    required this.lastUpdated,
    required this.location,
  });
}
