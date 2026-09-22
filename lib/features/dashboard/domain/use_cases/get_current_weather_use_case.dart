import '../entities/weather_snapshot.dart';
import '../repositories/weather_repository.dart';

class GetCurrentWeatherUseCase {
  final WeatherRepository repository;

  GetCurrentWeatherUseCase({required this.repository});

  Future<WeatherSnapshot> call() => repository.getCurrentWeather();
}
