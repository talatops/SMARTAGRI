import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/extensions/responsive_extension.dart';
import '../../../../../core/extensions/responsive_size_extension.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_dimensions.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/widgets/app_action_button.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/constants.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/labeled_value.dart';
import '../../../../../core/widgets/shimmer.dart';
import '../../../../../core/widgets/vertical_divider_line.dart';
import '../../notifier/dashboard_notifier.dart';
import 'weather_illustration.dart';

class WeatherStatusPanel extends StatelessWidget {
  const WeatherStatusPanel({super.key});

  Widget _maybeExpand(BuildContext context, Widget child) =>
      context.isMobileLayout ? child : Expanded(child: Center(child: child));

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: AppStrings.weatherTitle,
      subtitle: AppStrings.weatherSubtitle,
      icon: AppAssets.weatherPanel,
      iconColor: AppColors.cyan,
      child: Consumer(builder: (context, ref, _) {
        final (placeholder, issue, temperature, condition, icon, rainChance, wind, humidity) =
            ref.watch(
              dashboardProvider.select(
                (state) => (
                  state.showWeatherPlaceholder,
                  state.weatherLocationIssue,
                  state.weatherTemperatureLabel,
                  state.weatherConditionLabel,
                  state.weatherIcon,
                  state.weatherRainChanceLabel,
                  state.weatherWindLabel,
                  state.weatherHumidityLabel,
                ),
              ),
            );
        if (!placeholder && issue != null) {
          return _LocationPrompt();
        }
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
                            text: temperature,
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
                            text: condition,
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
                    icon: icon,
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
                      value: rainChance,
                      label: AppStrings.rainForecast,
                      valuePlaceholder: valuePlaceholder,
                    ),
                  ),
                  const VerticalDividerLine(height: 36),
                  Expanded(
                    child: LabeledValue(
                      icon: AppAssets.wind,
                      iconColor: AppColors.textSecondary,
                      value: wind,
                      label: AppStrings.windSpeed,
                      valuePlaceholder: valuePlaceholder,
                    ),
                  ),
                  const VerticalDividerLine(height: 36),
                  Expanded(
                    child: LabeledValue(
                      icon: AppAssets.droplet,
                      iconColor: AppColors.cyan,
                      value: humidity,
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

class _LocationPrompt extends ConsumerWidget {
  const _LocationPrompt();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (message, actionLabel) = ref.watch(
      dashboardProvider.select((state) => (state.locationIssueMessage, state.locationActionLabel)),
    );

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimensions.s16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppAssets.locationOff,
              size: AppDimensions.locationPromptIcon.r,
              color: AppColors.textTertiary,
            ),
            HeightBox(height: AppDimensions.s12.h),
            CustomText(
              text: message,
              style: AppTextStyles.bodyText,
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            HeightBox(height: AppDimensions.s16.h),
            AppActionButton(
              label: actionLabel,
              icon: AppAssets.locationPin,
              onTap: () => ref.read(dashboardProvider.notifier).resolveLocationIssue(),
            ),
          ],
        ),
      ),
    );
  }
}
