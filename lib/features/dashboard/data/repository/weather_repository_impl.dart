import '../../domain/entities/geo_point.dart';
import '../../domain/entities/weather_snapshot.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasource/weather_data_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherDataSource dataSource;

  WeatherRepositoryImpl({required this.dataSource});

  @override
  Future<WeatherSnapshot> getCurrentWeather(GeoPoint point) => dataSource.fetchCurrentWeather(point);
}
