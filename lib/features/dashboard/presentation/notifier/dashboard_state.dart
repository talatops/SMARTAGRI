import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/crop_profile.dart';
import '../../domain/entities/dashboard_snapshot.dart';
import '../../domain/entities/geo_point.dart';
import '../../domain/entities/sensor_history.dart';
import '../../domain/entities/weather_snapshot.dart';

@immutable
class DashboardState {
  final DashboardSnapshot? snapshot;
  final bool isLoading;
  final bool isRefreshing;
  final CropProfile? selectedCrop;
  final PumpMode pumpMode;
  final bool isPumpCommandOn;
  final bool isPumpOn;
  final DateTime now;
  final DateTime? lastUpdated;
  final WeatherSnapshot? weather;
  final bool isWeatherLoading;
  final GeoPoint? coordinates;
  final String? locationName;
  final bool isLocationLoading;
  final LocationIssue? locationIssue;
  final SensorHistory? sensorHistory;
  final Map<HistoryChart, HistoryRange> historyRanges;

  const DashboardState({
    required this.snapshot,
    required this.isLoading,
    required this.isRefreshing,
    required this.selectedCrop,
    required this.pumpMode,
    required this.isPumpCommandOn,
    required this.isPumpOn,
    required this.now,
    required this.lastUpdated,
    required this.weather,
    required this.isWeatherLoading,
    required this.coordinates,
    required this.locationName,
    required this.isLocationLoading,
    required this.locationIssue,
    required this.sensorHistory,
    required this.historyRanges,
  });

  factory DashboardState.initial({required DateTime now}) => DashboardState(
    snapshot: null,
    isLoading: true,
    isRefreshing: false,
    selectedCrop: null,
    pumpMode: PumpMode.auto,
    isPumpCommandOn: false,
    isPumpOn: false,
    now: now,
    lastUpdated: null,
    weather: null,
    isWeatherLoading: false,
    coordinates: null,
    locationName: null,
    isLocationLoading: true,
    locationIssue: null,
    sensorHistory: null,
    historyRanges: const {},
  );

  DashboardState copyWith({
    DashboardSnapshot? snapshot,
    bool? isLoading,
    bool? isRefreshing,
    CropProfile? selectedCrop,
    PumpMode? pumpMode,
    bool? isPumpCommandOn,
    bool? isPumpOn,
    DateTime? now,
    DateTime? lastUpdated,
    ValueGetter<WeatherSnapshot?>? weather,
    bool? isWeatherLoading,
    ValueGetter<GeoPoint?>? coordinates,
    ValueGetter<String?>? locationName,
    bool? isLocationLoading,
    ValueGetter<LocationIssue?>? locationIssue,
    SensorHistory? sensorHistory,
    Map<HistoryChart, HistoryRange>? historyRanges,
  }) => DashboardState(
    snapshot: snapshot ?? this.snapshot,
    isLoading: isLoading ?? this.isLoading,
    isRefreshing: isRefreshing ?? this.isRefreshing,
    selectedCrop: selectedCrop ?? this.selectedCrop,
    pumpMode: pumpMode ?? this.pumpMode,
    isPumpCommandOn: isPumpCommandOn ?? this.isPumpCommandOn,
    isPumpOn: isPumpOn ?? this.isPumpOn,
    now: now ?? this.now,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    weather: weather != null ? weather() : this.weather,
    isWeatherLoading: isWeatherLoading ?? this.isWeatherLoading,
    coordinates: coordinates != null ? coordinates() : this.coordinates,
    locationName: locationName != null ? locationName() : this.locationName,
    isLocationLoading: isLocationLoading ?? this.isLocationLoading,
    locationIssue: locationIssue != null ? locationIssue() : this.locationIssue,
    sensorHistory: sensorHistory ?? this.sensorHistory,
    historyRanges: historyRanges ?? this.historyRanges,
  );

  List<CropProfile> get crops => snapshot?.crops ?? const [];

  double get compositeScore => snapshot?.composite.score ?? 0;

  MetricStatus get compositeStatus {
    final crop = selectedCrop;
    if (crop == null) return MetricStatus.normal;
    return crop.statusOf(compositeScore);
  }

  String get compositeHeadline {
    final crop = selectedCrop;
    if (crop == null) return AppStrings.optimalSoilMoisture;
    if (crop.isBelow(compositeScore)) return AppStrings.belowRangeTitle;
    if (crop.isAbove(compositeScore)) return AppStrings.aboveRangeTitle;
    return AppStrings.optimalSoilMoisture;
  }

  String get compositeDescription {
    final crop = selectedCrop;
    if (crop == null) return AppStrings.optimalDescription;
    if (crop.isBelow(compositeScore)) return AppStrings.belowRangeDescription;
    if (crop.isAbove(compositeScore)) return AppStrings.aboveRangeDescription;
    return AppStrings.optimalDescription;
  }

  Color get compositeAccent => compositeStatus.isNormal ? AppColors.success : AppColors.amber;

  bool get isPumpControlEnabled => pumpMode.isManual;

  String get pumpStatusLabel => isPumpOn ? AppStrings.on : AppStrings.off;

  String get pumpStatusDescription => isPumpOn ? AppStrings.pumpEnabled : AppStrings.pumpDisabled;

  String get pumpButtonLabel => isPumpCommandOn ? AppStrings.pumpOn : AppStrings.pumpOff;

  bool get showWeatherPlaceholder => weather == null && (isWeatherLoading || isLocationLoading);

  LocationIssue? get weatherLocationIssue => coordinates == null ? locationIssue : null;

  String get locationIssueMessage {
    final issue = weatherLocationIssue;
    if (kIsWeb && (issue?.isPermissionBlocked ?? false)) {
      return AppStrings.locationPermissionBlockedWeb;
    }
    return issue?.message ?? AppStrings.locationFetchFailed;
  }

  bool get canOpenLocationSettings {
    final issue = weatherLocationIssue;
    return !kIsWeb && issue != null && (issue.isPermissionBlocked || issue.isServiceDisabled);
  }

  String get locationActionLabel {
    if (canOpenLocationSettings) return AppStrings.openSettings;
    return (weatherLocationIssue?.isPermissionDenied ?? false)
        ? AppStrings.allowLocation
        : AppStrings.tryAgain;
  }

  String get weatherTemperatureLabel {
    final current = weather;
    return current == null ? AppStrings.noValue : Formatters.temperature(current.temperatureC);
  }

  String get weatherConditionLabel => weather?.condition.label ?? AppStrings.weatherUnavailable;

  String get weatherIcon => weather?.icon ?? AppAssets.weatherNotAvailable;

  String get weatherRainChanceLabel {
    final current = weather;
    return current == null
        ? AppStrings.noValue
        : Formatters.percent(current.rainChancePercent, decimals: 0);
  }

  String get weatherWindLabel {
    final current = weather;
    return current == null ? AppStrings.noValue : Formatters.speed(current.windKmh, decimals: 0);
  }

  String get weatherHumidityLabel {
    final current = weather;
    return current == null
        ? AppStrings.noValue
        : Formatters.percent(current.humidityPercent, decimals: 0);
  }

  bool get showLocationPlaceholder => locationName == null && isLocationLoading;

  String get locationLabel => locationName ?? AppStrings.locationUnavailable;

  HistoryRange historyRangeOf(HistoryChart chart) =>
      historyRanges[chart] ?? HistoryRange.today;

  int get currentHour => now.hour;
}
