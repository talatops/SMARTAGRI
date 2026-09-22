import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/extensions/responsive_size_extension.dart';
import '../../../../core/utils/app_dimensions.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/base_scaffold.dart';
import '../../../../core/widgets/constants.dart';
import '../../../../core/widgets/max_width_container.dart';
import '../controller/dashboard_controller.dart';
import '../widgets/composite_moisture_panel.dart';
import '../widgets/crop_profile_panel.dart';
import '../widgets/dashboard_footer.dart';
import '../widgets/dashboard_grid.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/field_telemetry_panel.dart';
import '../widgets/irrigation_control_panel.dart';
import '../widgets/soil_metrics_panel.dart';
import '../widgets/weather_status_panel.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Obx(() {
        final snapshot = controller.snapshot.value;
        if (controller.isLoading.value || snapshot == null) {
          return SizedBox(
            height: MediaQuery.sizeOf(context).height,
            child: const AppLoader(),
          );
        }

        return MaxWidthContainer(
          child: SelectionArea(
            child: Column(
              children: [
                HeightBox(height: AppDimensions.s16.h),
                DashboardHeader(controller: controller),
                HeightBox(height: AppDimensions.s16.h),
                DashboardGrid(
                  soilPanel: SoilMetricsPanel(
                    readings: snapshot.soilReadings,
                    waterLevel: snapshot.waterLevel,
                  ),
                  compositePanel: CompositeMoisturePanel(controller: controller),
                  telemetryPanel: FieldTelemetryPanel(telemetry: snapshot.telemetry),
                  irrigationPanel: IrrigationControlPanel(controller: controller),
                  weatherPanel: WeatherStatusPanel(weather: snapshot.weather),
                  cropPanel: CropProfilePanel(controller: controller),
                ),
                HeightBox(height: AppDimensions.s16.h),
                DashboardFooter(controller: controller),
              ],
            ),
          ),
        );
      }),
    );
  }
}
