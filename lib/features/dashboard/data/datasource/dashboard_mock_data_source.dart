import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_durations.dart';
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

class DashboardMockDataSource implements DashboardDataSource {
  final DateTime Function() clock;

  DashboardMockDataSource({DateTime Function()? clock})
    : clock = clock ?? DateTime.now;

  IrrigationState _irrigation = const IrrigationState(mode: PumpMode.auto, isPumpOn: false);

  static const crops = <CropProfile>[
    CropProfile(
      type: CropType.wheat,
      minMoisture: 40,
      maxMoisture: 70,
      icon: AppAssets.cropWheat,
      iconColor: AppColors.cropWheat,
    ),
    CropProfile(
      type: CropType.rice,
      minMoisture: 60,
      maxMoisture: 85,
      icon: AppAssets.cropRice,
      iconColor: AppColors.cropRice,
    ),
    CropProfile(
      type: CropType.cotton,
      minMoisture: 35,
      maxMoisture: 65,
      icon: AppAssets.cropCotton,
      iconColor: AppColors.cropCotton,
    ),
    CropProfile(
      type: CropType.sugarcane,
      minMoisture: 50,
      maxMoisture: 80,
      icon: AppAssets.cropSugarcane,
      iconColor: AppColors.cropSugarcane,
    ),
    CropProfile(
      type: CropType.maize,
      minMoisture: 45,
      maxMoisture: 75,
      icon: AppAssets.cropMaize,
      iconColor: AppColors.cropMaize,
    ),
  ];

  @override
  Future<DashboardSnapshot> fetchSnapshot() async {
    await Future<void>.delayed(AppDurations.mockLatency);

    return DashboardSnapshot(
      soilReadings: const [
        SoilReading(depth: SoilDepth.surface, moisturePercent: 52, icon: AppAssets.surfaceZone),
        SoilReading(depth: SoilDepth.root, moisturePercent: 45, icon: AppAssets.rootZone),
        SoilReading(depth: SoilDepth.deep, moisturePercent: 70, icon: AppAssets.deepZone),
      ],
      waterLevel: const FieldWaterLevel(centimeters: 2, status: MetricStatus.normal),
      composite: const CompositeMoisture(score: 50.7),
      telemetry: const FieldTelemetry(
        temperatureC: 28.4,
        humidityPercent: 62,
        temperatureStatus: MetricStatus.normal,
        humidityStatus: MetricStatus.normal,
      ),
      weather: const WeatherSnapshot(
        temperatureC: 22.6,
        condition: AppStrings.partlyCloudy,
        rainChancePercent: 15,
        windKmh: 12,
        humidityPercent: 58,
      ),
      crops: crops,
      selectedCrop: crops.first,
      irrigation: _irrigation,
      lastUpdated: clock(),
      location: AppStrings.location,
    );
  }

  @override
  Future<IrrigationState> setPumpMode(PumpMode mode) async {
    _irrigation = _irrigation.copyWith(
      mode: mode,
      isPumpOn: mode.isAuto ? false : _irrigation.isPumpOn,
    );
    return _irrigation;
  }

  @override
  Future<IrrigationState> togglePump({required bool isOn}) async {
    _irrigation = _irrigation.copyWith(isPumpOn: isOn);
    return _irrigation;
  }
}
