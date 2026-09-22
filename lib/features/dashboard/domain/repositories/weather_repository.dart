import '../entities/weather_snapshot.dart';

abstract class WeatherRepository {
  Future<WeatherSnapshot> getCurrentWeather();
}
