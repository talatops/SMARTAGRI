import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final dashboardDataSourceProvider = Provider<DashboardDataSource>(
  (ref) => DashboardFirebaseDataSource(
    database: FirebaseDatabase.instance,
    fallback: DashboardMockDataSource(),
  ),
);

final sensorHistoryDataSourceProvider = Provider<SensorHistoryDataSource>(
  (ref) => SensorHistoryFirebaseDataSource(database: FirebaseDatabase.instance),
);

final weatherDataSourceProvider = Provider<WeatherDataSource>(
  (ref) => WeatherOpenMeteoDataSource(
    client: Dio(BaseOptions(connectTimeout: AppDurations.requestTimeout)),
  ),
);

final deviceLocationDataSourceProvider = Provider<DeviceLocationDataSource>(
  (ref) => DeviceLocationGeolocatorDataSource(),
);

final placeNameDataSourceProvider = Provider<PlaceNameDataSource>(
  (ref) => PlaceNameNominatimDataSource(
    client: Dio(BaseOptions(connectTimeout: AppDurations.requestTimeout)),
  ),
);

final dashboardRepositoryProvider = Provider<DashboardRepository>(
  (ref) => DashboardRepositoryImpl(dataSource: ref.watch(dashboardDataSourceProvider)),
);

final sensorHistoryRepositoryProvider = Provider<SensorHistoryRepository>(
  (ref) => SensorHistoryRepositoryImpl(dataSource: ref.watch(sensorHistoryDataSourceProvider)),
);

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => WeatherRepositoryImpl(dataSource: ref.watch(weatherDataSourceProvider)),
);

final locationRepositoryProvider = Provider<LocationRepository>(
  (ref) => LocationRepositoryImpl(
    deviceDataSource: ref.watch(deviceLocationDataSourceProvider),
    placeNameDataSource: ref.watch(placeNameDataSourceProvider),
  ),
);

final getCurrentWeatherUseCaseProvider = Provider(
  (ref) => GetCurrentWeatherUseCase(repository: ref.watch(weatherRepositoryProvider)),
);

final getDeviceLocationUseCaseProvider = Provider(
  (ref) => GetDeviceLocationUseCase(repository: ref.watch(locationRepositoryProvider)),
);

final getPlaceNameUseCaseProvider = Provider(
  (ref) => GetPlaceNameUseCase(repository: ref.watch(locationRepositoryProvider)),
);

final openLocationSettingsUseCaseProvider = Provider(
  (ref) => OpenLocationSettingsUseCase(repository: ref.watch(locationRepositoryProvider)),
);

final getDashboardSnapshotUseCaseProvider = Provider(
  (ref) => GetDashboardSnapshotUseCase(repository: ref.watch(dashboardRepositoryProvider)),
);

final watchDashboardSnapshotUseCaseProvider = Provider(
  (ref) => WatchDashboardSnapshotUseCase(repository: ref.watch(dashboardRepositoryProvider)),
);

final watchSensorHistoryUseCaseProvider = Provider(
  (ref) => WatchSensorHistoryUseCase(repository: ref.watch(sensorHistoryRepositoryProvider)),
);

final setPumpModeUseCaseProvider = Provider(
  (ref) => SetPumpModeUseCase(repository: ref.watch(dashboardRepositoryProvider)),
);

final togglePumpUseCaseProvider = Provider(
  (ref) => TogglePumpUseCase(repository: ref.watch(dashboardRepositoryProvider)),
);

final selectCropUseCaseProvider = Provider(
  (ref) => SelectCropUseCase(repository: ref.watch(dashboardRepositoryProvider)),
);

final saveWeatherUseCaseProvider = Provider(
  (ref) => SaveWeatherUseCase(repository: ref.watch(dashboardRepositoryProvider)),
);
