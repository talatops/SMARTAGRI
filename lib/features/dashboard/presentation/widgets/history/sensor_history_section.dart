import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/extensions/responsive_extension.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../../core/widgets/constants.dart';
import '../../controller/dashboard_controller.dart';
import 'history_chart_panel.dart';

class SensorHistorySection extends StatelessWidget {
  final DashboardController controller;

  const SensorHistorySection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final history = controller.sensorHistory.value;
      if (history == null) return const SizedBox.shrink();

      return Column(
        children: [
          for (final chart in HistoryChart.values) ...[
            HeightBox(height: context.appGridGutter),
            HistoryChartPanel(
              chart: chart,
              history: history,
              range: controller.historyRangeOf(chart),
              onRangeSelected: (range) => controller.selectHistoryRange(chart, range),
            ),
          ],
        ],
      );
    });
  }
}
