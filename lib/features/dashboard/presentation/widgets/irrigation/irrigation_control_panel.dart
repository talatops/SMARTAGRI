import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/extensions/responsive_extension.dart';
import '../../../../../core/extensions/responsive_size_extension.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_dimensions.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/constants.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/glow_icon_button.dart';
import '../../../../../core/widgets/metric_tile.dart';
import '../../../../../core/widgets/segmented_toggle.dart';
import '../../notifier/dashboard_notifier.dart';

class IrrigationControlPanel extends StatelessWidget {
  const IrrigationControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: AppStrings.irrigationTitle,
      subtitle: AppStrings.irrigationSubtitle,
      icon: AppAssets.irrigationPanel,
      iconColor: AppColors.textSecondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Consumer(
            builder: (context, ref, _) => SegmentedToggle<PumpMode>(
              segments: const [
                SegmentItem(value: PumpMode.auto, label: AppStrings.auto),
                SegmentItem(value: PumpMode.manual, label: AppStrings.manual),
              ],
              value: ref.watch(dashboardProvider.select((state) => state.pumpMode)),
              onChanged: (mode) => ref.read(dashboardProvider.notifier).setPumpMode(mode),
            ),
          ),
          HeightBox(height: AppDimensions.s16.h),
          if (context.isMobileLayout)
            _PumpRow()
          else
            Expanded(child: _PumpRow()),
          HeightBox(height: AppDimensions.s14.h),
          const _PredictionTile(),
        ],
      ),
    );
  }
}

class _PumpRow extends StatelessWidget {
  const _PumpRow();

  @override
  Widget build(BuildContext context) {
    final buttonSize = context.adaptive<double>(
      mobile: AppDimensions.pumpButtonSizeMobile,
      tablet: 132,
      desktop: AppDimensions.pumpButtonSize,
    );

    final button = Consumer(builder: (context, ref, _) {
      final (label, isCommandOn, isEnabled) = ref.watch(
        dashboardProvider.select(
          (state) => (state.pumpButtonLabel, state.isPumpCommandOn, state.isPumpControlEnabled),
        ),
      );
      return GlowIconButton(
        icon: AppAssets.power,
        label: label,
        isActive: isCommandOn,
        size: buttonSize,
        onTap: isEnabled ? () => ref.read(dashboardProvider.notifier).togglePump() : null,
      );
    });

    final status = _PumpStatusBlock();

    return Center(
      child: context.isMobileLayout
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                button,
                HeightBox(height: AppDimensions.s14.h),
                status,
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                button,
                WidthBox(width: AppDimensions.s14.w),
                Expanded(child: status),
              ],
            ),
    );
  }
}

class _PumpStatusBlock extends StatelessWidget {
  const _PumpStatusBlock();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final (isOn, statusLabel, statusDescription) = ref.watch(
        dashboardProvider.select(
          (state) => (state.isPumpOn, state.pumpStatusLabel, state.pumpStatusDescription),
        ),
      );
      return MetricTile(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.s14.w,
          vertical: AppDimensions.s16.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 9.r,
                  height: 9.r,
                  decoration: BoxDecoration(
                    color: isOn ? AppColors.success : AppColors.textTertiary,
                    shape: BoxShape.circle,
                  ),
                ),
                WidthBox(width: AppDimensions.s8.w),
                Flexible(
                  child: CustomText(
                    text: AppStrings.statusLabel,
                    style: AppTextStyles.captionLabel,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            HeightBox(height: AppDimensions.s4.h),
            CustomText(
              text: statusLabel,
              style: AppTextStyles.statusValue,
              fontColor: isOn ? AppColors.success : AppColors.textPrimary,
              maxLines: 1,
              autoManageSize: true,
              minFontSize: 16,
            ),
            HeightBox(height: AppDimensions.s6.h),
            CustomText(
              text: statusDescription,
              style: AppTextStyles.captionLabel,
              maxLines: 2,
            ),
          ],
        ),
      );
    });
  }
}

class _PredictionTile extends StatelessWidget {
  const _PredictionTile();

  @override
  Widget build(BuildContext context) {
    return MetricTile(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.s14.w,
        vertical: AppDimensions.s10.h,
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AppAssets.aiPredictionSvg,
            width: 22.r,
            height: 22.r,
            colorFilter: const ColorFilter.mode(AppColors.primaryBlue, BlendMode.srcIn),
          ),
          WidthBox(width: AppDimensions.s12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  text: AppStrings.aiPrediction,
                  style: AppTextStyles.tileSubLabel,
                  letterSpacing: 0.6,
                  maxLines: 1,
                ),
                HeightBox(height: AppDimensions.s4.h),
                Consumer(builder: (context, ref, _) {
                  final (label, need) = ref.watch(
                    dashboardProvider.select(
                      (state) => (state.irrigationNeedLabel, state.irrigationNeed),
                    ),
                  );
                  return Row(
                    children: [
                      CustomText(
                        text: AppStrings.irrigationNeedLabel,
                        style: AppTextStyles.tileLabel,
                        maxLines: 1,
                      ),
                      WidthBox(width: AppDimensions.s6.w),
                      Flexible(
                        child: CustomText(
                          text: label,
                          style: AppTextStyles.pillLabelLarge,
                          fontColor: need.color,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
