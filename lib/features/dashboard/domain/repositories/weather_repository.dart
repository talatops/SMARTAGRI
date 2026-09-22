import '../entities/geo_point.dart';
import '../entities/weather_snapshot.dart';

abstract class WeatherRepository {
  Future<WeatherSnapshot> getCurrentWeather(GeoPoint point);
}
