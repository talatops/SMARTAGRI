import 'package:get/get.dart';

import '../../../../core/utils/app_strings.dart';
import '../../domain/entities/geo_point.dart';
import '../../domain/entities/weather_snapshot.dart';
import 'open_meteo_keys.dart';
import 'weather_data_source.dart';

class WeatherOpenMeteoDataSource implements WeatherDataSource {
  final GetConnect client;

  WeatherOpenMeteoDataSource({required this.client});

  @override
  Future<WeatherSnapshot> fetchCurrentWeather(GeoPoint point) async {
    final response = await client.get<Object?>(
      OpenMeteoKeys.forecastUrl,
      query: {
        OpenMeteoKeys.latitudeParam: '${point.latitude}',
        OpenMeteoKeys.longitudeParam: '${point.longitude}',
        OpenMeteoKeys.currentParam: OpenMeteoKeys.currentFields.join(','),
        OpenMeteoKeys.timezoneParam: OpenMeteoKeys.timezoneAuto,
      },
    );

    final body = response.body;
    if (!response.isOk || body is! Map) {
      throw Exception(response.statusText ?? AppStrings.weatherUnavailable);
    }

    final current = body[OpenMeteoKeys.current];
    if (current is! Map) throw Exception(AppStrings.weatherUnavailable);

    return WeatherSnapshot(
      temperatureC: _double(current[OpenMeteoKeys.temperature]),
      condition: _condition(current[OpenMeteoKeys.weatherCode]),
      rainChancePercent: _double(current[OpenMeteoKeys.precipitationProbability]),
      windKmh: _double(current[OpenMeteoKeys.windSpeed]),
      humidityPercent: _double(current[OpenMeteoKeys.humidity]),
    );
  }

  double _double(Object? value) => value is num ? value.toDouble() : 0;

  String _condition(Object? code) => switch (code) {
    0 => AppStrings.clearSky,
    1 => AppStrings.mainlyClear,
    2 => AppStrings.partlyCloudy,
    3 => AppStrings.overcast,
    45 || 48 => AppStrings.fog,
    51 || 53 || 55 || 56 || 57 => AppStrings.drizzle,
    61 || 63 || 65 || 66 || 67 => AppStrings.raining,
    71 || 73 || 75 || 77 => AppStrings.snow,
    80 || 81 || 82 => AppStrings.rainShowers,
    85 || 86 => AppStrings.snowShowers,
    95 || 96 || 99 => AppStrings.thunderstorm,
    _ => AppStrings.unknownCondition,
  };
}
