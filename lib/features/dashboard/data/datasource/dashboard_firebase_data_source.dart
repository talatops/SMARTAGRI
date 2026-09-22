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
  final DateTime Function() clock;

  DashboardFirebaseDataSource({
    required this.database,
    required this.fallback,
    DateTime Function()? clock,
  }) : clock = clock ?? DateTime.now;

  DatabaseReference get _device => database.ref(DashboardFirebaseKeys.devicePath);

  DatabaseReference get _control => _device.child(DashboardFirebaseKeys.control);

  @override
  Future<DashboardSnapshot> fetchSnapshot() async {
    final results = await Future.wait<Object?>([fallback.fetchSnapshot(), _device.get()]);
    return _merge(results[0]! as DashboardSnapshot, (results[1]! as DataSnapshot).value);
  }

  @override
  Stream<DashboardSnapshot> watchSnapshot() async* {
    final base = await fallback.fetchSnapshot();
    yield* _device.onValue.map((event) => _merge(base, event.snapshot.value));
  }

  @override
  Future<void> setPumpMode(PumpMode mode) =>
      _control.child(DashboardFirebaseKeys.mode).set(mode.label);

  @override
  Future<void> togglePump({required bool isOn}) =>
      _control.child(DashboardFirebaseKeys.pumpCommand).set(isOn);

  @override
  Future<void> selectCrop(CropType crop) =>
      _control.child(DashboardFirebaseKeys.cropProfile).set(crop.label);

  DashboardSnapshot _merge(DashboardSnapshot base, Object? value) {
    final device = _map(value);
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
        isPumpCommandOn:
            _bool(control[DashboardFirebaseKeys.pumpCommand]) ?? base.irrigation.isPumpCommandOn,
        isPumpOn: _bool(control[DashboardFirebaseKeys.pumpStatus]) ?? base.irrigation.isPumpOn,
      ),
      lastUpdated: clock(),
      location: base.location,
    );
  }

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
