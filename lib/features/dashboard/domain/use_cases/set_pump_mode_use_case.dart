import '../../../../core/utils/enums.dart';
import '../entities/irrigation_state.dart';
import '../repositories/dashboard_repository.dart';

class SetPumpModeUseCase {
  final DashboardRepository repository;

  SetPumpModeUseCase({required this.repository});

  Future<IrrigationState> call(PumpMode mode) => repository.setPumpMode(mode);
}
