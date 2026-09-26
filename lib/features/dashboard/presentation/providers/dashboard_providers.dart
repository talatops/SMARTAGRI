import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/app_durations.dart';
import '../../data/datasource/dashboard_data_source.dart';
import '../../data/datasource/dashboard_firebase_data_source.dart';
import '../../data/datasource/dashboard_mock_data_source.dart';
import '../../data/datasource/device_location_geolocator_data_source.dart';
import '../../data/datasource/location_data_source.dart';
import '../../data/datasource/place_name_nominatim_data_source.dart';
import '../../data/datasource/sensor_history_data_source.dart';
import '../../data/datasource/sensor_history_firebase_data_source.dart';
import '../../data/datasource/weather_data_source.dart';
import '../../data/datasource/weather_open_meteo_data_source.dart';
import '../../data/repository/dashboard_repository_impl.dart';
import '../../data/repository/location_repository_impl.dart';
import '../../data/repository/sensor_history_repository_impl.dart';
import '../../data/repository/weather_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/repositories/sensor_history_repository.dart';
import '../../domain/repositories/weather_repository.dart';
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

part 'dashboard_providers.g.dart';

@Riverpod(keepAlive: true)
DateTime Function() clock(Ref ref) => DateTime.now;

@Riverpod(keepAlive: true)
DashboardDataSource dashboardDataSource(Ref ref) => DashboardFirebaseDataSource(
  database: FirebaseDatabase.instance,
  fallback: DashboardMockDataSource(),
);

@Riverpod(keepAlive: true)
SensorHistoryDataSource sensorHistoryDataSource(Ref ref) =>
    SensorHistoryFirebaseDataSource(database: FirebaseDatabase.instance);

@Riverpod(keepAlive: true)
WeatherDataSource weatherDataSource(Ref ref) => WeatherOpenMeteoDataSource(
  client: Dio(BaseOptions(connectTimeout: AppDurations.requestTimeout)),
);

@Riverpod(keepAlive: true)
DeviceLocationDataSource deviceLocationDataSource(Ref ref) => DeviceLocationGeolocatorDataSource();

@Riverpod(keepAlive: true)
PlaceNameDataSource placeNameDataSource(Ref ref) => PlaceNameNominatimDataSource(
  client: Dio(BaseOptions(connectTimeout: AppDurations.requestTimeout)),
);

@Riverpod(keepAlive: true)
DashboardRepository dashboardRepository(Ref ref) =>
    DashboardRepositoryImpl(dataSource: ref.watch(dashboardDataSourceProvider));

@Riverpod(keepAlive: true)
SensorHistoryRepository sensorHistoryRepository(Ref ref) =>
    SensorHistoryRepositoryImpl(dataSource: ref.watch(sensorHistoryDataSourceProvider));

@Riverpod(keepAlive: true)
WeatherRepository weatherRepository(Ref ref) =>
    WeatherRepositoryImpl(dataSource: ref.watch(weatherDataSourceProvider));

@Riverpod(keepAlive: true)
LocationRepository locationRepository(Ref ref) => LocationRepositoryImpl(
  deviceDataSource: ref.watch(deviceLocationDataSourceProvider),
  placeNameDataSource: ref.watch(placeNameDataSourceProvider),
);

@Riverpod(keepAlive: true)
GetCurrentWeatherUseCase getCurrentWeatherUseCase(Ref ref) =>
    GetCurrentWeatherUseCase(repository: ref.watch(weatherRepositoryProvider));

@Riverpod(keepAlive: true)
GetDeviceLocationUseCase getDeviceLocationUseCase(Ref ref) =>
    GetDeviceLocationUseCase(repository: ref.watch(locationRepositoryProvider));

@Riverpod(keepAlive: true)
GetPlaceNameUseCase getPlaceNameUseCase(Ref ref) =>
    GetPlaceNameUseCase(repository: ref.watch(locationRepositoryProvider));

@Riverpod(keepAlive: true)
OpenLocationSettingsUseCase openLocationSettingsUseCase(Ref ref) =>
    OpenLocationSettingsUseCase(repository: ref.watch(locationRepositoryProvider));

@Riverpod(keepAlive: true)
GetDashboardSnapshotUseCase getDashboardSnapshotUseCase(Ref ref) =>
    GetDashboardSnapshotUseCase(repository: ref.watch(dashboardRepositoryProvider));

@Riverpod(keepAlive: true)
WatchDashboardSnapshotUseCase watchDashboardSnapshotUseCase(Ref ref) =>
    WatchDashboardSnapshotUseCase(repository: ref.watch(dashboardRepositoryProvider));

@Riverpod(keepAlive: true)
WatchSensorHistoryUseCase watchSensorHistoryUseCase(Ref ref) =>
    WatchSensorHistoryUseCase(repository: ref.watch(sensorHistoryRepositoryProvider));

@Riverpod(keepAlive: true)
SetPumpModeUseCase setPumpModeUseCase(Ref ref) =>
    SetPumpModeUseCase(repository: ref.watch(dashboardRepositoryProvider));

@Riverpod(keepAlive: true)
TogglePumpUseCase togglePumpUseCase(Ref ref) =>
    TogglePumpUseCase(repository: ref.watch(dashboardRepositoryProvider));

@Riverpod(keepAlive: true)
SelectCropUseCase selectCropUseCase(Ref ref) =>
    SelectCropUseCase(repository: ref.watch(dashboardRepositoryProvider));

@Riverpod(keepAlive: true)
SaveWeatherUseCase saveWeatherUseCase(Ref ref) =>
    SaveWeatherUseCase(repository: ref.watch(dashboardRepositoryProvider));
