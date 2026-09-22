import '../../../../core/utils/enums.dart';
import '../repositories/dashboard_repository.dart';

class SetPumpModeUseCase {
  final DashboardRepository repository;

  SetPumpModeUseCase({required this.repository});

  Future<void> call(PumpMode mode) => repository.setPumpMode(mode);
}
