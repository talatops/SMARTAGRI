import '../entities/weather_snapshot.dart';
import '../repositories/dashboard_repository.dart';

class SaveWeatherUseCase {
  final DashboardRepository repository;

  SaveWeatherUseCase({required this.repository});

  Future<void> call(WeatherSnapshot weather) => repository.saveWeather(weather);
}
