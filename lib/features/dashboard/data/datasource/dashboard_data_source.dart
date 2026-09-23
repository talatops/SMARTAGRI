import '../../../../core/utils/enums.dart';
import '../../domain/entities/dashboard_snapshot.dart';
import '../../domain/entities/weather_snapshot.dart';

abstract class DashboardDataSource {
  Future<DashboardSnapshot> fetchSnapshot();

  Stream<DashboardSnapshot> watchSnapshot();

  Future<void> setPumpMode(PumpMode mode);

  Future<void> togglePump({required bool isOn});

  Future<void> selectCrop(CropType crop);

  Future<void> saveWeather(WeatherSnapshot weather);
}
