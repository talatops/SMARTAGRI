import '../../domain/entities/weather_snapshot.dart';

abstract class WeatherDataSource {
  Future<WeatherSnapshot> fetchCurrentWeather();
}
