import '../../../../core/utils/enums.dart';
import '../repositories/location_repository.dart';

class OpenLocationSettingsUseCase {
  final LocationRepository repository;

  OpenLocationSettingsUseCase({required this.repository});

  Future<bool> call(LocationIssue issue) => repository.openSettings(issue);
}
