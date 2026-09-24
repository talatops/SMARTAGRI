import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

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
import '../controller/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardDataSource>(
      () => DashboardFirebaseDataSource(
        database: FirebaseDatabase.instance,
        fallback: DashboardMockDataSource(),
      ),
    );
    Get.lazyPut<SensorHistoryDataSource>(
      () => SensorHistoryFirebaseDataSource(database: FirebaseDatabase.instance),
    );
    Get.lazyPut<WeatherDataSource>(
      () => WeatherOpenMeteoDataSource(client: GetConnect(timeout: AppDurations.requestTimeout)),
    );
    Get.lazyPut<DeviceLocationDataSource>(DeviceLocationGeolocatorDataSource.new);
    Get.lazyPut<PlaceNameDataSource>(
      () => PlaceNameNominatimDataSource(client: GetConnect(timeout: AppDurations.requestTimeout)),
    );
    Get.lazyPut<DashboardRepository>(() => DashboardRepositoryImpl(dataSource: Get.find()));
    Get.lazyPut<SensorHistoryRepository>(
      () => SensorHistoryRepositoryImpl(dataSource: Get.find()),
    );
    Get.lazyPut<WeatherRepository>(() => WeatherRepositoryImpl(dataSource: Get.find()));
    Get.lazyPut<LocationRepository>(
      () => LocationRepositoryImpl(deviceDataSource: Get.find(), placeNameDataSource: Get.find()),
    );
    Get.lazyPut(() => GetCurrentWeatherUseCase(repository: Get.find()));
    Get.lazyPut(() => GetDeviceLocationUseCase(repository: Get.find()));
    Get.lazyPut(() => GetPlaceNameUseCase(repository: Get.find()));
    Get.lazyPut(() => OpenLocationSettingsUseCase(repository: Get.find()));
    Get.lazyPut(() => GetDashboardSnapshotUseCase(repository: Get.find()));
    Get.lazyPut(() => WatchDashboardSnapshotUseCase(repository: Get.find()));
    Get.lazyPut(() => WatchSensorHistoryUseCase(repository: Get.find()));
    Get.lazyPut(() => SetPumpModeUseCase(repository: Get.find()));
    Get.lazyPut(() => TogglePumpUseCase(repository: Get.find()));
    Get.lazyPut(() => SelectCropUseCase(repository: Get.find()));
    Get.lazyPut(() => SaveWeatherUseCase(repository: Get.find()));
    Get.lazyPut(
      () => DashboardController(
        getDashboardSnapshotUseCase: Get.find(),
        watchDashboardSnapshotUseCase: Get.find(),
        watchSensorHistoryUseCase: Get.find(),
        setPumpModeUseCase: Get.find(),
        togglePumpUseCase: Get.find(),
        selectCropUseCase: Get.find(),
        getCurrentWeatherUseCase: Get.find(),
        getDeviceLocationUseCase: Get.find(),
        getPlaceNameUseCase: Get.find(),
        openLocationSettingsUseCase: Get.find(),
        saveWeatherUseCase: Get.find(),
      ),
    );
  }
}
