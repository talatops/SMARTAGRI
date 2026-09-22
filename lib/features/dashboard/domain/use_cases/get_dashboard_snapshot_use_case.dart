import '../entities/dashboard_snapshot.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardSnapshotUseCase {
  final DashboardRepository repository;

  GetDashboardSnapshotUseCase({required this.repository});

  Future<DashboardSnapshot> call() => repository.getDashboardSnapshot();
}
