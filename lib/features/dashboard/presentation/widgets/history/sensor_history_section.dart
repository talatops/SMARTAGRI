import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/extensions/responsive_extension.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../../core/widgets/constants.dart';
import '../../notifier/dashboard_notifier.dart';
import 'history_chart_panel.dart';

class SensorHistorySection extends StatelessWidget {
  const SensorHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final history = ref.watch(dashboardProvider.select((state) => state.sensorHistory));
      if (history == null) return const SizedBox.shrink();
      final currentHour = ref.watch(dashboardProvider.select((state) => state.currentHour));

      return Column(
        children: [
          for (final chart in HistoryChart.values) ...[
            HeightBox(height: context.appGridGutter),
            HistoryChartPanel(
              chart: chart,
              history: history,
              currentHour: currentHour,
              range: ref.watch(dashboardProvider.select((state) => state.historyRangeOf(chart))),
              onRangeSelected: (range) =>
                  ref.read(dashboardProvider.notifier).selectHistoryRange(chart, range),
            ),
          ],
        ],
      );
    });
  }
}
