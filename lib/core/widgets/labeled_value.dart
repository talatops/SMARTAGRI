import 'package:flutter/material.dart';

import '../extensions/responsive_size_extension.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_colors.dart';
import '../utils/app_dimensions.dart';
import 'constants.dart';
import 'custom_text.dart';

class LabeledValue extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const LabeledValue({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 20.r),
        HeightBox(height: AppDimensions.s6.h),
        CustomText(
          text: value,
          style: AppTextStyles.tileLabel,
          fontSize: 15,
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
        HeightBox(height: AppDimensions.s2.h),
        CustomText(
          text: label,
          style: AppTextStyles.captionLabel,
          fontColor: AppColors.textSecondary,
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
