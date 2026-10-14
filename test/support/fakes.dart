import 'dart:async';

import 'package:smart_agri_system/core/utils/app_assets.dart';
import 'package:smart_agri_system/core/utils/app_strings.dart';
import 'package:smart_agri_system/core/utils/enums.dart';
import 'package:smart_agri_system/features/dashboard/data/datasource/dashboard_mock_data_source.dart';
import 'package:smart_agri_system/features/dashboard/domain/entities/composite_moisture.dart';
import 'package:smart_agri_system/features/dashboard/domain/entities/crop_profile.dart';
import 'package:smart_agri_system/features/dashboard/domain/entities/dashboard_snapshot.dart';
import 'package:smart_agri_system/features/dashboard/domain/entities/field_telemetry.dart';
import 'package:smart_agri_system/features/dashboard/domain/entities/field_water_level.dart';
import 'package:smart_agri_system/features/dashboard/domain/entities/geo_point.dart';
import 'package:smart_agri_system/features/dashboard/domain/entities/irrigation_state.dart';
import 'package:smart_agri_system/features/dashboard/domain/entities/sensor_history.dart';
import 'package:smart_agri_system/features/dashboard/domain/entities/soil_reading.dart';
import 'package:smart_agri_system/features/dashboard/domain/entities/weather_snapshot.dart';
import 'package:smart_agri_system/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:smart_agri_system/features/dashboard/domain/repositories/location_repository.dart';
import 'package:smart_agri_system/features/dashboard/domain/repositories/sensor_history_repository.dart';
import 'package:smart_agri_system/features/dashboard/domain/repositories/weather_repository.dart';

const crops = DashboardMockDataSource.crops;

CropProfile cropOf(CropType type) => crops.firstWhere((crop) => crop.type == type);

const samplePoint = GeoPoint(latitude: 33.6844, longitude: 73.0479);

const sampleWeather = WeatherSnapshot(
  temperatureC: 22.6,
  condition: WeatherCondition.partlyCloudy,
  isDay: true,
  rainChancePercent: 15,
  windKmh: 12,
  humidityPercent: 58,
);

final sampleUpdated = DateTime(2026, 9, 25, 14, 5, 9);

DashboardSnapshot buildSnapshot({
  double score = 50.7,
  CropType crop = CropType.wheat,
  PumpMode mode = PumpMode.auto,
  bool isPumpCommandOn = false,
  bool isPumpOn = false,
  DateTime? lastUpdated,
}) {
  return DashboardSnapshot(
    soilReadings: const [
      SoilReading(depth: SoilDepth.surface, moisturePercent: 52, icon: AppAssets.surfaceZone),
      SoilReading(depth: SoilDepth.root, moisturePercent: 45, icon: AppAssets.rootZone),
      SoilReading(depth: SoilDepth.deep, moisturePercent: 70, icon: AppAssets.deepZone),
    ],
    waterLevel: const FieldWaterLevel(centimeters: 2, status: MetricStatus.normal),
    composite: CompositeMoisture(score: score),
    telemetry: const FieldTelemetry(
      temperatureC: 28.4,
      humidityPercent: 62,
      temperatureStatus: MetricStatus.normal,
      humidityStatus: MetricStatus.normal,
    ),
    weather: sampleWeather,
    crops: crops,
    selectedCrop: cropOf(crop),
    irrigation: IrrigationState(
      mode: mode,
      isPumpCommandOn: isPumpCommandOn,
      isPumpOn: isPumpOn,
    ),
    lastUpdated: lastUpdated ?? sampleUpdated,
    location: AppStrings.location,
  );
}

SensorHistory buildHistory({double seed = 10}) {
  return SensorHistory(
    readings: {
      for (final series in HistorySeries.values)
        series: [
          for (var i = 0; i < SensorHistory.hoursInWindow; i++)
            series == HistorySeries.pumpStatus ? (i.isEven ? 1 : 0) : seed + i,
        ],
    },
  );
}

class FakeDashboardRepository implements DashboardRepository {
  final snapshots = StreamController<DashboardSnapshot>.broadcast();

  DashboardSnapshot fetchResult = buildSnapshot();
  Object? fetchError;
  Completer<void>? fetchGate;
  int fetchCalls = 0;

  Object? writeError;
  Completer<void>? writeGate;
  final pumpModeCalls = <PumpMode>[];
  final toggleCalls = <bool>[];
  final cropCalls = <CropType>[];

  Object? saveError;
  final savedWeather = <WeatherSnapshot>[];

  int watchCalls = 0;

  void emit(DashboardSnapshot snapshot) => snapshots.add(snapshot);

  void emitError(Object error) => snapshots.addError(error);

  @override
  Future<DashboardSnapshot> getDashboardSnapshot() async {
    fetchCalls++;
    final gate = fetchGate;
    if (gate != null) await gate.future;
    final error = fetchError;
    if (error != null) throw error;
    return fetchResult;
  }

  @override
  Stream<DashboardSnapshot> watchDashboardSnapshot() {
    watchCalls++;
    return snapshots.stream;
  }

  Future<void> _write() async {
    final gate = writeGate;
    if (gate != null) await gate.future;
    final error = writeError;
    if (error != null) throw error;
  }

  @override
  Future<void> setPumpMode(PumpMode mode) {
    pumpModeCalls.add(mode);
    return _write();
  }

  @override
  Future<void> togglePump({required bool isOn}) {
    toggleCalls.add(isOn);
    return _write();
  }

  @override
  Future<void> selectCrop(CropType crop) {
    cropCalls.add(crop);
    return _write();
  }

  @override
  Future<void> saveWeather(WeatherSnapshot weather) async {
    savedWeather.add(weather);
    final error = saveError;
    if (error != null) throw error;
  }
}

class FakeSensorHistoryRepository implements SensorHistoryRepository {
  final history = StreamController<SensorHistory>.broadcast();

  void emit(SensorHistory value) => history.add(value);

  void emitError(Object error) => history.addError(error);

  @override
  Stream<SensorHistory> watchSensorHistory() => history.stream;
}

class FakeWeatherRepository implements WeatherRepository {
  WeatherSnapshot result = sampleWeather;
  Object? error;
  Completer<void>? gate;
  final calls = <GeoPoint>[];

  @override
  Future<WeatherSnapshot> getCurrentWeather(GeoPoint point) async {
    calls.add(point);
    final pending = gate;
    if (pending != null) await pending.future;
    final failure = error;
    if (failure != null) throw failure;
    return result;
  }
}

class FakeLocationRepository implements LocationRepository {
  Future<GeoPoint> Function() locate = () => Completer<GeoPoint>().future;
  int locateCalls = 0;

  String placeName = 'Islamabad, PK';
  Object? placeError;
  Completer<void>? placeGate;
  final placeCalls = <GeoPoint>[];

  Future<bool> Function(LocationIssue issue) openSettingsResult = (_) async => true;
  final openSettingsCalls = <LocationIssue>[];

  @override
  Future<GeoPoint> getDeviceLocation() {
    locateCalls++;
    return locate();
  }

  @override
  Future<String> getPlaceName(GeoPoint point) async {
    placeCalls.add(point);
    final gate = placeGate;
    if (gate != null) await gate.future;
    final error = placeError;
    if (error != null) throw error;
    return placeName;
  }

  @override
  Future<bool> openSettings(LocationIssue issue) {
    openSettingsCalls.add(issue);
    return openSettingsResult(issue);
  }
}

class DashboardFakes {
  final dashboard = FakeDashboardRepository();
  final history = FakeSensorHistoryRepository();
  final weather = FakeWeatherRepository();
  final location = FakeLocationRepository();

  void locateAt(GeoPoint point) => location.locate = () async => point;

  void locateFails(Object error) => location.locate = () => Future<GeoPoint>.error(error);
}
