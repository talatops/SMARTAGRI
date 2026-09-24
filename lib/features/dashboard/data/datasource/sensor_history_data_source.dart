import '../../domain/entities/sensor_history.dart';

abstract class SensorHistoryDataSource {
  Stream<SensorHistory> watchHistory();
}
