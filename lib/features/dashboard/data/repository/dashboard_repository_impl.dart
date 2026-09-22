import '../../../../core/utils/enums.dart';
import '../../domain/entities/dashboard_snapshot.dart';
import '../../domain/entities/irrigation_state.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasource/dashboard_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardDataSource dataSource;

  DashboardRepositoryImpl({required this.dataSource});

  @override
  Future<DashboardSnapshot> getDashboardSnapshot() => dataSource.fetchSnapshot();

  @override
  Future<IrrigationState> setPumpMode(PumpMode mode) => dataSource.setPumpMode(mode);

  @override
  Future<IrrigationState> togglePump({required bool isOn}) => dataSource.togglePump(isOn: isOn);
}
