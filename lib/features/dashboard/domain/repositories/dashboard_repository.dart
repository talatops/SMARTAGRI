import '../entities/dashboard_snapshot.dart';
import '../entities/weather_snapshot.dart';
import '../../../../core/utils/enums.dart';

abstract class DashboardRepository {
  Future<DashboardSnapshot> getDashboardSnapshot();

  Stream<DashboardSnapshot> watchDashboardSnapshot();

  Future<void> setPumpMode(PumpMode mode);

  Future<void> togglePump({required bool isOn});

  Future<void> selectCrop(CropType crop);

  Future<void> saveWeather(WeatherSnapshot weather);
}
