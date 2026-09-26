import 'package:dio/dio.dart';

import '../../../../core/utils/app_strings.dart';
import '../../domain/entities/geo_point.dart';
import 'location_data_source.dart';
import 'nominatim_keys.dart';

class PlaceNameNominatimDataSource implements PlaceNameDataSource {
  final Dio client;

  PlaceNameNominatimDataSource({required this.client});

  @override
  Future<String> fetchPlaceName(GeoPoint point) async {
    final response = await client.get<Object?>(
      NominatimKeys.reverseUrl,
      queryParameters: {
        NominatimKeys.latitudeParam: '${point.latitude}',
        NominatimKeys.longitudeParam: '${point.longitude}',
        NominatimKeys.formatParam: NominatimKeys.formatJson,
        NominatimKeys.zoomParam: NominatimKeys.zoomCity,
        NominatimKeys.languageParam: NominatimKeys.languageEnglish,
      },
      options: Options(
        headers: {NominatimKeys.userAgentHeader: AppStrings.appName},
        validateStatus: (_) => true,
      ),
    );

    final body = response.data;
    if (!_isOk(response.statusCode) || body is! Map) {
      throw Exception(response.statusMessage ?? AppStrings.locationUnavailable);
    }

    final address = body[NominatimKeys.address];
    if (address is! Map) throw Exception(AppStrings.locationUnavailable);

    final city = _first(address, const [
      NominatimKeys.city,
      NominatimKeys.town,
      NominatimKeys.village,
      NominatimKeys.county,
      NominatimKeys.state,
    ]);
    final country = _first(address, const [NominatimKeys.countryCode]);
    if (city == null) throw Exception(AppStrings.locationUnavailable);
    if (country == null) return city;

    return '$city${AppStrings.locationSeparator}${country.toUpperCase()}';
  }

  bool _isOk(int? statusCode) => statusCode != null && statusCode >= 200 && statusCode <= 299;

  String? _first(Map<Object?, Object?> address, List<String> keys) {
    for (final key in keys) {
      final value = address[key];
      if (value is String && value.isNotEmpty) return value;
    }
    return null;
  }
}
