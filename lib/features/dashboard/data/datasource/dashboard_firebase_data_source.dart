import 'package:firebase_database/firebase_database.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/enums.dart';
import '../../domain/entities/composite_moisture.dart';
import '../../domain/entities/crop_profile.dart';
import '../../domain/entities/dashboard_snapshot.dart';
import '../../domain/entities/field_telemetry.dart';
import '../../domain/entities/field_water_level.dart';
import '../../domain/entities/irrigation_state.dart';
import '../../domain/entities/soil_reading.dart';
import '../../domain/entities/weather_snapshot.dart';
import 'dashboard_data_source.dart';
import 'dashboard_firebase_keys.dart';

class DashboardFirebaseDataSource implements DashboardDataSource {
  final FirebaseDatabase database;
  final DashboardDataSource fallback;

  DashboardFirebaseDataSource({required this.database, required this.fallback});

  @override
  Future<DashboardSnapshot> fetchSnapshot() async {
    final results = await Future.wait<Object?>([
      fallback.fetchSnapshot(),
      database.ref(DashboardFirebaseKeys.devicePath).get(),
    ]);
    final base = results[0]! as DashboardSnapshot;
    final device = _map((results[1]! as DataSnapshot).value);
    final control = _map(device[DashboardFirebaseKeys.control]);
    final sensors = _map(device[DashboardFirebaseKeys.sensors]);
    final weather = _map(device[DashboardFirebaseKeys.weather]);

    final soilReadings = base.soilReadings.map((reading) {
      final key = switch (reading.depth) {
        SoilDepth.surface => DashboardFirebaseKeys.soil5cm,
        SoilDepth.root => DashboardFirebaseKeys.soil20cm,
        SoilDepth.deep => DashboardFirebaseKeys.soil40cm,
      };
      return SoilReading(
        depth: reading.depth,
        moisturePercent: _double(sensors[key]) ?? reading.moisturePercent,
        icon: reading.icon,
      );
    }).toList();

    final isRaining = weather[DashboardFirebaseKeys.isRaining];

    return DashboardSnapshot(
      soilReadings: soilReadings,
      waterLevel: FieldWaterLevel(
        centimeters:
            _double(sensors[DashboardFirebaseKeys.waterLevel]) ?? base.waterLevel.centimeters,
        status: base.waterLevel.status,
      ),
      composite: CompositeMoisture(
        score: _double(sensors[DashboardFirebaseKeys.compositeMoisture]) ??
            CompositeMoisture.calculate(soilReadings).score,
      ),
      telemetry: FieldTelemetry(
        temperatureC:
            _double(sensors[DashboardFirebaseKeys.temperature]) ?? base.telemetry.temperatureC,
        humidityPercent:
            _double(sensors[DashboardFirebaseKeys.humidity]) ?? base.telemetry.humidityPercent,
        temperatureStatus: base.telemetry.temperatureStatus,
        humidityStatus: base.telemetry.humidityStatus,
      ),
      weather: WeatherSnapshot(
        temperatureC:
            _double(weather[DashboardFirebaseKeys.weatherTemperature]) ?? base.weather.temperatureC,
        condition: switch (isRaining) {
          true => AppStrings.raining,
          false => AppStrings.noRain,
          _ => base.weather.condition,
        },
        rainChancePercent:
            _double(weather[DashboardFirebaseKeys.rainProbability]) ?? base.weather.rainChancePercent,
        windKmh: base.weather.windKmh,
        humidityPercent:
            _double(weather[DashboardFirebaseKeys.weatherHumidity]) ?? base.weather.humidityPercent,
      ),
      crops: base.crops,
      selectedCrop: _crop(base.crops, control[DashboardFirebaseKeys.cropProfile]) ?? base.selectedCrop,
      irrigation: IrrigationState(
        mode: _pumpMode(control[DashboardFirebaseKeys.mode]) ?? base.irrigation.mode,
        isPumpOn: _bool(control[DashboardFirebaseKeys.pumpStatus]) ?? base.irrigation.isPumpOn,
      ),
      lastUpdated: base.lastUpdated,
      location: base.location,
    );
  }

  @override
  Future<IrrigationState> setPumpMode(PumpMode mode) => fallback.setPumpMode(mode);

  @override
  Future<IrrigationState> togglePump({required bool isOn}) => fallback.togglePump(isOn: isOn);

  Map<Object?, Object?> _map(Object? value) =>
      value is Map<Object?, Object?> ? value : const <Object?, Object?>{};

  double? _double(Object? value) => value is num ? value.toDouble() : null;

  bool? _bool(Object? value) => value is bool ? value : null;

  PumpMode? _pumpMode(Object? value) {
    if (value is! String) return null;
    for (final mode in PumpMode.values) {
      if (mode.label.toLowerCase() == value.toLowerCase()) return mode;
    }
    return null;
  }

  CropProfile? _crop(List<CropProfile> crops, Object? value) {
    if (value is! String) return null;
    for (final crop in crops) {
      if (crop.name.toLowerCase() == value.toLowerCase()) return crop;
    }
    return null;
  }
}
