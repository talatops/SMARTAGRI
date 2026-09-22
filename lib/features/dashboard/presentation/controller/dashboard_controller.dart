import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_durations.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/enums.dart';
import '../../domain/entities/crop_profile.dart';
import '../../domain/entities/dashboard_snapshot.dart';
import '../../domain/use_cases/get_dashboard_snapshot_use_case.dart';
import '../../domain/use_cases/set_pump_mode_use_case.dart';
import '../../domain/use_cases/toggle_pump_use_case.dart';

class DashboardController extends GetxController {
  final GetDashboardSnapshotUseCase getDashboardSnapshotUseCase;
  final SetPumpModeUseCase setPumpModeUseCase;
  final TogglePumpUseCase togglePumpUseCase;

  final DateTime Function() clock;

  DashboardController({
    required this.getDashboardSnapshotUseCase,
    required this.setPumpModeUseCase,
    required this.togglePumpUseCase,
    DateTime Function()? clock,
  }) : clock = clock ?? DateTime.now;

  final Rxn<DashboardSnapshot> snapshot = Rxn<DashboardSnapshot>();
  final RxBool isLoading = true.obs;
  final RxBool isRefreshing = false.obs;
  final Rxn<CropProfile> selectedCrop = Rxn<CropProfile>();
  final Rx<PumpMode> pumpMode = PumpMode.auto.obs;
  final RxBool isPumpOn = false.obs;
  late final Rx<DateTime> now = clock().obs;
  final Rxn<DateTime> lastUpdated = Rxn<DateTime>();

  Timer? _clock;

  @override
  void onInit() {
    super.onInit();
    _clock = Timer.periodic(AppDurations.clockTick, (_) => now.value = clock());
    loadDashboard();
  }

  @override
  void onClose() {
    _clock?.cancel();
    _clock = null;
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

  String get pumpButtonLabel => isPumpOn.value ? AppStrings.pumpOn : AppStrings.pumpOff;

  Future<void> loadDashboard({bool isRefresh = false}) async {
    if (isRefresh) {
      isRefreshing.value = true;
    } else {
      isLoading.value = true;
    }

    try {
      final result = await getDashboardSnapshotUseCase();
      snapshot.value = result;
      selectedCrop.value = selectedCrop.value ?? result.selectedCrop;
      pumpMode.value = result.irrigation.mode;
      isPumpOn.value = result.irrigation.isPumpOn;
      lastUpdated.value = result.lastUpdated;
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  void selectCrop(CropProfile crop) {
    if (selectedCrop.value == crop) return;
    selectedCrop.value = crop;
  }

  Future<void> setPumpMode(PumpMode mode) async {
    if (pumpMode.value == mode) return;
    final state = await setPumpModeUseCase(mode);
    pumpMode.value = state.mode;
    isPumpOn.value = state.isPumpOn;
  }

  Future<void> togglePump() async {
    if (!isPumpControlEnabled) return;
    final state = await togglePumpUseCase(isOn: !isPumpOn.value);
    isPumpOn.value = state.isPumpOn;
  }
}
