import '../../../../core/utils/enums.dart';
import '../../domain/entities/geo_point.dart';

abstract class DeviceLocationDataSource {
  Future<GeoPoint> fetchDeviceLocation();

  Future<bool> openSettings(LocationIssue issue);
}

abstract class PlaceNameDataSource {
  Future<String> fetchPlaceName(GeoPoint point);
}
