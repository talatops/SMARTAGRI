import '../entities/dashboard_snapshot.dart';
import '../repositories/dashboard_repository.dart';

class WatchDashboardSnapshotUseCase {
  final DashboardRepository repository;

  WatchDashboardSnapshotUseCase({required this.repository});

  Stream<DashboardSnapshot> call() => repository.watchDashboardSnapshot();
}
