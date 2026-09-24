import '../entities/sensor_history.dart';

abstract class SensorHistoryRepository {
  Stream<SensorHistory> watchSensorHistory();
}
