import 'package:flutter/material.dart';

import '../extensions/responsive_size_extension.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_colors.dart';
import '../utils/app_dimensions.dart';
import '../utils/app_durations.dart';
import 'constants.dart';
import 'custom_text.dart';
import 'hover_region.dart';

class AppActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color color;

  const AppActionButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.color = AppColors.cyan,
  });

  @override
  Widget build(BuildContext context) {
    final height = AppDimensions.actionButtonHeight.h;

    return HoverRegion(
      onTap: onTap,
      builder: (context, hovered) => AnimatedContainer(
        duration: AppDurations.fast,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.s16.w),
        decoration: BoxDecoration(
          color: hovered ? AppColors.pillBorder(color) : AppColors.pillFill(color),
          borderRadius: BorderRadius.circular(height / 2),
          border: Border.all(color: AppColors.pillBorder(color), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: AppDimensions.actionButtonIcon.r, color: color),
              WidthBox(width: AppDimensions.s8.w),
            ],
            Flexible(
              child: CustomText(
                text: label,
                style: AppTextStyles.pillLabelLarge,
                fontColor: color,
                maxLines: 1,
                autoManageSize: true,
                minFontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
