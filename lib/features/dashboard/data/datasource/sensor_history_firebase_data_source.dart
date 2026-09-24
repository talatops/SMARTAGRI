import 'package:firebase_database/firebase_database.dart';

import '../../../../core/utils/enums.dart';
import '../../domain/entities/sensor_history.dart';
import 'dashboard_firebase_keys.dart';
import 'sensor_history_data_source.dart';

class SensorHistoryFirebaseDataSource implements SensorHistoryDataSource {
  final FirebaseDatabase database;

  SensorHistoryFirebaseDataSource({required this.database});

  DatabaseReference get _graphs =>
      database.ref(DashboardFirebaseKeys.devicePath).child(DashboardFirebaseKeys.graphs);

  @override
  Stream<SensorHistory> watchHistory() =>
      _graphs.onValue.map((event) => _parse(event.snapshot.value));

  SensorHistory _parse(Object? value) {
    final graphs = _map(value);
    return SensorHistory(
      readings: {
        for (final series in HistorySeries.values) series: _valuesOf(graphs, series),
      },
    );
  }

  List<double> _valuesOf(Map<Object?, Object?> graphs, HistorySeries series) {
    final (graph, key) = _pathOf(series);
    final values = _map(graphs[graph])[key];
    if (values is! List<Object?>) return const [];
    return values.map(_double).nonNulls.toList();
  }

  (String, String) _pathOf(HistorySeries series) => switch (series) {
    HistorySeries.surfaceMoisture => (
      DashboardFirebaseKeys.soilMoistureGraph,
      DashboardFirebaseKeys.soil5cm,
    ),
    HistorySeries.rootMoisture => (
      DashboardFirebaseKeys.soilMoistureGraph,
      DashboardFirebaseKeys.soil20cm,
    ),
    HistorySeries.deepMoisture => (
      DashboardFirebaseKeys.soilMoistureGraph,
      DashboardFirebaseKeys.soil40cm,
    ),
    HistorySeries.compositeMoisture => (
      DashboardFirebaseKeys.soilMoistureGraph,
      DashboardFirebaseKeys.compositeMoisture,
    ),
    HistorySeries.fieldTemperature => (
      DashboardFirebaseKeys.temperatureGraph,
      DashboardFirebaseKeys.fieldTemperatureHistory,
    ),
    HistorySeries.weatherTemperature => (
      DashboardFirebaseKeys.temperatureGraph,
      DashboardFirebaseKeys.weatherTemperatureHistory,
    ),
    HistorySeries.fieldHumidity => (
      DashboardFirebaseKeys.humidityGraph,
      DashboardFirebaseKeys.fieldHumidityHistory,
    ),
    HistorySeries.weatherHumidity => (
      DashboardFirebaseKeys.humidityGraph,
      DashboardFirebaseKeys.weatherHumidityHistory,
    ),
    HistorySeries.pumpStatus => (
      DashboardFirebaseKeys.pumpGraph,
      DashboardFirebaseKeys.pumpStatus,
    ),
  };

  Map<Object?, Object?> _map(Object? value) =>
      value is Map<Object?, Object?> ? value : const <Object?, Object?>{};

  double? _double(Object? value) => switch (value) {
    num() => value.toDouble(),
    bool() => value ? 1 : 0,
    _ => null,
  };
}
