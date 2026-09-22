import '../../../../core/utils/enums.dart';
import '../../domain/entities/dashboard_snapshot.dart';
import '../../domain/entities/irrigation_state.dart';

abstract class DashboardDataSource {
  Future<DashboardSnapshot> fetchSnapshot();

  Future<IrrigationState> setPumpMode(PumpMode mode);

  Future<IrrigationState> togglePump({required bool isOn});
}
