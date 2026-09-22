import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../../data/datasource/dashboard_data_source.dart';
import '../../data/datasource/dashboard_firebase_data_source.dart';
import '../../data/datasource/dashboard_mock_data_source.dart';
import '../../data/datasource/weather_data_source.dart';
import '../../data/datasource/weather_open_meteo_data_source.dart';
import '../../data/repository/dashboard_repository_impl.dart';
import '../../data/repository/weather_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../domain/use_cases/get_current_weather_use_case.dart';
import '../../domain/use_cases/get_dashboard_snapshot_use_case.dart';
import '../../domain/use_cases/select_crop_use_case.dart';
import '../../domain/use_cases/set_pump_mode_use_case.dart';
import '../../domain/use_cases/toggle_pump_use_case.dart';
import '../../domain/use_cases/watch_dashboard_snapshot_use_case.dart';
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
    Get.lazyPut<WeatherDataSource>(() => WeatherOpenMeteoDataSource(client: GetConnect()));
    Get.lazyPut<DashboardRepository>(() => DashboardRepositoryImpl(dataSource: Get.find()));
    Get.lazyPut<WeatherRepository>(() => WeatherRepositoryImpl(dataSource: Get.find()));
    Get.lazyPut(() => GetCurrentWeatherUseCase(repository: Get.find()));
    Get.lazyPut(() => GetDashboardSnapshotUseCase(repository: Get.find()));
    Get.lazyPut(() => WatchDashboardSnapshotUseCase(repository: Get.find()));
    Get.lazyPut(() => SetPumpModeUseCase(repository: Get.find()));
    Get.lazyPut(() => TogglePumpUseCase(repository: Get.find()));
    Get.lazyPut(() => SelectCropUseCase(repository: Get.find()));
    Get.lazyPut(
      () => DashboardController(
        getDashboardSnapshotUseCase: Get.find(),
        watchDashboardSnapshotUseCase: Get.find(),
        setPumpModeUseCase: Get.find(),
        togglePumpUseCase: Get.find(),
        selectCropUseCase: Get.find(),
        getCurrentWeatherUseCase: Get.find(),
      ),
    );
  }
}
