import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_agri_system/app.dart';

import 'dashboard_harness.dart';
import 'fakes.dart';

Future<void> pumpDashboardApp(WidgetTester tester, DashboardFakes fakes) async {
  await tester.pumpWidget(
    ProviderScope(overrides: dashboardOverrides(fakes), child: const SmartAgriApp()),
  );
}

Future<void> unmountDashboardApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
}
