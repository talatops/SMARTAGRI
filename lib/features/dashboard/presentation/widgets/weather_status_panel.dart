import 'package:flutter/material.dart';

import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/responsive_size_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_dimensions.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/constants.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../../../core/widgets/labeled_value.dart';
import '../../../../core/widgets/vertical_divider_line.dart';
import '../../domain/entities/weather_snapshot.dart';
import 'weather_illustration.dart';

class WeatherStatusPanel extends StatelessWidget {
  final WeatherSnapshot weather;

  const WeatherStatusPanel({super.key, required this.weather});

  Widget _maybeExpand(BuildContext context, Widget child) =>
      context.isMobileLayout ? child : Expanded(child: Center(child: child));

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: AppStrings.weatherTitle,
      subtitle: AppStrings.weatherSubtitle,
      icon: AppAssets.weatherPanel,
      iconColor: AppColors.cyan,
      child: Column(
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
                      CustomText(
                        text: Formatters.temperature(weather.temperatureC),
                        style: AppTextStyles.metricValueXL,
                        maxLines: 1,
                        autoManageSize: true,
                        minFontSize: 20,
                      ),
                      HeightBox(height: AppDimensions.s4.h),
                      CustomText(
                        text: weather.condition,
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
                    value: Formatters.percent(weather.rainChancePercent, decimals: 0),
                    label: AppStrings.rainForecast,
                  ),
                ),
                const VerticalDividerLine(height: 36),
                Expanded(
                  child: LabeledValue(
                    icon: AppAssets.wind,
                    iconColor: AppColors.textSecondary,
                    value: Formatters.speed(weather.windKmh, decimals: 0),
                    label: AppStrings.windSpeed,
                  ),
                ),
                const VerticalDividerLine(height: 36),
                Expanded(
                  child: LabeledValue(
                    icon: AppAssets.droplet,
                    iconColor: AppColors.cyan,
                    value: Formatters.percent(weather.humidityPercent, decimals: 0),
                    label: AppStrings.humidity,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
