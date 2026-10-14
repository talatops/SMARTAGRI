import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/extensions/responsive_extension.dart';
import '../../../../../core/extensions/responsive_size_extension.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_dimensions.dart';
import '../../../../../core/utils/app_durations.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/constants.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/hover_region.dart';
import '../../notifier/dashboard_notifier.dart';

class DashboardFooter extends StatelessWidget {
  const DashboardFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final left = _LastUpdated();
    final right = const _Branding();

    return Column(
      children: [
        const Divider(color: AppColors.divider, height: 1),
        HeightBox(height: AppDimensions.s14.h),
        if (context.isMobileLayout)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              left,
              HeightBox(height: AppDimensions.s8.h),
              right,
            ],
          )
        else
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [left, right]),
        HeightBox(height: AppDimensions.s8.h),
      ],
    );
  }
}

class _LastUpdated extends StatelessWidget {
  const _LastUpdated();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final (updated, spinning) = ref.watch(
        dashboardProvider.select((state) => (state.lastUpdated, state.isRefreshing)),
      );

      return HoverRegion(
        onTap: () => ref.read(dashboardProvider.notifier).loadDashboard(isRefresh: true),
        builder: (context, hovered) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Tooltip(
              message: AppStrings.refreshTooltip,
              child: AnimatedRotation(
                turns: spinning ? 1 : 0,
                duration: AppDurations.slow,
                child: Icon(
                  AppAssets.refresh,
                  size: 18.r,
                  color: hovered ? AppColors.success : AppColors.successBright,
                ),
              ),
            ),
            WidthBox(width: AppDimensions.s8.w),
            CustomText(
              text:
                  AppStrings.lastUpdated +
                  (updated == null ? '--' : Formatters.timeWithSeconds(updated)),
              style: AppTextStyles.footerText,
              fontColor: hovered ? AppColors.textSecondary : AppColors.textTertiary,
              maxLines: 1,
            ),
          ],
        ),
      );
    });
  }
}

class _Branding extends StatelessWidget {
  const _Branding();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(AppAssets.logo, size: 16.r, color: AppColors.success),
        WidthBox(width: AppDimensions.s8.w),
        CustomText(text: AppStrings.poweredBy, style: AppTextStyles.footerText, maxLines: 1),
        WidthBox(width: AppDimensions.s10.w),
        CustomText(text: AppStrings.appVersion, style: AppTextStyles.footerText, maxLines: 1),
      ],
    );
  }
}
