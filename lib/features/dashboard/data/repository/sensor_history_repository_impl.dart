import '../../domain/entities/sensor_history.dart';
import '../../domain/repositories/sensor_history_repository.dart';
import '../datasource/sensor_history_data_source.dart';

class SensorHistoryRepositoryImpl implements SensorHistoryRepository {
  final SensorHistoryDataSource dataSource;

  SensorHistoryRepositoryImpl({required this.dataSource});

  @override
  Stream<SensorHistory> watchSensorHistory() => dataSource.watchHistory();
}
