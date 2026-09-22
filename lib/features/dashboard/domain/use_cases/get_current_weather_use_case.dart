import '../entities/geo_point.dart';
import '../entities/weather_snapshot.dart';
import '../repositories/weather_repository.dart';

class GetCurrentWeatherUseCase {
  final WeatherRepository repository;

  GetCurrentWeatherUseCase({required this.repository});

  Future<WeatherSnapshot> call(GeoPoint point) => repository.getCurrentWeather(point);
}
