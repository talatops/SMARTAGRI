import 'package:flutter/material.dart';

import '../extensions/responsive_size_extension.dart';
import '../utils/app_colors.dart';
import '../utils/app_dimensions.dart';

class MetricTile extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? background;
  final Color? borderColor;
  final CrossAxisAlignment crossAxisAlignment;

  const MetricTile({
    super.key,
    required this.child,
    this.padding,
    this.background,
    this.borderColor,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(AppDimensions.tilePadding.w),
      decoration: BoxDecoration(
        color: background ?? AppColors.tileBg,
        borderRadius: BorderRadius.circular(AppDimensions.tileRadius.r),
        border: Border.all(
          color: borderColor ?? AppColors.tileBorder,
          width: AppDimensions.borderWidth,
        ),
      ),
      child: child,
    );
  }
}
