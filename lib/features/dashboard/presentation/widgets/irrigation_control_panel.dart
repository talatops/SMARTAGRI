import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/responsive_size_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_dimensions.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/constants.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../../../core/widgets/glow_icon_button.dart';
import '../../../../core/widgets/metric_tile.dart';
import '../../../../core/widgets/segmented_toggle.dart';
import '../controller/dashboard_controller.dart';

class IrrigationControlPanel extends StatelessWidget {
  final DashboardController controller;

  const IrrigationControlPanel({super.key, required this.controller});

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
          Obx(
            () => SegmentedToggle<PumpMode>(
              segments: const [
                SegmentItem(value: PumpMode.auto, label: AppStrings.auto),
                SegmentItem(value: PumpMode.manual, label: AppStrings.manual),
              ],
              value: controller.pumpMode.value,
              onChanged: controller.setPumpMode,
            ),
          ),
          HeightBox(height: AppDimensions.s16.h),
          if (context.isMobileLayout)
            _PumpRow(controller: controller)
          else
            Expanded(child: _PumpRow(controller: controller)),
        ],
      ),
    );
  }
}

class _PumpRow extends StatelessWidget {
  final DashboardController controller;

  const _PumpRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    final buttonSize = context.adaptive<double>(
      mobile: AppDimensions.pumpButtonSizeMobile,
      tablet: 132,
      desktop: AppDimensions.pumpButtonSize,
    );

    final button = Obx(
      () => GlowIconButton(
        icon: AppAssets.power,
        label: controller.pumpButtonLabel,
        isActive: controller.isPumpCommandOn.value,
        size: buttonSize,
        onTap: controller.isPumpControlEnabled ? controller.togglePump : null,
      ),
    );

    final status = _PumpStatusBlock(controller: controller);

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
  final DashboardController controller;

  const _PumpStatusBlock({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isOn = controller.isPumpOn.value;
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
                    color: isOn ? AppColors.success : AppColors.successBright,
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
              text: controller.pumpStatusLabel,
              style: AppTextStyles.statusValue,
              fontColor: isOn ? AppColors.success : AppColors.textPrimary,
              maxLines: 1,
              autoManageSize: true,
              minFontSize: 16,
            ),
            HeightBox(height: AppDimensions.s6.h),
            CustomText(
              text: controller.pumpStatusDescription,
              style: AppTextStyles.captionLabel,
              maxLines: 2,
            ),
          ],
        ),
      );
    });
  }
}
