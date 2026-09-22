import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_durations.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/datasource/field_location.dart';
import '../../domain/entities/crop_profile.dart';
import '../../domain/entities/dashboard_snapshot.dart';
import '../../domain/entities/geo_point.dart';
import '../../domain/entities/weather_snapshot.dart';
import '../../domain/use_cases/get_current_weather_use_case.dart';
import '../../domain/use_cases/get_dashboard_snapshot_use_case.dart';
import '../../domain/use_cases/get_device_location_use_case.dart';
import '../../domain/use_cases/get_place_name_use_case.dart';
import '../../domain/use_cases/select_crop_use_case.dart';
import '../../domain/use_cases/set_pump_mode_use_case.dart';
import '../../domain/use_cases/toggle_pump_use_case.dart';
import '../../domain/use_cases/watch_dashboard_snapshot_use_case.dart';

class DashboardController extends GetxController {
  final GetDashboardSnapshotUseCase getDashboardSnapshotUseCase;
  final WatchDashboardSnapshotUseCase watchDashboardSnapshotUseCase;
  final SetPumpModeUseCase setPumpModeUseCase;
  final TogglePumpUseCase togglePumpUseCase;
  final SelectCropUseCase selectCropUseCase;
  final GetCurrentWeatherUseCase getCurrentWeatherUseCase;
  final GetDeviceLocationUseCase getDeviceLocationUseCase;
  final GetPlaceNameUseCase getPlaceNameUseCase;

  final DateTime Function() clock;

  DashboardController({
    required this.getDashboardSnapshotUseCase,
    required this.watchDashboardSnapshotUseCase,
    required this.setPumpModeUseCase,
    required this.togglePumpUseCase,
    required this.selectCropUseCase,
    required this.getCurrentWeatherUseCase,
    required this.getDeviceLocationUseCase,
    required this.getPlaceNameUseCase,
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
  final RxBool isWeatherLoading = true.obs;
  final Rxn<GeoPoint> coordinates = Rxn<GeoPoint>();
  final Rxn<String> locationName = Rxn<String>();
  final RxBool isLocationLoading = true.obs;

  Timer? _clock;
  Timer? _weatherTimer;
  StreamSubscription<DashboardSnapshot>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _clock = Timer.periodic(AppDurations.clockTick, (_) => now.value = clock());
    watchDashboard();
    loadLocation();
    _weatherTimer = Timer.periodic(AppDurations.weatherRefresh, (_) => loadWeather());
  }

  @override
  void onClose() {
    _clock?.cancel();
    _clock = null;
    _weatherTimer?.cancel();
    _weatherTimer = null;
    _subscription?.cancel();
    _subscription = null;
    super.onClose();
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

  bool get showWeatherPlaceholder => weather.value == null && isWeatherLoading.value;

  String get weatherTemperatureLabel {
    final current = weather.value;
    return current == null ? AppStrings.noValue : Formatters.temperature(current.temperatureC);
  }

  String get weatherConditionLabel => weather.value?.condition ?? AppStrings.weatherUnavailable;

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
    isLocationLoading.value = true;
    coordinates.value = await getDeviceLocationUseCase()
        .then<GeoPoint?>((value) => value)
        .catchError((Object _) => FieldLocation.fallback);
    await Future.wait([loadPlaceName(), loadWeather()]);
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
    final point = coordinates.value ?? FieldLocation.fallback;
    isWeatherLoading.value = true;
    weather.value = await getCurrentWeatherUseCase(point)
        .then<WeatherSnapshot?>((value) => value)
        .catchError((Object _) => weather.value);
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
