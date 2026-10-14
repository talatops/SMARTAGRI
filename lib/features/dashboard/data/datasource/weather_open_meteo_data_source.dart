import 'package:dio/dio.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/enums.dart';
import '../../domain/entities/geo_point.dart';
import '../../domain/entities/weather_snapshot.dart';
import 'open_meteo_keys.dart';
import 'weather_data_source.dart';

class WeatherOpenMeteoDataSource implements WeatherDataSource {
  final Dio client;

  WeatherOpenMeteoDataSource({required this.client});

  @override
  Future<WeatherSnapshot> fetchCurrentWeather(GeoPoint point) async {
    final response = await client.get<Object?>(
      OpenMeteoKeys.forecastUrl,
      queryParameters: {
        OpenMeteoKeys.latitudeParam: '${point.latitude}',
        OpenMeteoKeys.longitudeParam: '${point.longitude}',
        OpenMeteoKeys.currentParam: OpenMeteoKeys.currentFields.join(','),
        OpenMeteoKeys.timezoneParam: OpenMeteoKeys.timezoneAuto,
      },
      options: Options(validateStatus: (_) => true),
    );

    final body = response.data;
    if (!_isOk(response.statusCode) || body is! Map) {
      throw Exception(response.statusMessage ?? AppStrings.weatherUnavailable);
    }

    final current = body[OpenMeteoKeys.current];
    if (current is! Map) throw Exception(AppStrings.weatherUnavailable);

    return WeatherSnapshot(
      temperatureC: _double(current[OpenMeteoKeys.temperature]),
      condition: _condition(current[OpenMeteoKeys.weatherCode]),
      isDay: current[OpenMeteoKeys.isDay] != 0,
      rainChancePercent: _double(current[OpenMeteoKeys.precipitationProbability]),
      windKmh: _double(current[OpenMeteoKeys.windSpeed]),
      humidityPercent: _double(current[OpenMeteoKeys.humidity]),
    );
  }

  bool _isOk(int? statusCode) => statusCode != null && statusCode >= 200 && statusCode <= 299;

  double _double(Object? value) => value is num ? value.toDouble() : 0;

  WeatherCondition _condition(Object? code) => switch (code) {
    0 => WeatherCondition.clearSky,
    1 => WeatherCondition.mainlyClear,
    2 => WeatherCondition.partlyCloudy,
    3 => WeatherCondition.overcast,
    45 || 48 => WeatherCondition.fog,
    51 || 53 || 55 => WeatherCondition.drizzle,
    56 || 57 => WeatherCondition.freezingDrizzle,
    61 || 63 => WeatherCondition.rain,
    65 => WeatherCondition.heavyRain,
    66 || 67 => WeatherCondition.freezingRain,
    71 || 73 => WeatherCondition.snow,
    75 => WeatherCondition.heavySnow,
    77 => WeatherCondition.snowGrains,
    80 || 81 => WeatherCondition.rainShowers,
    82 => WeatherCondition.heavyRainShowers,
    85 || 86 => WeatherCondition.snowShowers,
    95 => WeatherCondition.thunderstorm,
    96 || 99 => WeatherCondition.thunderstormHail,
    _ => WeatherCondition.unknown,
  };
}
