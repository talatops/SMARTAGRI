import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:smart_agri_system/core/utils/enums.dart';
import 'package:smart_agri_system/features/dashboard/domain/entities/crop_profile.dart';
import 'package:smart_agri_system/features/dashboard/domain/entities/dashboard_snapshot.dart';
import 'package:smart_agri_system/features/dashboard/domain/entities/geo_point.dart';
import 'package:smart_agri_system/features/dashboard/domain/entities/sensor_history.dart';
import 'package:smart_agri_system/features/dashboard/domain/entities/weather_snapshot.dart';
import 'package:smart_agri_system/features/dashboard/presentation/notifier/dashboard_notifier.dart';
import 'package:smart_agri_system/features/dashboard/presentation/notifier/dashboard_state.dart';
import 'package:smart_agri_system/features/dashboard/presentation/providers/dashboard_providers.dart';

import 'fakes.dart';

List<Override> dashboardOverrides(DashboardFakes fakes, {DateTime Function()? clock}) => [
  if (clock != null) clockProvider.overrideWithValue(clock),
  dashboardRepositoryProvider.overrideWithValue(fakes.dashboard),
  sensorHistoryRepositoryProvider.overrideWithValue(fakes.history),
  weatherRepositoryProvider.overrideWithValue(fakes.weather),
  locationRepositoryProvider.overrideWithValue(fakes.location),
];

class DashboardHarness {
  final DashboardFakes fakes;
  final DateTime Function() clock;
  late final ProviderContainer _container;

  DashboardHarness(this.fakes, {required this.clock});

  void start() {
    _container = ProviderContainer(overrides: dashboardOverrides(fakes, clock: clock));
    _container.listen(dashboardProvider, (_, _) {});
  }

  void dispose() => _container.dispose();

  DashboardState get _state => _container.read(dashboardProvider);
  DashboardNotifier get _notifier => _container.read(dashboardProvider.notifier);

  DashboardSnapshot? get snapshot => _state.snapshot;
  bool get isLoading => _state.isLoading;
  bool get isRefreshing => _state.isRefreshing;
  CropProfile? get selectedCrop => _state.selectedCrop;
  PumpMode get pumpMode => _state.pumpMode;
  bool get isPumpCommandOn => _state.isPumpCommandOn;
  bool get isPumpOn => _state.isPumpOn;
  DateTime get now => _state.now;
  DateTime? get lastUpdated => _state.lastUpdated;
  WeatherSnapshot? get weather => _state.weather;
  bool get isWeatherLoading => _state.isWeatherLoading;
  GeoPoint? get coordinates => _state.coordinates;
  String? get locationName => _state.locationName;
  bool get isLocationLoading => _state.isLocationLoading;
  LocationIssue? get locationIssue => _state.locationIssue;
  SensorHistory? get sensorHistory => _state.sensorHistory;

  List<CropProfile> get crops => _state.crops;
  double get compositeScore => _state.compositeScore;
  MetricStatus get compositeStatus => _state.compositeStatus;
  String get compositeHeadline => _state.compositeHeadline;
  String get compositeDescription => _state.compositeDescription;
  Color get compositeAccent => _state.compositeAccent;
  bool get isPumpControlEnabled => _state.isPumpControlEnabled;
  String get pumpStatusLabel => _state.pumpStatusLabel;
  String get pumpStatusDescription => _state.pumpStatusDescription;
  String get pumpButtonLabel => _state.pumpButtonLabel;
  bool get showWeatherPlaceholder => _state.showWeatherPlaceholder;
  LocationIssue? get weatherLocationIssue => _state.weatherLocationIssue;
  String get locationIssueMessage => _state.locationIssueMessage;
  String get locationActionLabel => _state.locationActionLabel;
  String get weatherTemperatureLabel => _state.weatherTemperatureLabel;
  String get weatherConditionLabel => _state.weatherConditionLabel;
  String get weatherIcon => _state.weatherIcon;
  String get weatherRainChanceLabel => _state.weatherRainChanceLabel;
  String get weatherWindLabel => _state.weatherWindLabel;
  String get weatherHumidityLabel => _state.weatherHumidityLabel;
  bool get showLocationPlaceholder => _state.showLocationPlaceholder;
  String get locationLabel => _state.locationLabel;
  HistoryRange historyRangeOf(HistoryChart chart) => _state.historyRangeOf(chart);

  Future<void> loadLocation() => _notifier.loadLocation();
  Future<void> resolveLocationIssue() => _notifier.resolveLocationIssue();
  Future<void> loadWeather() => _notifier.loadWeather();
  Future<void> loadDashboard({bool isRefresh = false}) =>
      _notifier.loadDashboard(isRefresh: isRefresh);
  void selectHistoryRange(HistoryChart chart, HistoryRange range) =>
      _notifier.selectHistoryRange(chart, range);
  Future<void> selectCrop(CropProfile crop) => _notifier.selectCrop(crop);
  Future<void> setPumpMode(PumpMode mode) => _notifier.setPumpMode(mode);
  Future<void> togglePump() => _notifier.togglePump();
}
