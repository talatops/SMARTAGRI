import '../../../../core/utils/enums.dart';
import '../repositories/dashboard_repository.dart';

class SelectCropUseCase {
  final DashboardRepository repository;

  SelectCropUseCase({required this.repository});

  Future<void> call(CropType crop) => repository.selectCrop(crop);
}
