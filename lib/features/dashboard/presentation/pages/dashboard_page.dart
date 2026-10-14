import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/responsive_size_extension.dart';
import '../../../../core/utils/app_dimensions.dart';
import '../../../../core/widgets/base_scaffold.dart';
import '../../../../core/widgets/constants.dart';
import '../../../../core/widgets/max_width_container.dart';
import '../notifier/dashboard_notifier.dart';
import '../widgets/composite/composite_moisture_panel.dart';
import '../widgets/crop/crop_profile_panel.dart';
import '../widgets/history/sensor_history_section.dart';
import '../widgets/layout/dashboard_footer.dart';
import '../widgets/layout/dashboard_grid.dart';
import '../widgets/layout/dashboard_header.dart';
import '../widgets/layout/dashboard_skeleton.dart';
import '../widgets/irrigation/irrigation_control_panel.dart';
import '../widgets/soil/soil_metrics_panel.dart';
import '../widgets/telemetry/field_telemetry_panel.dart';
import '../widgets/weather/weather_status_panel.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Consumer(builder: (context, ref, _) {
        final (hasSnapshot, isLoading) = ref.watch(
          dashboardProvider.select((state) => (state.snapshot != null, state.isLoading)),
        );
        if (isLoading || !hasSnapshot) {
          return const MaxWidthContainer(child: DashboardSkeleton());
        }

        return MaxWidthContainer(
          child: SelectionArea(
            child: Column(
              children: [
                HeightBox(height: AppDimensions.s16.h),
                DashboardHeader(),
                HeightBox(height: AppDimensions.s16.h),
                DashboardGrid(
                  soilPanel: SoilMetricsPanel(),
                  compositePanel: CompositeMoisturePanel(),
                  telemetryPanel: FieldTelemetryPanel(),
                  irrigationPanel: IrrigationControlPanel(),
                  weatherPanel: WeatherStatusPanel(),
                  cropPanel: CropProfilePanel(),
                ),
                SensorHistorySection(),
                HeightBox(height: AppDimensions.s16.h),
                DashboardFooter(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
