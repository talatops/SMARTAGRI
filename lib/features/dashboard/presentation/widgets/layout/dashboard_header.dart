import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
import '../../controller/dashboard_controller.dart';

class DashboardHeader extends StatelessWidget {
  final DashboardController controller;

  const DashboardHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final brand = _Brand();
    final meta = _Meta(controller: controller);

    if (context.isMobileLayout) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          brand,
          HeightBox(height: AppDimensions.s10.h),
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
        ] else
          const Spacer(),
        meta,
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
  final DashboardController controller;

  const _Meta({required this.controller});

  @override
  Widget build(BuildContext context) {
    Widget item(IconData icon, String text) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16.r, color: AppColors.primaryBlue),
        WidthBox(width: AppDimensions.s8.w),
        CustomText(text: text, style: AppTextStyles.headerMeta, maxLines: 1),
      ],
    );

    Widget locationItem() {
      if (!controller.showLocationPlaceholder) {
        return item(AppAssets.locationPin, controller.locationLabel);
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

    return Obx(() {
      final now = controller.now.value;

      return Wrap(
        spacing: AppDimensions.s12.w,
        runSpacing: AppDimensions.s8.h,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          item(AppAssets.calendar, Formatters.date(now)),
          const VerticalDividerLine(height: 20),
          item(AppAssets.clock, Formatters.time(now)),
          const VerticalDividerLine(height: 20),
          locationItem(),
        ],
      );
    });
  }
}
