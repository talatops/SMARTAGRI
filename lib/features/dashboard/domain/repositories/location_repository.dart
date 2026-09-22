import '../entities/geo_point.dart';

abstract class LocationRepository {
  Future<GeoPoint> getDeviceLocation();

  Future<String> getPlaceName(GeoPoint point);
}
