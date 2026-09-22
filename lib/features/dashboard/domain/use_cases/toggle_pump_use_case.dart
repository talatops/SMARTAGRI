import '../entities/irrigation_state.dart';
import '../repositories/dashboard_repository.dart';

class TogglePumpUseCase {
  final DashboardRepository repository;

  TogglePumpUseCase({required this.repository});

  Future<IrrigationState> call({required bool isOn}) => repository.togglePump(isOn: isOn);
}
