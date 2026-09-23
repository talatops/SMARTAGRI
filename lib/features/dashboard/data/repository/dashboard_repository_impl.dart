import '../../../../core/utils/enums.dart';
import '../../domain/entities/dashboard_snapshot.dart';
import '../../domain/entities/weather_snapshot.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasource/dashboard_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardDataSource dataSource;

  DashboardRepositoryImpl({required this.dataSource});

  @override
  Future<DashboardSnapshot> getDashboardSnapshot() => dataSource.fetchSnapshot();

  @override
  Stream<DashboardSnapshot> watchDashboardSnapshot() => dataSource.watchSnapshot();

  @override
  Future<void> setPumpMode(PumpMode mode) => dataSource.setPumpMode(mode);

  @override
  Future<void> togglePump({required bool isOn}) => dataSource.togglePump(isOn: isOn);

  @override
  Future<void> selectCrop(CropType crop) => dataSource.selectCrop(crop);

  @override
  Future<void> saveWeather(WeatherSnapshot weather) => dataSource.saveWeather(weather);
}
