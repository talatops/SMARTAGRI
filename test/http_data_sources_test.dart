import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_agri_system/core/utils/app_strings.dart';
import 'package:smart_agri_system/core/utils/enums.dart';
import 'package:smart_agri_system/features/dashboard/data/datasource/place_name_nominatim_data_source.dart';
import 'package:smart_agri_system/features/dashboard/data/datasource/weather_open_meteo_data_source.dart';

import 'support/fakes.dart';

class FakeAdapter implements HttpClientAdapter {
  int statusCode = 200;
  Object? body;
  String contentType = Headers.jsonContentType;
  Object? error;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final failure = error;
    if (failure != null) throw failure;
    final text = body is String ? body! as String : jsonEncode(body);
    return ResponseBody.fromString(
      text,
      statusCode,
      headers: {
        Headers.contentTypeHeader: [contentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio dioWith(FakeAdapter adapter) => Dio()..httpClientAdapter = adapter;

void main() {
  group('WeatherOpenMeteoDataSource', () {
    late FakeAdapter adapter;
    late WeatherOpenMeteoDataSource source;

    setUp(() {
      adapter = FakeAdapter();
      source = WeatherOpenMeteoDataSource(client: dioWith(adapter));
    });

    test('requests current weather for the point', () async {
      adapter.body = {
        'current': {
          'temperature_2m': 22.6,
          'relative_humidity_2m': 58,
          'weather_code': 2,
          'wind_speed_10m': 12,
          'precipitation_probability': 15,
          'is_day': 1,
        },
      };

      final weather = await source.fetchCurrentWeather(samplePoint);

      final request = adapter.requests.single;
      expect(request.method, 'GET');
      expect(request.uri.origin + request.uri.path, 'https://api.open-meteo.com/v1/forecast');
      expect(request.uri.queryParameters, {
        'latitude': '${samplePoint.latitude}',
        'longitude': '${samplePoint.longitude}',
        'current':
            'temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m,precipitation_probability,is_day',
        'timezone': 'auto',
      });

      expect(weather.temperatureC, 22.6);
      expect(weather.humidityPercent, 58);
      expect(weather.condition, WeatherCondition.partlyCloudy);
      expect(weather.windKmh, 12);
      expect(weather.rainChancePercent, 15);
      expect(weather.isDay, isTrue);
    });

    test('maps missing values and night', () async {
      adapter.body = {
        'current': {'is_day': 0, 'weather_code': 999},
      };
      final weather = await source.fetchCurrentWeather(samplePoint);
      expect(weather.temperatureC, 0);
      expect(weather.humidityPercent, 0);
      expect(weather.windKmh, 0);
      expect(weather.rainChancePercent, 0);
      expect(weather.isDay, isFalse);
      expect(weather.condition, WeatherCondition.unknown);
    });

    test('maps every documented weather code', () async {
      const codes = {
        0: WeatherCondition.clearSky,
        1: WeatherCondition.mainlyClear,
        2: WeatherCondition.partlyCloudy,
        3: WeatherCondition.overcast,
        45: WeatherCondition.fog,
        48: WeatherCondition.fog,
        51: WeatherCondition.drizzle,
        55: WeatherCondition.drizzle,
        56: WeatherCondition.freezingDrizzle,
        61: WeatherCondition.rain,
        63: WeatherCondition.rain,
        65: WeatherCondition.heavyRain,
        66: WeatherCondition.freezingRain,
        71: WeatherCondition.snow,
        75: WeatherCondition.heavySnow,
        77: WeatherCondition.snowGrains,
        80: WeatherCondition.rainShowers,
        82: WeatherCondition.heavyRainShowers,
        85: WeatherCondition.snowShowers,
        95: WeatherCondition.thunderstorm,
        99: WeatherCondition.thunderstormHail,
      };
      for (final entry in codes.entries) {
        adapter.body = {
          'current': {'weather_code': entry.key, 'is_day': 1},
        };
        final weather = await source.fetchCurrentWeather(samplePoint);
        expect(weather.condition, entry.value, reason: 'code ${entry.key}');
      }
    });

    test('throws on a non-success status', () async {
      adapter.statusCode = 500;
      adapter.body = {'error': true};
      await expectLater(source.fetchCurrentWeather(samplePoint), throwsException);
    });

    test('throws when the body is not an object', () async {
      adapter.body = [1, 2];
      await expectLater(source.fetchCurrentWeather(samplePoint), throwsException);
    });

    test('throws when current is missing', () async {
      adapter.body = {'hourly': {}};
      await expectLater(source.fetchCurrentWeather(samplePoint), throwsException);
    });

    test('throws on a network failure', () async {
      adapter.error = Exception('offline');
      await expectLater(source.fetchCurrentWeather(samplePoint), throwsException);
    });
  });

  group('PlaceNameNominatimDataSource', () {
    late FakeAdapter adapter;
    late PlaceNameNominatimDataSource source;

    setUp(() {
      adapter = FakeAdapter();
      source = PlaceNameNominatimDataSource(client: dioWith(adapter));
    });

    test('requests the reverse lookup with the app user agent', () async {
      adapter.body = {
        'address': {'city': 'Islamabad', 'country_code': 'pk'},
      };

      final name = await source.fetchPlaceName(samplePoint);

      final request = adapter.requests.single;
      expect(request.method, 'GET');
      expect(
        request.uri.origin + request.uri.path,
        'https://nominatim.openstreetmap.org/reverse',
      );
      expect(request.uri.queryParameters, {
        'lat': '${samplePoint.latitude}',
        'lon': '${samplePoint.longitude}',
        'format': 'json',
        'zoom': '10',
        'accept-language': 'en',
      });
      expect(request.headers['User-Agent'], AppStrings.appName);
      expect(name, 'Islamabad, PK');
    });

    test('falls back through town, village, county and state', () async {
      for (final key in ['town', 'village', 'county', 'state']) {
        adapter.body = {
          'address': {key: 'Place $key', 'city': ''},
        };
        expect(await source.fetchPlaceName(samplePoint), 'Place $key');
      }
    });

    test('prefers city over later keys', () async {
      adapter.body = {
        'address': {'state': 'Punjab', 'city': 'Lahore', 'country_code': 'pk'},
      };
      expect(await source.fetchPlaceName(samplePoint), 'Lahore, PK');
    });

    test('throws when no place key is present', () async {
      adapter.body = {
        'address': {'country_code': 'pk'},
      };
      await expectLater(source.fetchPlaceName(samplePoint), throwsException);
    });

    test('throws when address is missing', () async {
      adapter.body = {'error': 'Unable to geocode'};
      await expectLater(source.fetchPlaceName(samplePoint), throwsException);
    });

    test('throws on a non-success status', () async {
      adapter.statusCode = 403;
      adapter.body = {
        'address': {'city': 'Islamabad'},
      };
      await expectLater(source.fetchPlaceName(samplePoint), throwsException);
    });

    test('throws on a network failure', () async {
      adapter.error = Exception('offline');
      await expectLater(source.fetchPlaceName(samplePoint), throwsException);
    });
  });
}
