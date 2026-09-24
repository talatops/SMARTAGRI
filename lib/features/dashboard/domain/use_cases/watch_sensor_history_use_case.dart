import '../entities/sensor_history.dart';
import '../repositories/sensor_history_repository.dart';

class WatchSensorHistoryUseCase {
  final SensorHistoryRepository repository;

  WatchSensorHistoryUseCase({required this.repository});

  Stream<SensorHistory> call() => repository.watchSensorHistory();
}
