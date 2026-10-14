import 'package:flutter/material.dart';

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
import '../../../domain/entities/sensor_history.dart';
import 'history_line_chart.dart';

class HistoryChartPanel extends StatelessWidget {
  final HistoryChart chart;
  final SensorHistory history;
  final int currentHour;
  final HistoryRange range;
  final ValueChanged<HistoryRange> onRangeSelected;

  const HistoryChartPanel({
    super.key,
    required this.chart,
    required this.history,
    required this.currentHour,
    required this.range,
    required this.onRangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final chartHeight = chart.isPump
        ? AppDimensions.historyPumpChartHeight.h
        : context.adaptive(
            mobile: AppDimensions.historyChartHeightMobile.h,
            desktop: AppDimensions.historyChartHeight.h,
          );
    final lineChart = SizedBox(
      height: chartHeight,
      child: HistoryLineChart(
        chart: chart,
        history: history,
        range: range,
        hours: range.hoursEndingAt(currentHour),
      ),
    );
    final legend = _Legend(series: chart.series);
    final rangeMenu = _RangeMenu(selected: range, onSelected: onRangeSelected);
    final isMobile = context.isMobileLayout;

    return AppCard(
      title: chart.title,
      subtitle: chart.subtitle,
      icon: chart.icon,
      iconColor: AppColors.primaryBlue,
      expandChild: false,
      trailing: isMobile ? null : rangeMenu,
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(alignment: Alignment.centerLeft, child: rangeMenu),
                HeightBox(height: AppDimensions.s12.h),
                lineChart,
                HeightBox(height: AppDimensions.s12.h),
                legend,
              ],
            )
          : Row(
              children: [
                Expanded(child: lineChart),
                WidthBox(width: AppDimensions.s16.w),
                SizedBox(width: AppDimensions.historyLegendWidth.w, child: legend),
              ],
            ),
    );
  }
}

class _Legend extends StatelessWidget {
  final List<HistorySeries> series;

  const _Legend({required this.series});

  @override
  Widget build(BuildContext context) {
    final items = [for (final item in series) _LegendItem(series: item)];

    if (context.isMobileLayout) {
      return Wrap(
        spacing: AppDimensions.s16.w,
        runSpacing: AppDimensions.s8.h,
        children: items,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) HeightBox(height: AppDimensions.s12.h),
          items[i],
        ],
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final HistorySeries series;

  const _LegendItem({required this.series});

  @override
  Widget build(BuildContext context) {
    final dotSize = AppDimensions.historyLegendDotSize.r;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: AppDimensions.historyLegendMarkerWidth.w,
          height: dotSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(height: AppDimensions.historyLineWidth, color: series.color),
              Container(
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(color: series.color, shape: BoxShape.circle),
              ),
            ],
          ),
        ),
        WidthBox(width: AppDimensions.s8.w),
        Flexible(
          child: CustomText(text: series.label, style: AppTextStyles.chartLegend, maxLines: 2),
        ),
      ],
    );
  }
}

class _RangeMenu extends StatelessWidget {
  final HistoryRange selected;
  final ValueChanged<HistoryRange> onSelected;

  const _RangeMenu({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppDimensions.tileRadius.r);

    return PopupMenuButton<HistoryRange>(
      initialValue: selected,
      onSelected: onSelected,
      tooltip: AppStrings.historyRangeTooltip,
      position: PopupMenuPosition.under,
      color: AppColors.cardBgElevated,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: const BorderSide(color: AppColors.cardBorder, width: AppDimensions.borderWidth),
      ),
      itemBuilder: (_) => [
        for (final range in HistoryRange.values)
          PopupMenuItem(
            value: range,
            height: AppDimensions.historyRangeOptionHeight.h,
            child: _RangeOption(range: range, isSelected: range == selected),
          ),
      ],
      child: _RangeBadge(label: selected.label),
    );
  }
}

class _RangeBadge extends StatelessWidget {
  final String label;

  const _RangeBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.historyRangeBadgeHeight.h,
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.s12.w),
      decoration: BoxDecoration(
        color: AppColors.tileBg,
        borderRadius: BorderRadius.circular(AppDimensions.tileRadius.r),
        border: Border.all(color: AppColors.tileBorder, width: AppDimensions.borderWidth),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(AppAssets.calendar, size: AppDimensions.s14.r, color: AppColors.textSecondary),
          WidthBox(width: AppDimensions.s6.w),
          CustomText(
            text: label,
            style: AppTextStyles.captionLabel,
            fontColor: AppColors.textPrimary,
            maxLines: 1,
          ),
          WidthBox(width: AppDimensions.s4.w),
          Icon(AppAssets.dropdownArrow, size: AppDimensions.s16.r, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _RangeOption extends StatelessWidget {
  final HistoryRange range;
  final bool isSelected;

  const _RangeOption({required this.range, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primaryBlue : AppColors.textPrimary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          text: range.label,
          style: AppTextStyles.captionLabel,
          fontColor: color,
          maxLines: 1,
        ),
        WidthBox(width: AppDimensions.s12.w),
        Opacity(
          opacity: isSelected ? 1 : 0,
          child: Icon(AppAssets.check, size: AppDimensions.s16.r, color: color),
        ),
      ],
    );
  }
}
