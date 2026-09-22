import 'package:flutter/material.dart';

import '../extensions/responsive_size_extension.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_colors.dart';
import '../utils/app_dimensions.dart';
import '../utils/enums.dart';
import 'constants.dart';
import 'custom_text.dart';

enum PillVariant { success, warning, danger, info, neutral }

class StatusPill extends StatelessWidget {
  final String label;
  final PillVariant variant;
  final IconData? icon;
  final bool large;

  const StatusPill({
    super.key,
    required this.label,
    this.variant = PillVariant.success,
    this.icon,
    this.large = false,
  });

  factory StatusPill.fromStatus(
    MetricStatus status, {
    String? label,
    IconData? icon,
    bool large = false,
  }) {
    return StatusPill(
      label: label ?? status.label,
      variant: switch (status) {
        MetricStatus.normal => PillVariant.success,
        MetricStatus.warning => PillVariant.warning,
        MetricStatus.critical => PillVariant.danger,
      },
      icon: icon,
      large: large,
    );
  }

  Color get _color => switch (variant) {
    PillVariant.success => AppColors.success,
    PillVariant.warning => AppColors.amber,
    PillVariant.danger => AppColors.danger,
    PillVariant.info => AppColors.primaryBlue,
    PillVariant.neutral => AppColors.textSecondary,
  };

  @override
  Widget build(BuildContext context) {
    final color = _color;
    final height = (large ? 40.0 : 28.0).h;
    final dotSize = (large ? 10.0 : 8.0).r;
    final iconSize = (large ? 20.0 : 14.0).r;

    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: (large ? 14.0 : 10.0).w),
      decoration: BoxDecoration(
        color: AppColors.pillFill(color),
        borderRadius: BorderRadius.circular(height / 2),
        border: Border.all(color: AppColors.pillBorder(color), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(icon, size: iconSize, color: color)
          else
            Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          WidthBox(width: AppDimensions.s6.w),
          Flexible(
            child: CustomText(
              text: label,
              style: large ? AppTextStyles.pillLabelLarge : AppTextStyles.pillLabel,
              fontColor: color,
              maxLines: 1,
              autoManageSize: true,
              minFontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}
