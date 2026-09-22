import '../repositories/dashboard_repository.dart';

class TogglePumpUseCase {
  final DashboardRepository repository;

  TogglePumpUseCase({required this.repository});

  Future<void> call({required bool isOn}) => repository.togglePump(isOn: isOn);
}
