import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/app_durations.dart';
import '../../../../core/utils/enums.dart';
import '../../domain/entities/crop_profile.dart';
import '../../domain/entities/dashboard_snapshot.dart';
import '../../domain/entities/geo_point.dart';
import '../../domain/entities/location_exception.dart';
import '../../domain/entities/weather_snapshot.dart';
import '../providers/dashboard_providers.dart';
import 'dashboard_state.dart';

part 'dashboard_notifier.g.dart';

@Riverpod(keepAlive: true)
class DashboardNotifier extends _$DashboardNotifier with WidgetsBindingObserver {
  late DateTime Function() _clock;
  bool _isResolvingLocation = false;
  bool _isAwaitingSettings = false;

  @override
  DashboardState build() {
    _clock = ref.read(clockProvider);
    WidgetsBinding.instance.addObserver(this);

    final clockTimer = Timer.periodic(
      AppDurations.clockTick,
      (_) => state = state.copyWith(now: _clock()),
    );
    final weatherTimer = Timer.periodic(AppDurations.weatherRefresh, (_) => loadWeather());
    final subscription = ref.read(watchDashboardSnapshotUseCaseProvider)().listen(
      (result) {
        _apply(result);
        state = state.copyWith(isLoading: false);
      },
      onError: (Object _) => state = state.copyWith(isLoading: false),
    );
    final historySubscription = ref.read(watchSensorHistoryUseCaseProvider)().listen(
      (result) => state = state.copyWith(sensorHistory: result),
      onError: (Object _) {},
    );

    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      clockTimer.cancel();
      weatherTimer.cancel();
      subscription.cancel();
      historySubscription.cancel();
    });

    _isResolvingLocation = true;
    _resolveLocation(ref.read(getDeviceLocationUseCaseProvider)());

    return DashboardState.initial(now: _clock());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed || !_isAwaitingSettings) return;
    _isAwaitingSettings = false;
    loadLocation();
  }

  Future<void> loadLocation() {
    if (_isResolvingLocation) return Future.value();
    _isResolvingLocation = true;
    state = state.copyWith(isLocationLoading: true);
    return _resolveLocation(ref.read(getDeviceLocationUseCaseProvider)());
  }

  Future<void> _resolveLocation(Future<GeoPoint> request) async {
    try {
      final point = await request;
      if (!ref.mounted) return;
      state = state.copyWith(coordinates: () => point, locationIssue: () => null);
    } catch (error) {
      if (!ref.mounted) return;
      final issue = error is LocationException ? error.issue : LocationIssue.unavailable;
      state = issue.isUnavailable
          ? state.copyWith(locationIssue: () => issue)
          : state.copyWith(
              locationIssue: () => issue,
              coordinates: () => null,
              locationName: () => null,
              weather: () => null,
            );
    } finally {
      _isResolvingLocation = false;
    }

    if (state.coordinates == null) {
      state = state.copyWith(isLocationLoading: false);
      return;
    }
    await Future.wait([loadPlaceName(), loadWeather()]);
  }

  Future<void> resolveLocationIssue() async {
    final issue = state.weatherLocationIssue;
    if (issue == null) return;
    final openedSettings =
        state.canOpenLocationSettings &&
        await ref.read(openLocationSettingsUseCaseProvider)(issue).catchError((Object _) => false);
    if (!ref.mounted) return;
    _isAwaitingSettings = openedSettings;
    if (!openedSettings) await loadLocation();
  }

  Future<void> loadPlaceName() async {
    final point = state.coordinates;
    if (point == null) return;
    state = state.copyWith(isLocationLoading: true);
    final name = await ref
        .read(getPlaceNameUseCaseProvider)(point)
        .then<String?>((value) => value)
        .catchError((Object _) => null);
    if (!ref.mounted) return;
    state = state.copyWith(
      locationName: () => name ?? state.locationName,
      isLocationLoading: false,
    );
  }

  Future<void> loadWeather() async {
    final point = state.coordinates;
    if (point == null) return;
    state = state.copyWith(isWeatherLoading: true);
    final result = await ref
        .read(getCurrentWeatherUseCaseProvider)(point)
        .then<WeatherSnapshot?>((value) => value)
        .catchError((Object _) => null);
    if (!ref.mounted) return;
    if (result != null) {
      state = state.copyWith(weather: () => result);
      ref.read(saveWeatherUseCaseProvider)(result).catchError((Object _) {});
    }
    state = state.copyWith(isWeatherLoading: false);
  }

  Future<void> loadDashboard({bool isRefresh = false}) async {
    if (isRefresh) {
      state = state.copyWith(isRefreshing: true);
      loadLocation();
    } else {
      state = state.copyWith(isLoading: true);
    }

    try {
      final result = await ref.read(getDashboardSnapshotUseCaseProvider)();
      if (!ref.mounted) return;
      _apply(result);
    } finally {
      if (ref.mounted) state = state.copyWith(isLoading: false, isRefreshing: false);
    }
  }

  void selectHistoryRange(HistoryChart chart, HistoryRange range) =>
      state = state.copyWith(historyRanges: {...state.historyRanges, chart: range});

  void _apply(DashboardSnapshot result) {
    state = state.copyWith(
      snapshot: result,
      selectedCrop: result.selectedCrop,
      pumpMode: result.irrigation.mode,
      isPumpCommandOn: result.irrigation.isPumpCommandOn,
      isPumpOn: result.irrigation.isPumpOn,
      lastUpdated: result.lastUpdated,
    );
  }

  void _revert() {
    final current = state.snapshot;
    if (current != null) _apply(current);
  }

  Future<void> selectCrop(CropProfile crop) async {
    if (state.selectedCrop == crop) return;
    state = state.copyWith(selectedCrop: crop);
    try {
      await ref.read(selectCropUseCaseProvider)(crop.type);
    } catch (_) {
      if (ref.mounted) _revert();
    }
  }

  Future<void> setPumpMode(PumpMode mode) async {
    if (state.pumpMode == mode) return;
    state = state.copyWith(pumpMode: mode);
    try {
      await ref.read(setPumpModeUseCaseProvider)(mode);
    } catch (_) {
      if (ref.mounted) _revert();
    }
  }

  Future<void> togglePump() async {
    if (!state.isPumpControlEnabled) return;
    try {
      await ref.read(togglePumpUseCaseProvider)(isOn: !state.isPumpCommandOn);
    } catch (_) {
      if (ref.mounted) _revert();
    }
  }
}
