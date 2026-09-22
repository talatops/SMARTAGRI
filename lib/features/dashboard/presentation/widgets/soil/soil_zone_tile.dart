import 'package:flutter/material.dart';

import '../../../../../core/extensions/responsive_size_extension.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/app_dimensions.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/circular_gauge.dart';
import '../../../../../core/widgets/constants.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/metric_tile.dart';
import '../../../domain/entities/soil_reading.dart';

class SoilZoneTile extends StatelessWidget {
  final SoilReading reading;

  const SoilZoneTile({super.key, required this.reading});

  @override
  Widget build(BuildContext context) {
    return MetricTile(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.s8.w, vertical: AppDimensions.s14.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(reading.icon, color: reading.gaugeColor, size: 26.r),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: reading.depth.label,
                style: AppTextStyles.tileLabel,
                maxLines: 1,
                textAlign: TextAlign.center,
                autoManageSize: true,
                minFontSize: 9,
              ),
              HeightBox(height: AppDimensions.s2.h),
              CustomText(
                text: reading.depth.depthLabel,
                style: AppTextStyles.tileSubLabel,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          CircularGauge(
            value: reading.fraction,
            size: AppDimensions.zoneGaugeSize.r,
            strokeWidth: AppDimensions.zoneGaugeStroke.r,
            progressColor: reading.gaugeColor,
            center: CustomText(
              text: Formatters.percent(reading.moisturePercent, decimals: 0),
              style: AppTextStyles.gaugeValue,
              maxLines: 1,
              textAlign: TextAlign.center,
              autoManageSize: true,
              minFontSize: 11,
            ),
          ),
          CustomText(
            text: AppStrings.moistureLevel,
            style: AppTextStyles.captionLabel,
            maxLines: 1,
            textAlign: TextAlign.center,
            autoManageSize: true,
            minFontSize: 8,
          ),
        ],
      ),
    );
  }
}
