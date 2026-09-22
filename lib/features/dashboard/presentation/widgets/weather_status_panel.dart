import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/responsive_size_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_dimensions.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/constants.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../../../core/widgets/labeled_value.dart';
import '../../../../core/widgets/shimmer.dart';
import '../../../../core/widgets/vertical_divider_line.dart';
import '../controller/dashboard_controller.dart';
import 'weather_illustration.dart';

class WeatherStatusPanel extends StatelessWidget {
  final DashboardController controller;

  const WeatherStatusPanel({super.key, required this.controller});

  Widget _maybeExpand(BuildContext context, Widget child) =>
      context.isMobileLayout ? child : Expanded(child: Center(child: child));

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: AppStrings.weatherTitle,
      subtitle: AppStrings.weatherSubtitle,
      icon: AppAssets.weatherPanel,
      iconColor: AppColors.cyan,
      child: Obx(() {
        final placeholder = controller.showWeatherPlaceholder;
        final valuePlaceholder = placeholder
            ? ShimmerBox(
                width: AppDimensions.skeletonWeatherValueWidth.w,
                height: AppDimensions.skeletonWeatherValueHeight.h,
              )
            : null;

        final content = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: context.isMobileLayout ? MainAxisSize.min : MainAxisSize.max,
          children: [
            _maybeExpand(
              context,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (placeholder)
                          ShimmerBox(
                            width: AppDimensions.skeletonWeatherTempWidth.w,
                            height: AppDimensions.skeletonWeatherTempHeight.h,
                          )
                        else
                          CustomText(
                            text: controller.weatherTemperatureLabel,
                            style: AppTextStyles.metricValueXL,
                            maxLines: 1,
                            autoManageSize: true,
                            minFontSize: 20,
                          ),
                        HeightBox(height: AppDimensions.s4.h),
                        if (placeholder)
                          ShimmerBox(
                            width: AppDimensions.skeletonWeatherConditionWidth.w,
                            height: AppDimensions.skeletonWeatherValueHeight.h,
                          )
                        else
                          CustomText(
                            text: controller.weatherConditionLabel,
                            style: AppTextStyles.tileLabel,
                            fontSize: 15,
                            fontColor: AppColors.cyan,
                            maxLines: 1,
                            autoManageSize: true,
                            minFontSize: 11,
                          ),
                      ],
                    ),
                  ),
                  WeatherIllustration(
                    size: context.adaptive<double>(mobile: 78, tablet: 80, desktop: 96),
                  ),
                ],
              ),
            ),
            HeightBox(height: AppDimensions.s12.h),
            const Divider(color: AppColors.divider, height: 1),
            HeightBox(height: AppDimensions.s14.h),
            SizedBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: LabeledValue(
                      icon: AppAssets.droplet,
                      iconColor: AppColors.cyan,
                      value: controller.weatherRainChanceLabel,
                      label: AppStrings.rainForecast,
                      valuePlaceholder: valuePlaceholder,
                    ),
                  ),
                  const VerticalDividerLine(height: 36),
                  Expanded(
                    child: LabeledValue(
                      icon: AppAssets.wind,
                      iconColor: AppColors.textSecondary,
                      value: controller.weatherWindLabel,
                      label: AppStrings.windSpeed,
                      valuePlaceholder: valuePlaceholder,
                    ),
                  ),
                  const VerticalDividerLine(height: 36),
                  Expanded(
                    child: LabeledValue(
                      icon: AppAssets.droplet,
                      iconColor: AppColors.cyan,
                      value: controller.weatherHumidityLabel,
                      label: AppStrings.humidity,
                      valuePlaceholder: valuePlaceholder,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

        return placeholder ? Shimmer(child: content) : content;
      }),
    );
  }
}
