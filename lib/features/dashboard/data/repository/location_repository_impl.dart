import '../../../../core/utils/enums.dart';
import '../../domain/entities/geo_point.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasource/location_data_source.dart';

class LocationRepositoryImpl implements LocationRepository {
  final DeviceLocationDataSource deviceDataSource;
  final PlaceNameDataSource placeNameDataSource;

  LocationRepositoryImpl({required this.deviceDataSource, required this.placeNameDataSource});

  @override
  Future<GeoPoint> getDeviceLocation() => deviceDataSource.fetchDeviceLocation();

  @override
  Future<String> getPlaceName(GeoPoint point) => placeNameDataSource.fetchPlaceName(point);

  @override
  Future<bool> openSettings(LocationIssue issue) => deviceDataSource.openSettings(issue);
}
