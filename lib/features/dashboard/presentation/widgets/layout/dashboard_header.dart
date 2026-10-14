import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/extensions/responsive_extension.dart';
import '../../../../../core/extensions/responsive_size_extension.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_dimensions.dart';
import '../../../../../core/utils/app_fonts.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/constants.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/shimmer.dart';
import '../../../../../core/widgets/vertical_divider_line.dart';
import '../../notifier/dashboard_notifier.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = _Brand();
    final meta = _Meta(
      fitWidth: context.isTabletLayout,
      stacked: context.isMobileLayout,
    );

    if (context.isMobileLayout) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          brand,
          HeightBox(height: AppDimensions.s12.h),
          meta,
        ],
      );
    }

    return Row(
      children: [
        brand,
        if (context.isDesktopLayout) ...[
          WidthBox(width: AppDimensions.s20.w),
          const VerticalDividerLine(height: 30),
          WidthBox(width: AppDimensions.s20.w),
          const Expanded(child: _Tagline()),
          meta,
        ] else ...[
          WidthBox(width: AppDimensions.s20.w),
          Expanded(
            child: Align(alignment: Alignment.centerRight, child: meta),
          ),
        ],
      ],
    );
  }
}

class _Brand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(AppAssets.logo, color: AppColors.success, size: 32.r),
        WidthBox(width: AppDimensions.s10.w),
        Builder(
          builder: (context) {
            final base = AppTextStyles.appTitle.copyWith(
              fontFamily: AppFonts.primary,
              fontSize: AppTextStyles.appTitle.fontSize!.sp,
            );
            return RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: base,
                children: [
                  TextSpan(text: '${AppStrings.appNamePrefix} '),
                  TextSpan(
                    text: AppStrings.appNameSuffix,
                    style: base.copyWith(color: AppColors.success),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _Tagline extends StatelessWidget {
  const _Tagline();

  @override
  Widget build(BuildContext context) {
    Widget dot() => Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.s10.w),
      child: Container(
        width: 4.r,
        height: 4.r,
        decoration: const BoxDecoration(color: AppColors.textTertiary, shape: BoxShape.circle),
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(text: AppStrings.tagline1, style: AppTextStyles.tagline, maxLines: 1),
        dot(),
        CustomText(text: AppStrings.tagline2, style: AppTextStyles.tagline, maxLines: 1),
        dot(),
        CustomText(text: AppStrings.tagline3, style: AppTextStyles.tagline, maxLines: 1),
      ],
    );
  }
}

class _Meta extends StatelessWidget {
  final bool fitWidth;
  final bool stacked;

  const _Meta({this.fitWidth = false, this.stacked = false});

  @override
  Widget build(BuildContext context) {
    Widget item(IconData icon, String text, {bool shrink = false}) {
      final label = CustomText(
        text: text,
        style: AppTextStyles.headerMeta,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.r, color: AppColors.primaryBlue),
          WidthBox(width: AppDimensions.s8.w),
          if (shrink) Flexible(child: label) else label,
        ],
      );
    }

    Widget locationItem(bool showPlaceholder, String locationLabel) {
      if (!showPlaceholder) {
        return item(AppAssets.locationPin, locationLabel, shrink: fitWidth || stacked);
      }

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(AppAssets.locationPin, size: 16.r, color: AppColors.primaryBlue),
          WidthBox(width: AppDimensions.s8.w),
          Shimmer(
            child: ShimmerBox(
              width: AppDimensions.skeletonLocationWidth.w,
              height: AppDimensions.skeletonLocationHeight.h,
            ),
          ),
        ],
      );
    }

    return Consumer(builder: (context, ref, _) {
      final (now, showPlaceholder, locationLabel) = ref.watch(
        dashboardProvider.select(
          (state) => (state.now, state.showLocationPlaceholder, state.locationLabel),
        ),
      );

      if (stacked) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                item(AppAssets.calendar, Formatters.date(now)),
                WidthBox(width: AppDimensions.s12.w),
                const VerticalDividerLine(height: 16),
                WidthBox(width: AppDimensions.s12.w),
                item(AppAssets.clock, Formatters.time(now)),
              ],
            ),
            HeightBox(height: AppDimensions.s8.h),
            locationItem(showPlaceholder, locationLabel),
          ],
        );
      }

      if (fitWidth) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            item(AppAssets.calendar, Formatters.date(now)),
            WidthBox(width: AppDimensions.s12.w),
            const VerticalDividerLine(height: 20),
            WidthBox(width: AppDimensions.s12.w),
            item(AppAssets.clock, Formatters.time(now)),
            WidthBox(width: AppDimensions.s12.w),
            const VerticalDividerLine(height: 20),
            WidthBox(width: AppDimensions.s12.w),
            Flexible(child: locationItem(showPlaceholder, locationLabel)),
          ],
        );
      }

      return Wrap(
        spacing: AppDimensions.s12.w,
        runSpacing: AppDimensions.s8.h,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          item(AppAssets.calendar, Formatters.date(now)),
          const VerticalDividerLine(height: 20),
          item(AppAssets.clock, Formatters.time(now)),
          const VerticalDividerLine(height: 20),
          locationItem(showPlaceholder, locationLabel),
        ],
      );
    });
  }
}
