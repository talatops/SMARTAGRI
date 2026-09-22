import '../entities/geo_point.dart';
import '../repositories/location_repository.dart';

class GetDeviceLocationUseCase {
  final LocationRepository repository;

  GetDeviceLocationUseCase({required this.repository});

  Future<GeoPoint> call() => repository.getDeviceLocation();
}
