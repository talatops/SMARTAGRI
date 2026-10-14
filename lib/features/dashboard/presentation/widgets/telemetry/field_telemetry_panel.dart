import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/extensions/responsive_extension.dart';
import '../../../../../core/extensions/responsive_size_extension.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_dimensions.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/constants.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/metric_tile.dart';
import '../../../../../core/widgets/status_pill.dart';
import '../../notifier/dashboard_notifier.dart';

class FieldTelemetryPanel extends StatelessWidget {
  const FieldTelemetryPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: AppStrings.telemetryTitle,
      subtitle: AppStrings.telemetrySubtitle,
      icon: AppAssets.telemetryPanel,
      iconColor: AppColors.primaryBlue,
      child: Consumer(builder: (context, ref, _) {
        final telemetry = ref.watch(dashboardProvider.select((state) => state.snapshot?.telemetry));
        if (telemetry == null) return const SizedBox.shrink();

        final tiles = <Widget>[
          _TelemetryMetric(
            icon: AppAssets.thermometer,
            iconColor: AppColors.amber,
            label: AppStrings.temperature,
            value: Formatters.temperature(telemetry.temperatureC),
            status: telemetry.temperatureStatus,
          ),
          _TelemetryMetric(
            icon: AppAssets.droplet,
            iconColor: AppColors.cyan,
            label: AppStrings.relativeHumidity,
            value: Formatters.percent(telemetry.humidityPercent, decimals: 0),
            status: telemetry.humidityStatus,
          ),
        ];
        final gap = AppDimensions.s10.w;

        return context.isMobileLayout
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  tiles[0],
                  SizedBox(height: gap),
                  tiles[1],
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: tiles[0]),
                  SizedBox(width: gap),
                  Expanded(child: tiles[1]),
                ],
              );
      }),
    );
  }
}

class _TelemetryMetric extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final MetricStatus status;

  const _TelemetryMetric({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return MetricTile(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.s10.w, vertical: AppDimensions.s16.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 22.r),
              WidthBox(width: AppDimensions.s8.w),
              Flexible(
                child: CustomText(
                  text: label,
                  style: AppTextStyles.tileLabel,
                  fontSize: 13.5,
                  maxLines: 1,
                  autoManageSize: true,
                  minFontSize: 9,
                ),
              ),
            ],
          ),
          CustomText(
            text: value,
            style: AppTextStyles.metricValueXL,
            maxLines: 1,
            textAlign: TextAlign.center,
            autoManageSize: true,
            minFontSize: 20,
          ),
          StatusPill.fromStatus(status),
        ],
      ),
    );
  }
}
