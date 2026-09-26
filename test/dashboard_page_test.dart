import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_agri_system/core/utils/app_strings.dart';
import 'package:smart_agri_system/core/utils/enums.dart';
import 'package:smart_agri_system/features/dashboard/domain/entities/location_exception.dart';
import 'package:smart_agri_system/features/dashboard/presentation/widgets/layout/dashboard_skeleton.dart';

import 'support/app_harness.dart';
import 'support/fakes.dart';

const desktop = Size(1440, 2800);
const tablet = Size(900, 3200);
const mobile = Size(400, 6000);

void useViewport(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> tapText(WidgetTester tester, String text, {bool last = false}) async {
  final finder = last ? find.text(text).last : find.text(text).first;
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder);
  await settle(tester);
}

Future<void> withApp(
  WidgetTester tester,
  Future<void> Function(DashboardFakes f) body, {
  Size size = desktop,
  void Function(DashboardFakes f)? setup,
}) async {
  useViewport(tester, size);
  final fakes = DashboardFakes();
  setup?.call(fakes);
  await pumpDashboardApp(tester, fakes);
  await settle(tester);
  try {
    await body(fakes);
  } finally {
    await unmountDashboardApp(tester);
  }
}

void main() {
  testWidgets('shows the skeleton until the first snapshot arrives', (tester) async {
    await withApp(tester, (f) async {
      expect(find.byType(DashboardSkeleton), findsOneWidget);
      expect(find.text(AppStrings.compositeTitle), findsNothing);

      f.dashboard.emit(buildSnapshot());
      await settle(tester);

      expect(find.byType(DashboardSkeleton), findsNothing);
      expect(find.text(AppStrings.compositeTitle), findsOneWidget);
    });
  });

  testWidgets('keeps the skeleton when the stream fails before data', (tester) async {
    await withApp(tester, (f) async {
      f.dashboard.emitError(Exception('x'));
      await settle(tester);
      expect(find.byType(DashboardSkeleton), findsOneWidget);
    });
  });

  testWidgets('renders snapshot values', (tester) async {
    await withApp(tester, (f) async {
      f.dashboard.emit(buildSnapshot());
      await settle(tester);

      expect(find.text('50.7%'), findsOneWidget);
      expect(find.text(AppStrings.optimalSoilMoisture), findsOneWidget);
      expect(find.text(AppStrings.optimalDescription), findsOneWidget);
      expect(find.text('52%'), findsOneWidget);
      expect(find.text('45%'), findsOneWidget);
      expect(find.text('70%'), findsOneWidget);
      for (final crop in crops) {
        expect(find.text(crop.name), findsOneWidget);
      }
      expect(find.text(AppStrings.auto), findsOneWidget);
      expect(find.text(AppStrings.manual), findsOneWidget);
      expect(find.text(AppStrings.pumpOff), findsOneWidget);
      expect(find.text(AppStrings.off), findsOneWidget);
      expect(find.text(AppStrings.pumpDisabled), findsOneWidget);
      expect(find.text('${AppStrings.lastUpdated}2:05:09 PM'), findsOneWidget);
    });
  });

  testWidgets('reflects pump state from the stream', (tester) async {
    await withApp(tester, (f) async {
      f.dashboard.emit(
        buildSnapshot(mode: PumpMode.manual, isPumpCommandOn: true, isPumpOn: true),
      );
      await settle(tester);

      expect(find.text(AppStrings.pumpOn), findsOneWidget);
      expect(find.text(AppStrings.on), findsOneWidget);
      expect(find.text(AppStrings.pumpEnabled), findsOneWidget);
    });
  });

  testWidgets('selecting a crop writes it and updates the verdict', (tester) async {
    await withApp(tester, (f) async {
      f.dashboard.emit(buildSnapshot());
      await settle(tester);

      await tapText(tester, AppStrings.rice);
      expect(f.dashboard.cropCalls, [CropType.rice]);
      expect(find.text(AppStrings.belowRangeTitle), findsOneWidget);
      expect(find.text(AppStrings.belowRangeDescription), findsOneWidget);

      await tapText(tester, AppStrings.rice);
      expect(f.dashboard.cropCalls, [CropType.rice]);
    });
  });

  testWidgets('failed crop write reverts the verdict', (tester) async {
    await withApp(tester, (f) async {
      f.dashboard.emit(buildSnapshot());
      await settle(tester);
      f.dashboard.writeError = Exception('offline');

      await tapText(tester, AppStrings.rice);
      expect(f.dashboard.cropCalls, [CropType.rice]);
      expect(find.text(AppStrings.optimalSoilMoisture), findsOneWidget);
    });
  });

  testWidgets('pump button is inert in auto and toggles in manual', (tester) async {
    await withApp(tester, (f) async {
      f.dashboard.emit(buildSnapshot());
      await settle(tester);

      await tapText(tester, AppStrings.pumpOff);
      expect(f.dashboard.toggleCalls, isEmpty);

      await tapText(tester, AppStrings.manual);
      expect(f.dashboard.pumpModeCalls, [PumpMode.manual]);

      await tapText(tester, AppStrings.pumpOff);
      expect(f.dashboard.toggleCalls, [true]);
      expect(find.text(AppStrings.pumpOff), findsOneWidget);

      f.dashboard.emit(
        buildSnapshot(mode: PumpMode.manual, isPumpCommandOn: true, isPumpOn: true),
      );
      await settle(tester);
      expect(find.text(AppStrings.pumpOn), findsOneWidget);

      await tapText(tester, AppStrings.pumpOn);
      expect(f.dashboard.toggleCalls, [true, false]);

      await tapText(tester, AppStrings.auto);
      expect(f.dashboard.pumpModeCalls, [PumpMode.manual, PumpMode.auto]);
    });
  });

  testWidgets('shows weather and place name once located', (tester) async {
    await withApp(
      tester,
      setup: (f) {
        f.locateAt(samplePoint);
        f.location.placeName = 'Rawalpindi, PK';
      },
      (f) async {
        f.dashboard.emit(buildSnapshot());
        await settle(tester);

        expect(find.text('Rawalpindi, PK'), findsOneWidget);
        expect(find.text('22.6°C'), findsOneWidget);
        expect(find.text(AppStrings.partlyCloudy), findsOneWidget);
        expect(find.text('15%'), findsOneWidget);
        expect(find.text('12 km/h'), findsOneWidget);
        expect(find.text('58%'), findsOneWidget);
      },
    );
  });

  testWidgets('shows placeholders while weather is unavailable', (tester) async {
    await withApp(tester, (f) async {
      f.dashboard.emit(buildSnapshot());
      await settle(tester);

      expect(find.text('22.6°C'), findsNothing);
      expect(find.text(AppStrings.locationPermissionDenied), findsNothing);
      expect(find.text(AppStrings.locationUnavailable), findsNothing);
    });
  });

  testWidgets('location prompt retries location', (tester) async {
    await withApp(
      tester,
      setup: (f) => f.locateFails(const LocationException(LocationIssue.permissionDenied)),
      (f) async {
        f.dashboard.emit(buildSnapshot());
        await settle(tester);

        expect(find.text(AppStrings.locationPermissionDenied), findsOneWidget);
        expect(find.text(AppStrings.allowLocation), findsOneWidget);
        expect(find.text(AppStrings.locationUnavailable), findsOneWidget);

        f.locateAt(samplePoint);
        await tapText(tester, AppStrings.allowLocation);
        expect(f.location.locateCalls, 2);
        expect(find.text(AppStrings.locationPermissionDenied), findsNothing);
        expect(find.text('22.6°C'), findsOneWidget);
        expect(find.text('Islamabad, PK'), findsOneWidget);
      },
    );
  });

  testWidgets('history charts appear with data and ranges change per chart', (tester) async {
    await withApp(tester, (f) async {
      f.dashboard.emit(buildSnapshot());
      await settle(tester);
      expect(find.text(AppStrings.historySoilTitle), findsNothing);

      f.history.emit(buildHistory());
      await settle(tester);
      for (final chart in HistoryChart.values) {
        expect(find.text(chart.title), findsOneWidget);
      }
      expect(find.text(AppStrings.last24Hours), findsNWidgets(4));

      await tapText(tester, AppStrings.last24Hours);
      await tapText(tester, AppStrings.last6Hours, last: true);
      await settle(tester);

      expect(find.text(AppStrings.last6Hours), findsOneWidget);
      expect(find.text(AppStrings.last24Hours), findsNWidgets(3));
      expect(find.text(AppStrings.timeAxis6Hours), findsOneWidget);
    });
  });

  testWidgets('footer refresh reloads the snapshot and location', (tester) async {
    await withApp(tester, setup: (f) => f.locateAt(samplePoint), (f) async {
      f.dashboard.emit(buildSnapshot());
      await settle(tester);
      expect(f.dashboard.fetchCalls, 0);
      expect(f.location.locateCalls, 1);

      final refreshed = DateTime(2026, 9, 25, 16, 45, 1);
      f.dashboard.fetchResult = buildSnapshot(lastUpdated: refreshed, score: 30);
      await tapText(tester, '${AppStrings.lastUpdated}2:05:09 PM');

      expect(f.dashboard.fetchCalls, 1);
      expect(f.location.locateCalls, 2);
      expect(find.text('${AppStrings.lastUpdated}4:45:01 PM'), findsOneWidget);
      expect(find.text(AppStrings.belowRangeTitle), findsOneWidget);
    });
  });

  for (final entry in {'desktop': desktop, 'tablet': tablet, 'mobile': mobile}.entries) {
    testWidgets('lays out fully on ${entry.key}', (tester) async {
      await withApp(tester, size: entry.value, setup: (f) => f.locateAt(samplePoint), (f) async {
        expect(find.byType(DashboardSkeleton), findsOneWidget);

        f.dashboard.emit(buildSnapshot());
        f.history.emit(buildHistory());
        await settle(tester);

        expect(find.text(AppStrings.compositeTitle), findsOneWidget);
        expect(find.text(AppStrings.weatherTitle), findsOneWidget);
        expect(find.text(AppStrings.cropTitle), findsOneWidget);
        expect(find.text(AppStrings.historyPumpTitle), findsOneWidget);
        expect(find.text('22.6°C'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });
  }

  testWidgets('unmounting releases the streams', (tester) async {
    useViewport(tester, desktop);
    final fakes = DashboardFakes();
    await pumpDashboardApp(tester, fakes);
    await settle(tester);
    expect(fakes.dashboard.snapshots.hasListener, isTrue);
    expect(fakes.history.history.hasListener, isTrue);

    await unmountDashboardApp(tester);
    expect(fakes.dashboard.snapshots.hasListener, isFalse);
    expect(fakes.history.history.hasListener, isFalse);
  });
}
