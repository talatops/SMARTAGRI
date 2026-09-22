import '../../domain/entities/geo_point.dart';
import '../../domain/entities/weather_snapshot.dart';

abstract class WeatherDataSource {
  Future<WeatherSnapshot> fetchCurrentWeather(GeoPoint point);
}
