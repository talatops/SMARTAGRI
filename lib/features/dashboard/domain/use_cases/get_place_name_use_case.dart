import '../entities/geo_point.dart';
import '../repositories/location_repository.dart';

class GetPlaceNameUseCase {
  final LocationRepository repository;

  GetPlaceNameUseCase({required this.repository});

  Future<String> call(GeoPoint point) => repository.getPlaceName(point);
}
