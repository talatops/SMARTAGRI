import 'package:flutter/material.dart';

import '../../../../../core/extensions/responsive_size_extension.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_dimensions.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/metric_tile.dart';
import '../../../../../core/widgets/status_pill.dart';
import '../../../domain/entities/field_water_level.dart';

class FieldWaterTile extends StatelessWidget {
  final FieldWaterLevel waterLevel;

  const FieldWaterTile({super.key, required this.waterLevel});

  @override
  Widget build(BuildContext context) {
    return MetricTile(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.s8.w, vertical: AppDimensions.s14.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(AppAssets.droplet, color: AppColors.cyan, size: 30.r),
          CustomText(
            text: AppStrings.fieldWaterLevel,
            style: AppTextStyles.tileLabel,
            fontSize: 13.5,
            maxLines: 1,
            textAlign: TextAlign.center,
            autoManageSize: true,
            minFontSize: 9,
          ),
          CustomText(
            text: Formatters.centimeters(waterLevel.centimeters, decimals: 0),
            style: AppTextStyles.metricValueL,
            maxLines: 1,
            textAlign: TextAlign.center,
            autoManageSize: true,
            minFontSize: 16,
          ),
          StatusPill.fromStatus(
            waterLevel.status,
            label: AppStrings.normalOk,
            icon: AppAssets.checkCircle,
          ),
          CustomText(
            text: AppStrings.waterLevel,
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
