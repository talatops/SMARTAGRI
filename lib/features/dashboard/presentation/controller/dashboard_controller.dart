import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_durations.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/crop_profile.dart';
import '../../domain/entities/dashboard_snapshot.dart';
import '../../domain/entities/geo_point.dart';
import '../../domain/entities/location_exception.dart';
import '../../domain/entities/sensor_history.dart';
import '../../domain/entities/weather_snapshot.dart';
import '../../domain/use_cases/get_current_weather_use_case.dart';
import '../../domain/use_cases/get_dashboard_snapshot_use_case.dart';
import '../../domain/use_cases/get_device_location_use_case.dart';
import '../../domain/use_cases/get_place_name_use_case.dart';
import '../../domain/use_cases/open_location_settings_use_case.dart';
import '../../domain/use_cases/save_weather_use_case.dart';
import '../../domain/use_cases/select_crop_use_case.dart';
import '../../domain/use_cases/set_pump_mode_use_case.dart';
import '../../domain/use_cases/toggle_pump_use_case.dart';
import '../../domain/use_cases/watch_dashboard_snapshot_use_case.dart';
import '../../domain/use_cases/watch_sensor_history_use_case.dart';

class DashboardController extends GetxController with WidgetsBindingObserver {
  final GetDashboardSnapshotUseCase getDashboardSnapshotUseCase;
  final WatchDashboardSnapshotUseCase watchDashboardSnapshotUseCase;
  final WatchSensorHistoryUseCase watchSensorHistoryUseCase;
  final SetPumpModeUseCase setPumpModeUseCase;
  final TogglePumpUseCase togglePumpUseCase;
  final SelectCropUseCase selectCropUseCase;
  final GetCurrentWeatherUseCase getCurrentWeatherUseCase;
  final GetDeviceLocationUseCase getDeviceLocationUseCase;
  final GetPlaceNameUseCase getPlaceNameUseCase;
  final OpenLocationSettingsUseCase openLocationSettingsUseCase;
  final SaveWeatherUseCase saveWeatherUseCase;

  final DateTime Function() clock;

  DashboardController({
    required this.getDashboardSnapshotUseCase,
    required this.watchDashboardSnapshotUseCase,
    required this.watchSensorHistoryUseCase,
    required this.setPumpModeUseCase,
    required this.togglePumpUseCase,
    required this.selectCropUseCase,
    required this.getCurrentWeatherUseCase,
    required this.getDeviceLocationUseCase,
    required this.getPlaceNameUseCase,
    required this.openLocationSettingsUseCase,
    required this.saveWeatherUseCase,
    DateTime Function()? clock,
  }) : clock = clock ?? DateTime.now;

  final Rxn<DashboardSnapshot> snapshot = Rxn<DashboardSnapshot>();
  final RxBool isLoading = true.obs;
  final RxBool isRefreshing = false.obs;
  final Rxn<CropProfile> selectedCrop = Rxn<CropProfile>();
  final Rx<PumpMode> pumpMode = PumpMode.auto.obs;
  final RxBool isPumpCommandOn = false.obs;
  final RxBool isPumpOn = false.obs;
  late final Rx<DateTime> now = clock().obs;
  final Rxn<DateTime> lastUpdated = Rxn<DateTime>();
  final Rxn<WeatherSnapshot> weather = Rxn<WeatherSnapshot>();
  final RxBool isWeatherLoading = false.obs;
  final Rxn<GeoPoint> coordinates = Rxn<GeoPoint>();
  final Rxn<String> locationName = Rxn<String>();
  final RxBool isLocationLoading = true.obs;
  final Rxn<LocationIssue> locationIssue = Rxn<LocationIssue>();
  final Rxn<SensorHistory> sensorHistory = Rxn<SensorHistory>();
  final RxMap<HistoryChart, HistoryRange> historyRanges = <HistoryChart, HistoryRange>{}.obs;

  Timer? _clock;
  bool _isResolvingLocation = false;
  bool _isAwaitingSettings = false;
  Timer? _weatherTimer;
  StreamSubscription<DashboardSnapshot>? _subscription;
  StreamSubscription<SensorHistory>? _historySubscription;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _clock = Timer.periodic(AppDurations.clockTick, (_) => now.value = clock());
    watchDashboard();
    watchSensorHistory();
    loadLocation();
    _weatherTimer = Timer.periodic(AppDurations.weatherRefresh, (_) => loadWeather());
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _clock?.cancel();
    _clock = null;
    _weatherTimer?.cancel();
    _weatherTimer = null;
    _subscription?.cancel();
    _subscription = null;
    _historySubscription?.cancel();
    _historySubscription = null;
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed || !_isAwaitingSettings) return;
    _isAwaitingSettings = false;
    loadLocation();
  }

  List<CropProfile> get crops => snapshot.value?.crops ?? const [];

  double get compositeScore => snapshot.value?.composite.score ?? 0;

  MetricStatus get compositeStatus {
    final crop = selectedCrop.value;
    if (crop == null) return MetricStatus.normal;
    return crop.statusOf(compositeScore);
  }

  String get compositeHeadline {
    final crop = selectedCrop.value;
    if (crop == null) return AppStrings.optimalSoilMoisture;
    if (crop.isBelow(compositeScore)) return AppStrings.belowRangeTitle;
    if (crop.isAbove(compositeScore)) return AppStrings.aboveRangeTitle;
    return AppStrings.optimalSoilMoisture;
  }

  String get compositeDescription {
    final crop = selectedCrop.value;
    if (crop == null) return AppStrings.optimalDescription;
    if (crop.isBelow(compositeScore)) return AppStrings.belowRangeDescription;
    if (crop.isAbove(compositeScore)) return AppStrings.aboveRangeDescription;
    return AppStrings.optimalDescription;
  }

  Color get compositeAccent => compositeStatus.isNormal ? AppColors.success : AppColors.amber;

  bool get isPumpControlEnabled => pumpMode.value.isManual;

  String get pumpStatusLabel => isPumpOn.value ? AppStrings.on : AppStrings.off;

  String get pumpStatusDescription =>
      isPumpOn.value ? AppStrings.pumpEnabled : AppStrings.pumpDisabled;

  String get pumpButtonLabel => isPumpCommandOn.value ? AppStrings.pumpOn : AppStrings.pumpOff;

  bool get showWeatherPlaceholder =>
      weather.value == null && (isWeatherLoading.value || isLocationLoading.value);

  LocationIssue? get weatherLocationIssue => coordinates.value == null ? locationIssue.value : null;

  String get locationIssueMessage {
    final issue = weatherLocationIssue;
    if (kIsWeb && (issue?.isPermissionBlocked ?? false)) {
      return AppStrings.locationPermissionBlockedWeb;
    }
    return issue?.message ?? AppStrings.locationFetchFailed;
  }

  bool get _canOpenLocationSettings {
    final issue = weatherLocationIssue;
    return !kIsWeb && issue != null && (issue.isPermissionBlocked || issue.isServiceDisabled);
  }

  String get locationActionLabel {
    if (_canOpenLocationSettings) return AppStrings.openSettings;
    return (weatherLocationIssue?.isPermissionDenied ?? false)
        ? AppStrings.allowLocation
        : AppStrings.tryAgain;
  }

  String get weatherTemperatureLabel {
    final current = weather.value;
    return current == null ? AppStrings.noValue : Formatters.temperature(current.temperatureC);
  }

  String get weatherConditionLabel =>
      weather.value?.condition.label ?? AppStrings.weatherUnavailable;

  String get weatherIcon => weather.value?.icon ?? AppAssets.weatherNotAvailable;

  String get weatherRainChanceLabel {
    final current = weather.value;
    return current == null
        ? AppStrings.noValue
        : Formatters.percent(current.rainChancePercent, decimals: 0);
  }

  String get weatherWindLabel {
    final current = weather.value;
    return current == null ? AppStrings.noValue : Formatters.speed(current.windKmh, decimals: 0);
  }

  String get weatherHumidityLabel {
    final current = weather.value;
    return current == null
        ? AppStrings.noValue
        : Formatters.percent(current.humidityPercent, decimals: 0);
  }

  bool get showLocationPlaceholder => locationName.value == null && isLocationLoading.value;

  String get locationLabel => locationName.value ?? AppStrings.locationUnavailable;

  Future<void> loadLocation() async {
    if (_isResolvingLocation) return;
    _isResolvingLocation = true;
    isLocationLoading.value = true;
    try {
      coordinates.value = await getDeviceLocationUseCase();
      locationIssue.value = null;
    } catch (error) {
      final issue = error is LocationException ? error.issue : LocationIssue.unavailable;
      locationIssue.value = issue;
      if (!issue.isUnavailable) _clearLocation();
    } finally {
      _isResolvingLocation = false;
    }

    if (coordinates.value == null) {
      isLocationLoading.value = false;
      return;
    }
    await Future.wait([loadPlaceName(), loadWeather()]);
  }

  Future<void> resolveLocationIssue() async {
    final issue = weatherLocationIssue;
    if (issue == null) return;
    final openedSettings =
        _canOpenLocationSettings &&
        await openLocationSettingsUseCase(issue).catchError((Object _) => false);
    _isAwaitingSettings = openedSettings;
    if (!openedSettings) await loadLocation();
  }

  void _clearLocation() {
    coordinates.value = null;
    locationName.value = null;
    weather.value = null;
  }

  Future<void> loadPlaceName() async {
    final point = coordinates.value;
    if (point == null) return;
    isLocationLoading.value = true;
    locationName.value = await getPlaceNameUseCase(point)
        .then<String?>((value) => value)
        .catchError((Object _) => locationName.value);
    isLocationLoading.value = false;
  }

  Future<void> loadWeather() async {
    final point = coordinates.value;
    if (point == null) return;
    isWeatherLoading.value = true;
    final result = await getCurrentWeatherUseCase(point)
        .then<WeatherSnapshot?>((value) => value)
        .catchError((Object _) => null);
    if (result != null) {
      weather.value = result;
      saveWeatherUseCase(result).catchError((Object _) {});
    }
    isWeatherLoading.value = false;
  }

  Future<void> loadDashboard({bool isRefresh = false}) async {
    if (isRefresh) {
      isRefreshing.value = true;
      loadLocation();
    } else {
      isLoading.value = true;
    }

    try {
      _apply(await getDashboardSnapshotUseCase());
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  void watchDashboard() {
    _subscription?.cancel();
    isLoading.value = snapshot.value == null;
    _subscription = watchDashboardSnapshotUseCase().listen(
      (result) {
        _apply(result);
        isLoading.value = false;
      },
      onError: (Object _) => isLoading.value = false,
    );
  }

  void watchSensorHistory() {
    _historySubscription?.cancel();
    _historySubscription = watchSensorHistoryUseCase().listen(
      (result) => sensorHistory.value = result,
      onError: (Object _) {},
    );
  }

  HistoryRange historyRangeOf(HistoryChart chart) =>
      historyRanges[chart] ?? HistoryRange.last24Hours;

  void selectHistoryRange(HistoryChart chart, HistoryRange range) => historyRanges[chart] = range;

  void _apply(DashboardSnapshot result) {
    snapshot.value = result;
    selectedCrop.value = result.selectedCrop;
    pumpMode.value = result.irrigation.mode;
    isPumpCommandOn.value = result.irrigation.isPumpCommandOn;
    isPumpOn.value = result.irrigation.isPumpOn;
    lastUpdated.value = result.lastUpdated;
  }

  void _revert() {
    final current = snapshot.value;
    if (current != null) _apply(current);
  }

  Future<void> selectCrop(CropProfile crop) async {
    if (selectedCrop.value == crop) return;
    selectedCrop.value = crop;
    try {
      await selectCropUseCase(crop.type);
    } catch (_) {
      _revert();
    }
  }

  Future<void> setPumpMode(PumpMode mode) async {
    if (pumpMode.value == mode) return;
    pumpMode.value = mode;
    try {
      await setPumpModeUseCase(mode);
    } catch (_) {
      _revert();
    }
  }

  Future<void> togglePump() async {
    if (!isPumpControlEnabled) return;
    try {
      await togglePumpUseCase(isOn: !isPumpCommandOn.value);
    } catch (_) {
      _revert();
    }
  }
}
