import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_agri_system/core/utils/app_assets.dart';
import 'package:smart_agri_system/core/utils/app_colors.dart';
import 'package:smart_agri_system/core/utils/app_durations.dart';
import 'package:smart_agri_system/core/utils/app_strings.dart';
import 'package:smart_agri_system/core/utils/enums.dart';
import 'package:smart_agri_system/features/dashboard/domain/entities/location_exception.dart';
import 'package:smart_agri_system/features/dashboard/domain/entities/sensor_history.dart';

import 'support/dashboard_harness.dart';
import 'support/fakes.dart';

final fixedNow = DateTime(2026, 9, 25, 10, 30);

Future<void> withHarness(
  WidgetTester tester,
  Future<void> Function(DashboardHarness h, DashboardFakes f) body, {
  void Function(DashboardFakes f)? setup,
  DateTime Function()? clock,
}) async {
  final fakes = DashboardFakes();
  setup?.call(fakes);
  final harness = DashboardHarness(fakes, clock: clock ?? () => fixedNow);
  harness.start();
  try {
    await body(harness, fakes);
  } finally {
    harness.dispose();
  }
}

Future<void> flush(WidgetTester tester) => tester.pump();

void main() {
  group('initial state', () {
    testWidgets('exposes defaults before any data arrives', (tester) async {
      await withHarness(tester, (h, f) async {
        expect(h.snapshot, isNull);
        expect(h.isLoading, isTrue);
        expect(h.isRefreshing, isFalse);
        expect(h.selectedCrop, isNull);
        expect(h.pumpMode, PumpMode.auto);
        expect(h.isPumpCommandOn, isFalse);
        expect(h.isPumpOn, isFalse);
        expect(h.now, fixedNow);
        expect(h.lastUpdated, isNull);
        expect(h.weather, isNull);
        expect(h.isWeatherLoading, isFalse);
        expect(h.coordinates, isNull);
        expect(h.locationName, isNull);
        expect(h.isLocationLoading, isTrue);
        expect(h.locationIssue, isNull);
        expect(h.sensorHistory, isNull);

        expect(h.crops, isEmpty);
        expect(h.compositeScore, 0);
        expect(h.compositeStatus, MetricStatus.normal);
        expect(h.compositeHeadline, AppStrings.optimalSoilMoisture);
        expect(h.compositeDescription, AppStrings.optimalDescription);
        expect(h.compositeAccent, AppColors.success);
        expect(h.isPumpControlEnabled, isFalse);
        expect(h.pumpStatusLabel, AppStrings.off);
        expect(h.pumpStatusDescription, AppStrings.pumpDisabled);
        expect(h.pumpButtonLabel, AppStrings.pumpOff);
        expect(h.showWeatherPlaceholder, isTrue);
        expect(h.weatherLocationIssue, isNull);
        expect(h.weatherTemperatureLabel, AppStrings.noValue);
        expect(h.weatherConditionLabel, AppStrings.weatherUnavailable);
        expect(h.weatherIcon, AppAssets.weatherNotAvailable);
        expect(h.weatherRainChanceLabel, AppStrings.noValue);
        expect(h.weatherWindLabel, AppStrings.noValue);
        expect(h.weatherHumidityLabel, AppStrings.noValue);
        expect(h.showLocationPlaceholder, isTrue);
        expect(h.locationLabel, AppStrings.locationUnavailable);
        for (final chart in HistoryChart.values) {
          expect(h.historyRangeOf(chart), HistoryRange.today);
        }

        expect(f.dashboard.watchCalls, 1);
        expect(f.dashboard.fetchCalls, 0);
        expect(f.location.locateCalls, 1);
        expect(f.weather.calls, isEmpty);
      });
    });
  });

  group('snapshot stream', () {
    testWidgets('applies each emitted snapshot', (tester) async {
      await withHarness(tester, (h, f) async {
        final first = buildSnapshot();
        f.dashboard.emit(first);
        await flush(tester);

        expect(h.snapshot, same(first));
        expect(h.isLoading, isFalse);
        expect(h.selectedCrop, cropOf(CropType.wheat));
        expect(h.pumpMode, PumpMode.auto);
        expect(h.isPumpCommandOn, isFalse);
        expect(h.isPumpOn, isFalse);
        expect(h.lastUpdated, sampleUpdated);
        expect(h.crops, hasLength(5));
        expect(h.compositeScore, 50.7);

        final updated = DateTime(2026, 9, 25, 15);
        final second = buildSnapshot(
          crop: CropType.rice,
          mode: PumpMode.manual,
          isPumpCommandOn: true,
          isPumpOn: true,
          score: 72,
          lastUpdated: updated,
        );
        f.dashboard.emit(second);
        await flush(tester);

        expect(h.snapshot, same(second));
        expect(h.selectedCrop, cropOf(CropType.rice));
        expect(h.pumpMode, PumpMode.manual);
        expect(h.isPumpCommandOn, isTrue);
        expect(h.isPumpOn, isTrue);
        expect(h.lastUpdated, updated);
        expect(h.isPumpControlEnabled, isTrue);
        expect(h.pumpStatusLabel, AppStrings.on);
        expect(h.pumpStatusDescription, AppStrings.pumpEnabled);
        expect(h.pumpButtonLabel, AppStrings.pumpOn);
      });
    });

    testWidgets('stops loading when the stream errors before data', (tester) async {
      await withHarness(tester, (h, f) async {
        f.dashboard.emitError(Exception('boom'));
        await flush(tester);

        expect(h.isLoading, isFalse);
        expect(h.snapshot, isNull);
      });
    });

    testWidgets('keeps the last snapshot when the stream errors later', (tester) async {
      await withHarness(tester, (h, f) async {
        final first = buildSnapshot();
        f.dashboard.emit(first);
        await flush(tester);
        f.dashboard.emitError(Exception('boom'));
        await flush(tester);

        expect(h.snapshot, same(first));
        expect(h.isLoading, isFalse);

        final next = buildSnapshot(score: 60);
        f.dashboard.emit(next);
        await flush(tester);
        expect(h.snapshot, same(next));
      });
    });
  });

  group('composite verdict', () {
    Future<void> expectVerdict(
      WidgetTester tester,
      double score,
      MetricStatus status,
      String headline,
      String description,
      Color accent,
    ) async {
      await withHarness(tester, (h, f) async {
        f.dashboard.emit(buildSnapshot(score: score));
        await flush(tester);
        expect(h.compositeScore, score);
        expect(h.compositeStatus, status);
        expect(h.compositeHeadline, headline);
        expect(h.compositeDescription, description);
        expect(h.compositeAccent, accent);
      });
    }

    testWidgets('within range', (tester) async {
      await expectVerdict(
        tester,
        50.7,
        MetricStatus.normal,
        AppStrings.optimalSoilMoisture,
        AppStrings.optimalDescription,
        AppColors.success,
      );
    });

    testWidgets('at lower bound', (tester) async {
      await expectVerdict(
        tester,
        40,
        MetricStatus.normal,
        AppStrings.optimalSoilMoisture,
        AppStrings.optimalDescription,
        AppColors.success,
      );
    });

    testWidgets('at upper bound', (tester) async {
      await expectVerdict(
        tester,
        70,
        MetricStatus.normal,
        AppStrings.optimalSoilMoisture,
        AppStrings.optimalDescription,
        AppColors.success,
      );
    });

    testWidgets('below range', (tester) async {
      await expectVerdict(
        tester,
        30,
        MetricStatus.warning,
        AppStrings.belowRangeTitle,
        AppStrings.belowRangeDescription,
        AppColors.amber,
      );
    });

    testWidgets('above range', (tester) async {
      await expectVerdict(
        tester,
        80,
        MetricStatus.warning,
        AppStrings.aboveRangeTitle,
        AppStrings.aboveRangeDescription,
        AppColors.amber,
      );
    });
  });

  group('selectCrop', () {
    testWidgets('ignores the already selected crop', (tester) async {
      await withHarness(tester, (h, f) async {
        f.dashboard.emit(buildSnapshot());
        await flush(tester);

        await h.selectCrop(cropOf(CropType.wheat));
        expect(f.dashboard.cropCalls, isEmpty);
      });
    });

    testWidgets('updates optimistically and writes the crop', (tester) async {
      await withHarness(tester, (h, f) async {
        f.dashboard.emit(buildSnapshot());
        await flush(tester);
        f.dashboard.writeGate = Completer<void>();

        final pending = h.selectCrop(cropOf(CropType.rice));
        expect(h.selectedCrop, cropOf(CropType.rice));
        expect(h.compositeStatus, MetricStatus.warning);
        expect(h.compositeHeadline, AppStrings.belowRangeTitle);
        expect(f.dashboard.cropCalls, [CropType.rice]);

        f.dashboard.writeGate!.complete();
        await pending;
        expect(h.selectedCrop, cropOf(CropType.rice));
      });
    });

    testWidgets('reverts to the snapshot when the write fails', (tester) async {
      await withHarness(tester, (h, f) async {
        f.dashboard.emit(buildSnapshot());
        await flush(tester);
        f.dashboard.writeError = Exception('offline');

        await h.selectCrop(cropOf(CropType.cotton));
        expect(f.dashboard.cropCalls, [CropType.cotton]);
        expect(h.selectedCrop, cropOf(CropType.wheat));
      });
    });

    testWidgets('selects a crop before any snapshot without reverting', (tester) async {
      await withHarness(tester, (h, f) async {
        f.dashboard.writeError = Exception('offline');
        await h.selectCrop(cropOf(CropType.maize));
        expect(f.dashboard.cropCalls, [CropType.maize]);
        expect(h.selectedCrop, cropOf(CropType.maize));
      });
    });
  });

  group('setPumpMode', () {
    testWidgets('ignores the current mode', (tester) async {
      await withHarness(tester, (h, f) async {
        f.dashboard.emit(buildSnapshot());
        await flush(tester);

        await h.setPumpMode(PumpMode.auto);
        expect(f.dashboard.pumpModeCalls, isEmpty);
      });
    });

    testWidgets('updates optimistically and writes the mode', (tester) async {
      await withHarness(tester, (h, f) async {
        f.dashboard.emit(buildSnapshot());
        await flush(tester);
        f.dashboard.writeGate = Completer<void>();

        final pending = h.setPumpMode(PumpMode.manual);
        expect(h.pumpMode, PumpMode.manual);
        expect(h.isPumpControlEnabled, isTrue);
        expect(f.dashboard.pumpModeCalls, [PumpMode.manual]);

        f.dashboard.writeGate!.complete();
        await pending;
        expect(h.pumpMode, PumpMode.manual);
      });
    });

    testWidgets('reverts every field to the snapshot when the write fails', (tester) async {
      await withHarness(tester, (h, f) async {
        f.dashboard.emit(buildSnapshot());
        await flush(tester);
        f.dashboard.writeGate = Completer<void>();

        final modeWrite = h.setPumpMode(PumpMode.manual);
        final cropWrite = h.selectCrop(cropOf(CropType.rice));
        expect(h.pumpMode, PumpMode.manual);
        expect(h.selectedCrop, cropOf(CropType.rice));

        f.dashboard.writeError = Exception('offline');
        f.dashboard.writeGate!.complete();
        await modeWrite;
        await cropWrite;

        expect(h.pumpMode, PumpMode.auto);
        expect(h.selectedCrop, cropOf(CropType.wheat));
      });
    });
  });

  group('togglePump', () {
    testWidgets('does nothing in auto mode', (tester) async {
      await withHarness(tester, (h, f) async {
        f.dashboard.emit(buildSnapshot());
        await flush(tester);

        await h.togglePump();
        expect(f.dashboard.toggleCalls, isEmpty);
      });
    });

    testWidgets('writes the inverted command without changing local state', (tester) async {
      await withHarness(tester, (h, f) async {
        f.dashboard.emit(buildSnapshot(mode: PumpMode.manual));
        await flush(tester);

        await h.togglePump();
        expect(f.dashboard.toggleCalls, [true]);
        expect(h.isPumpCommandOn, isFalse);
        expect(h.pumpButtonLabel, AppStrings.pumpOff);

        f.dashboard.emit(buildSnapshot(mode: PumpMode.manual, isPumpCommandOn: true));
        await flush(tester);
        await h.togglePump();
        expect(f.dashboard.toggleCalls, [true, false]);
      });
    });

    testWidgets('works after an optimistic switch to manual', (tester) async {
      await withHarness(tester, (h, f) async {
        f.dashboard.emit(buildSnapshot());
        await flush(tester);

        await h.setPumpMode(PumpMode.manual);
        await h.togglePump();
        expect(f.dashboard.toggleCalls, [true]);
      });
    });

    testWidgets('reverts to the snapshot when the write fails', (tester) async {
      await withHarness(tester, (h, f) async {
        f.dashboard.emit(buildSnapshot());
        await flush(tester);
        await h.setPumpMode(PumpMode.manual);
        f.dashboard.writeError = Exception('offline');

        await h.togglePump();
        expect(f.dashboard.toggleCalls, [true]);
        expect(h.pumpMode, PumpMode.auto);
        expect(h.isPumpControlEnabled, isFalse);
      });
    });
  });

  group('location and weather', () {
    testWidgets('loads place name and weather after locating', (tester) async {
      await withHarness(tester, setup: (f) => f.locateAt(samplePoint), (h, f) async {
        await flush(tester);

        expect(h.coordinates, samplePoint);
        expect(h.locationIssue, isNull);
        expect(f.location.placeCalls, [samplePoint]);
        expect(h.locationName, 'Islamabad, PK');
        expect(h.isLocationLoading, isFalse);
        expect(f.weather.calls, [samplePoint]);
        expect(h.weather, same(sampleWeather));
        expect(h.isWeatherLoading, isFalse);
        expect(f.dashboard.savedWeather, [sampleWeather]);

        expect(h.showWeatherPlaceholder, isFalse);
        expect(h.weatherLocationIssue, isNull);
        expect(h.weatherTemperatureLabel, '22.6°C');
        expect(h.weatherConditionLabel, AppStrings.partlyCloudy);
        expect(h.weatherIcon, AppAssets.weatherPartlyCloudyDay);
        expect(h.weatherRainChanceLabel, '15%');
        expect(h.weatherWindLabel, '12 km/h');
        expect(h.weatherHumidityLabel, '58%');
        expect(h.showLocationPlaceholder, isFalse);
        expect(h.locationLabel, 'Islamabad, PK');
      });
    });

    testWidgets('reports loading flags while requests are pending', (tester) async {
      await withHarness(
        tester,
        setup: (f) {
          f.locateAt(samplePoint);
          f.location.placeGate = Completer<void>();
          f.weather.gate = Completer<void>();
        },
        (h, f) async {
          await flush(tester);
          expect(h.isLocationLoading, isTrue);
          expect(h.isWeatherLoading, isTrue);
          expect(h.showWeatherPlaceholder, isTrue);
          expect(h.showLocationPlaceholder, isTrue);

          f.location.placeGate!.complete();
          await flush(tester);
          expect(h.isLocationLoading, isFalse);
          expect(h.isWeatherLoading, isTrue);
          expect(h.showWeatherPlaceholder, isTrue);
          expect(h.showLocationPlaceholder, isFalse);

          f.weather.gate!.complete();
          await flush(tester);
          expect(h.isWeatherLoading, isFalse);
          expect(h.showWeatherPlaceholder, isFalse);
        },
      );
    });

    testWidgets('keeps weather empty and skips saving when weather fails', (tester) async {
      await withHarness(
        tester,
        setup: (f) {
          f.locateAt(samplePoint);
          f.weather.error = Exception('down');
        },
        (h, f) async {
          await flush(tester);
          expect(h.weather, isNull);
          expect(h.isWeatherLoading, isFalse);
          expect(f.dashboard.savedWeather, isEmpty);
          expect(h.showWeatherPlaceholder, isFalse);
          expect(h.weatherConditionLabel, AppStrings.weatherUnavailable);
        },
      );
    });

    testWidgets('keeps previous weather when a refresh fails', (tester) async {
      await withHarness(tester, setup: (f) => f.locateAt(samplePoint), (h, f) async {
        await flush(tester);
        f.weather.error = Exception('down');
        await h.loadWeather();
        expect(h.weather, same(sampleWeather));
        expect(h.isWeatherLoading, isFalse);
      });
    });

    testWidgets('swallows weather save failures', (tester) async {
      await withHarness(
        tester,
        setup: (f) {
          f.locateAt(samplePoint);
          f.dashboard.saveError = Exception('denied');
        },
        (h, f) async {
          await flush(tester);
          expect(h.weather, same(sampleWeather));
          expect(f.dashboard.savedWeather, [sampleWeather]);
        },
      );
    });

    testWidgets('keeps previous place name when lookup fails', (tester) async {
      await withHarness(tester, setup: (f) => f.locateAt(samplePoint), (h, f) async {
        await flush(tester);
        f.location.placeError = Exception('down');
        await h.loadLocation();
        expect(h.locationName, 'Islamabad, PK');
        expect(h.isLocationLoading, isFalse);
      });
    });

    testWidgets('leaves place name empty when first lookup fails', (tester) async {
      await withHarness(
        tester,
        setup: (f) {
          f.locateAt(samplePoint);
          f.location.placeError = Exception('down');
        },
        (h, f) async {
          await flush(tester);
          expect(h.locationName, isNull);
          expect(h.isLocationLoading, isFalse);
          expect(h.locationLabel, AppStrings.locationUnavailable);
          expect(h.weather, same(sampleWeather));
        },
      );
    });

    testWidgets('ignores overlapping location requests', (tester) async {
      await withHarness(tester, (h, f) async {
        await h.loadLocation();
        await h.loadLocation();
        expect(f.location.locateCalls, 1);
        expect(h.isLocationLoading, isTrue);
      });
    });

    for (final issue in [
      LocationIssue.permissionDenied,
      LocationIssue.permissionBlocked,
      LocationIssue.serviceDisabled,
    ]) {
      testWidgets('reports ${issue.name} and clears location data', (tester) async {
        await withHarness(tester, setup: (f) => f.locateAt(samplePoint), (h, f) async {
          await flush(tester);
          expect(h.weather, isNotNull);

          f.locateFails(LocationException(issue));
          await h.loadLocation();

          expect(h.locationIssue, issue);
          expect(h.coordinates, isNull);
          expect(h.locationName, isNull);
          expect(h.weather, isNull);
          expect(h.isLocationLoading, isFalse);
          expect(h.weatherLocationIssue, issue);
          expect(h.showWeatherPlaceholder, isFalse);
          expect(f.weather.calls, hasLength(1));
          expect(f.location.placeCalls, hasLength(1));

          final expectedMessage = kIsWeb && issue.isPermissionBlocked
              ? AppStrings.locationPermissionBlockedWeb
              : issue.message;
          expect(h.locationIssueMessage, expectedMessage);

          final canOpenSettings =
              !kIsWeb && (issue.isPermissionBlocked || issue.isServiceDisabled);
          final expectedAction = canOpenSettings
              ? AppStrings.openSettings
              : issue.isPermissionDenied
              ? AppStrings.allowLocation
              : AppStrings.tryAgain;
          expect(h.locationActionLabel, expectedAction);
        });
      });
    }

    testWidgets('maps unknown errors to unavailable', (tester) async {
      await withHarness(tester, setup: (f) => f.locateFails(Exception('x')), (h, f) async {
        await flush(tester);
        expect(h.locationIssue, LocationIssue.unavailable);
        expect(h.weatherLocationIssue, LocationIssue.unavailable);
        expect(h.coordinates, isNull);
        expect(h.isLocationLoading, isFalse);
        expect(h.locationIssueMessage, AppStrings.locationFetchFailed);
        expect(h.locationActionLabel, AppStrings.tryAgain);
      });
    });

    testWidgets('keeps previous location when it becomes unavailable', (tester) async {
      await withHarness(tester, setup: (f) => f.locateAt(samplePoint), (h, f) async {
        await flush(tester);
        f.locateFails(const LocationException(LocationIssue.unavailable));
        await h.loadLocation();

        expect(h.locationIssue, LocationIssue.unavailable);
        expect(h.weatherLocationIssue, isNull);
        expect(h.coordinates, samplePoint);
        expect(h.locationName, 'Islamabad, PK');
        expect(h.weather, same(sampleWeather));
        expect(f.location.placeCalls, hasLength(2));
        expect(f.weather.calls, hasLength(2));
        expect(h.isLocationLoading, isFalse);
      });
    });

    testWidgets('clears the issue after a later success', (tester) async {
      await withHarness(
        tester,
        setup: (f) => f.locateFails(const LocationException(LocationIssue.permissionDenied)),
        (h, f) async {
          await flush(tester);
          expect(h.locationIssue, LocationIssue.permissionDenied);

          f.locateAt(samplePoint);
          await h.loadLocation();
          expect(h.locationIssue, isNull);
          expect(h.coordinates, samplePoint);
          expect(h.weather, same(sampleWeather));
        },
      );
    });

    testWidgets('does not fetch weather without coordinates', (tester) async {
      await withHarness(tester, (h, f) async {
        await h.loadWeather();
        expect(f.weather.calls, isEmpty);
        expect(h.isWeatherLoading, isFalse);
      });
    });

    testWidgets('refreshes weather on the refresh interval', (tester) async {
      await withHarness(tester, setup: (f) => f.locateAt(samplePoint), (h, f) async {
        await flush(tester);
        expect(f.weather.calls, hasLength(1));

        await tester.pump(AppDurations.weatherRefresh - const Duration(seconds: 1));
        expect(f.weather.calls, hasLength(1));

        await tester.pump(const Duration(seconds: 1));
        expect(f.weather.calls, hasLength(2));
        expect(f.dashboard.savedWeather, hasLength(2));

        await tester.pump(AppDurations.weatherRefresh);
        expect(f.weather.calls, hasLength(3));
      });
    });

    testWidgets('does not refresh weather on the interval without coordinates', (tester) async {
      await withHarness(tester, (h, f) async {
        await tester.pump(AppDurations.weatherRefresh);
        expect(f.weather.calls, isEmpty);
      });
    });
  });

  group('resolveLocationIssue', () {
    testWidgets('does nothing without an issue', (tester) async {
      await withHarness(tester, setup: (f) => f.locateAt(samplePoint), (h, f) async {
        await flush(tester);
        await h.resolveLocationIssue();
        expect(f.location.locateCalls, 1);
        expect(f.location.openSettingsCalls, isEmpty);
      });
    });

    testWidgets('retries location when permission was denied', (tester) async {
      await withHarness(
        tester,
        setup: (f) => f.locateFails(const LocationException(LocationIssue.permissionDenied)),
        (h, f) async {
          await flush(tester);
          f.locateAt(samplePoint);
          await h.resolveLocationIssue();
          expect(f.location.openSettingsCalls, isEmpty);
          expect(f.location.locateCalls, 2);
          expect(h.coordinates, samplePoint);
        },
      );
    });

    testWidgets('retries location for unavailable issues', (tester) async {
      await withHarness(tester, setup: (f) => f.locateFails(Exception('x')), (h, f) async {
        await flush(tester);
        await h.resolveLocationIssue();
        expect(f.location.openSettingsCalls, isEmpty);
        expect(f.location.locateCalls, 2);
      });
    });

    for (final issue in [LocationIssue.permissionBlocked, LocationIssue.serviceDisabled]) {
      testWidgets('handles ${issue.name} per platform', (tester) async {
        await withHarness(
          tester,
          setup: (f) => f.locateFails(LocationException(issue)),
          (h, f) async {
            await flush(tester);
            await h.resolveLocationIssue();

            if (kIsWeb) {
              expect(f.location.openSettingsCalls, isEmpty);
              expect(f.location.locateCalls, 2);
            } else {
              expect(f.location.openSettingsCalls, [issue]);
              expect(f.location.locateCalls, 1);

              tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
              tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
              await flush(tester);
              expect(f.location.locateCalls, 2);

              tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
              tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
              await flush(tester);
              expect(f.location.locateCalls, 2);
            }
          },
        );
      });
    }

    testWidgets('retries in place when settings cannot be opened', (tester) async {
      await withHarness(
        tester,
        setup: (f) {
          f.locateFails(const LocationException(LocationIssue.permissionBlocked));
          f.location.openSettingsResult = (_) async => false;
        },
        (h, f) async {
          await flush(tester);
          await h.resolveLocationIssue();
          expect(f.location.locateCalls, 2);
          expect(f.location.openSettingsCalls, kIsWeb ? isEmpty : [LocationIssue.permissionBlocked]);
        },
      );
    });

    testWidgets('retries in place when opening settings throws', (tester) async {
      await withHarness(
        tester,
        setup: (f) {
          f.locateFails(const LocationException(LocationIssue.serviceDisabled));
          f.location.openSettingsResult = (_) => Future<bool>.error(Exception('no settings'));
        },
        (h, f) async {
          await flush(tester);
          await h.resolveLocationIssue();
          expect(f.location.locateCalls, 2);
        },
      );
    });

    testWidgets('ignores resume when not waiting for settings', (tester) async {
      await withHarness(
        tester,
        setup: (f) => f.locateFails(const LocationException(LocationIssue.permissionDenied)),
        (h, f) async {
          await flush(tester);
          tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
          tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
          await flush(tester);
          expect(f.location.locateCalls, 1);
        },
      );
    });
  });

  group('sensor history', () {
    testWidgets('applies emissions and ignores errors', (tester) async {
      await withHarness(tester, (h, f) async {
        final first = buildHistory();
        f.history.emit(first);
        await flush(tester);
        expect(h.sensorHistory, same(first));

        f.history.emitError(Exception('x'));
        await flush(tester);
        expect(h.sensorHistory, same(first));

        final second = buildHistory(seed: 20);
        f.history.emit(second);
        await flush(tester);
        expect(h.sensorHistory, same(second));
      });
    });

    testWidgets('tracks the selected range per chart', (tester) async {
      await withHarness(tester, (h, f) async {
        h.selectHistoryRange(HistoryChart.temperature, HistoryRange.last6Hours);
        expect(h.historyRangeOf(HistoryChart.temperature), HistoryRange.last6Hours);
        expect(h.historyRangeOf(HistoryChart.soilMoisture), HistoryRange.today);

        h.selectHistoryRange(HistoryChart.temperature, HistoryRange.last12Hours);
        h.selectHistoryRange(HistoryChart.pump, HistoryRange.last6Hours);
        expect(h.historyRangeOf(HistoryChart.temperature), HistoryRange.last12Hours);
        expect(h.historyRangeOf(HistoryChart.pump), HistoryRange.last6Hours);
        expect(h.historyRangeOf(HistoryChart.humidity), HistoryRange.today);
      });
    });

    testWidgets('exposes the current hour for the history windows', (tester) async {
      await withHarness(tester, (h, f) async {
        expect(h.currentHour, fixedNow.hour);
      });
    });

    test('today spans midnight up to the current hour', () {
      expect(HistoryRange.today.hoursEndingAt(0), [0]);
      expect(HistoryRange.today.hoursEndingAt(10), [for (var h = 0; h <= 10; h++) h]);
      expect(HistoryRange.today.hoursEndingAt(23), [for (var h = 0; h <= 23; h++) h]);
    });

    test('last N hours roll back from the current hour across midnight', () {
      expect(HistoryRange.last6Hours.hoursEndingAt(10), [5, 6, 7, 8, 9, 10]);
      expect(HistoryRange.last6Hours.hoursEndingAt(2), [21, 22, 23, 0, 1, 2]);
      expect(HistoryRange.last12Hours.hoursEndingAt(10), [23, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
      expect(HistoryRange.last24Hours.hoursEndingAt(10), [
        for (var h = 11; h <= 23; h++) h,
        for (var h = 0; h <= 10; h++) h,
      ]);
    });

    test('history slots map index 0 to 1 AM and index 23 to 12 AM', () {
      final history = SensorHistory(
        readings: {
          HistorySeries.surfaceMoisture: [
            for (var i = 0; i < SensorHistory.hoursInWindow; i++) i * 1.0,
          ],
        },
      );
      expect(history.valueAt(HistorySeries.surfaceMoisture, 1), 0);
      expect(history.valueAt(HistorySeries.surfaceMoisture, 0), 23);
      expect(history.valueAt(HistorySeries.surfaceMoisture, 10), 9);
      expect(history.valueAt(HistorySeries.pumpStatus, 10), isNull);
    });
  });

  group('clock', () {
    testWidgets('ticks every second', (tester) async {
      var current = fixedNow;
      await withHarness(tester, clock: () => current, (h, f) async {
        expect(h.now, fixedNow);
        current = fixedNow.add(const Duration(seconds: 1));
        await tester.pump(const Duration(milliseconds: 999));
        expect(h.now, fixedNow);
        await tester.pump(const Duration(milliseconds: 1));
        expect(h.now, current);
      });
    });
  });

  group('loadDashboard', () {
    testWidgets('loads a snapshot with the loading flag', (tester) async {
      await withHarness(tester, (h, f) async {
        f.dashboard.emitError(Exception('x'));
        await flush(tester);
        expect(h.isLoading, isFalse);

        final result = buildSnapshot(score: 61);
        f.dashboard.fetchResult = result;
        f.dashboard.fetchGate = Completer<void>();
        final pending = h.loadDashboard();
        expect(h.isLoading, isTrue);
        expect(h.isRefreshing, isFalse);
        expect(f.location.locateCalls, 1);

        f.dashboard.fetchGate!.complete();
        await pending;
        expect(h.isLoading, isFalse);
        expect(h.snapshot, same(result));
        expect(h.compositeScore, 61);
      });
    });

    testWidgets('refresh spins, reloads location and applies the snapshot', (tester) async {
      await withHarness(tester, setup: (f) => f.locateAt(samplePoint), (h, f) async {
        f.dashboard.emit(buildSnapshot());
        await flush(tester);
        expect(f.location.locateCalls, 1);

        final result = buildSnapshot(mode: PumpMode.manual, isPumpOn: true);
        f.dashboard.fetchResult = result;
        f.dashboard.fetchGate = Completer<void>();
        final pending = h.loadDashboard(isRefresh: true);
        expect(h.isRefreshing, isTrue);
        expect(h.isLoading, isFalse);

        f.dashboard.fetchGate!.complete();
        await pending;
        await flush(tester);
        expect(h.isRefreshing, isFalse);
        expect(h.snapshot, same(result));
        expect(h.pumpMode, PumpMode.manual);
        expect(h.isPumpOn, isTrue);
        expect(f.location.locateCalls, 2);
        expect(f.weather.calls, hasLength(2));
      });
    });

    testWidgets('resets flags and rethrows when fetching fails', (tester) async {
      await withHarness(tester, (h, f) async {
        f.dashboard.emit(buildSnapshot());
        await flush(tester);
        f.dashboard.fetchError = Exception('down');

        await expectLater(h.loadDashboard(isRefresh: true), throwsException);
        expect(h.isRefreshing, isFalse);
        expect(h.isLoading, isFalse);

        await expectLater(h.loadDashboard(), throwsException);
        expect(h.isLoading, isFalse);
      });
    });
  });

  group('dispose', () {
    testWidgets('cancels stream subscriptions', (tester) async {
      final fakes = DashboardFakes();
      final harness = DashboardHarness(fakes, clock: () => fixedNow);
      harness.start();
      expect(fakes.dashboard.snapshots.hasListener, isTrue);
      expect(fakes.history.history.hasListener, isTrue);

      harness.dispose();
      expect(fakes.dashboard.snapshots.hasListener, isFalse);
      expect(fakes.history.history.hasListener, isFalse);
    });

    testWidgets('tolerates requests that finish after disposal', (tester) async {
      final fakes = DashboardFakes()..locateAt(samplePoint);
      fakes.weather.gate = Completer<void>();
      final harness = DashboardHarness(fakes, clock: () => fixedNow);
      harness.start();
      await flush(tester);
      expect(fakes.weather.calls, hasLength(1));

      harness.dispose();
      fakes.weather.gate!.complete();
      await flush(tester);
      expect(tester.takeException(), isNull);
    });
  });
}
