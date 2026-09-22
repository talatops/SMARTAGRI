import '../entities/dashboard_snapshot.dart';
import '../entities/irrigation_state.dart';
import '../../../../core/utils/enums.dart';

abstract class DashboardRepository {
  Future<DashboardSnapshot> getDashboardSnapshot();

  Future<IrrigationState> setPumpMode(PumpMode mode);

  Future<IrrigationState> togglePump({required bool isOn});
}
