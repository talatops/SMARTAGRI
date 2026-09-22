import '../../domain/entities/geo_point.dart';

abstract final class FieldLocation {
  static const fallback = GeoPoint(latitude: 33.664388, longitude: 73.070117);
}
