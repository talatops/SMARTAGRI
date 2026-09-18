import 'control_model.dart';
import 'sensor_model.dart';
import 'weather_model.dart';

class DashboardModel {
  final ControlModel control;
  final SensorModel sensors;
  final WeatherModel weather;

  const DashboardModel({
    required this.control,
    required this.sensors,
    required this.weather,
  });

  factory DashboardModel.fromMap(Map<dynamic, dynamic> map) {
    return DashboardModel(
      control: ControlModel.fromMap(
        Map<dynamic, dynamic>.from(map['control'] ?? {}),
      ),
      sensors: SensorModel.fromMap(
        Map<dynamic, dynamic>.from(map['sensors'] ?? {}),
      ),
      weather: WeatherModel.fromMap(
        Map<dynamic, dynamic>.from(map['weather'] ?? {}),
      ),
    );
  }
}