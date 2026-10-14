import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/extensions/responsive_extension.dart';
import '../../../../../core/extensions/responsive_size_extension.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_dimensions.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/circular_gauge.dart';
import '../../../../../core/widgets/constants.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/status_pill.dart';
import '../../notifier/dashboard_notifier.dart';
import 'wave_background.dart';

class CompositeMoisturePanel extends StatelessWidget {
  const CompositeMoisturePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: AppStrings.compositeTitle,
      subtitle: AppStrings.compositeSubtitle,
      icon: AppAssets.compositePanel,
      iconColor: AppColors.cyan,
      backgroundLayer: Align(
        alignment: Alignment.bottomCenter,
        child: WaveBackground(height: 86.h),
      ),
      child: context.isMobileLayout
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Gauge(),
                HeightBox(height: AppDimensions.s16.h),
                _Verdict(),
              ],
            )
          : Row(
              children: [
                _Gauge(),
                WidthBox(width: AppDimensions.s20.w),
                Expanded(child: _Verdict()),
              ],
            ),
    );
  }
}

class _Gauge extends StatelessWidget {
  const _Gauge();

  @override
  Widget build(BuildContext context) {
    final size = context.adaptive<double>(
      mobile: 170,
      tablet: 168,
      desktop: AppDimensions.compositeGaugeSize,
    );

    return Consumer(builder: (context, ref, _) {
      final (fraction, score) = ref.watch(
        dashboardProvider.select(
          (state) => (state.snapshot?.composite.fraction, state.compositeScore),
        ),
      );
      return CircularGauge(
        value: fraction ?? 0,
        size: size.r,
        strokeWidth: AppDimensions.compositeGaugeStroke.r,
        startAngle: 100,
        sweepAngle: 340,
        gradientColors: AppColors.compositeGaugeColors,
        gradientStops: const [0.0, 0.35, 0.58, 1.0],
        center: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: Formatters.percent(score),
              style: AppTextStyles.gaugeValueXL,
              maxLines: 1,
              textAlign: TextAlign.center,
              autoManageSize: true,
              minFontSize: 18,
            ),
            CustomText(
              text: AppStrings.compositeScore,
              style: AppTextStyles.captionLabel,
              maxLines: 1,
              textAlign: TextAlign.center,
              autoManageSize: true,
              minFontSize: 8,
            ),
          ],
        ),
      );
    });
  }
}

class _Verdict extends StatelessWidget {
  const _Verdict();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final (status, headline, description) = ref.watch(
        dashboardProvider.select(
          (state) => (state.compositeStatus, state.compositeHeadline, state.compositeDescription),
        ),
      );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          StatusPill.fromStatus(
            status,
            label: headline,
            icon: AppAssets.logo,
            large: true,
          ),
          HeightBox(height: AppDimensions.s14.h),
          CustomText(
            text: description,
            style: AppTextStyles.bodyText,
            maxLines: 4,
          ),
        ],
      );
    });
  }
}
