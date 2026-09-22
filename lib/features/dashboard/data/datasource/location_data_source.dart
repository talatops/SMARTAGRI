import '../../domain/entities/geo_point.dart';

abstract class DeviceLocationDataSource {
  Future<GeoPoint> fetchDeviceLocation();
}

abstract class PlaceNameDataSource {
  Future<String> fetchPlaceName(GeoPoint point);
}
