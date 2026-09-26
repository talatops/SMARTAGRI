import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../../core/extensions/responsive_extension.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_dimensions.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../domain/entities/sensor_history.dart';

class HistoryLineChart extends StatelessWidget {
  final HistoryChart chart;
  final SensorHistory history;
  final HistoryRange range;
  final List<int> hours;

  const HistoryLineChart({
    super.key,
    required this.chart,
    required this.history,
    required this.range,
    required this.hours,
  });

  @override
  Widget build(BuildContext context) {
    final maxTimeLabels = context.adaptive(
      mobile: AppDimensions.historyMaxTimeLabelsMobile,
      tablet: AppDimensions.historyMaxTimeLabelsTablet,
      desktop: AppDimensions.historyMaxTimeLabelsDesktop,
    );
    final hourLabelStep = (hours.length / maxTimeLabels).ceil();

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: math.max(hours.length - 1, 1).toDouble(),
        minY: _minY,
        maxY: _maxY,
        lineBarsData: [for (final series in chart.series) _line(series)],
        gridData: _grid(),
        borderData: FlBorderData(
          border: Border.all(color: AppColors.chartGrid, width: AppDimensions.borderWidth),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          leftTitles: _valueAxis(),
          bottomTitles: _timeAxis(hourLabelStep),
        ),
        lineTouchData: _touch(),
      ),
    );
  }

  Iterable<double> _visibleValues(HistorySeries series) =>
      hours.map((hour) => history.valueAt(series, hour)).nonNulls;

  Iterable<double> get _allValues => chart.series.expand(_visibleValues);

  double get _minY {
    final lowest = _allValues.fold(chart.minY, math.min);
    if (lowest >= chart.minY) return chart.minY;
    return (lowest / chart.interval).floor() * chart.interval;
  }

  double get _maxY {
    final highest = _allValues.fold(chart.maxY, math.max);
    if (highest <= chart.maxY) return chart.maxY;
    return (highest / chart.interval).ceil() * chart.interval;
  }

  LineChartBarData _line(HistorySeries series) {
    return LineChartBarData(
      spots: [
        for (var i = 0; i < hours.length; i++)
          if (history.valueAt(series, hours[i]) case final value?) FlSpot(i.toDouble(), value),
      ],
      color: series.color,
      barWidth: AppDimensions.historyLineWidth,
      isCurved: !chart.isStepped,
      curveSmoothness: AppDimensions.historyCurveSmoothness,
      preventCurveOverShooting: true,
      isStepLineChart: chart.isStepped,
      lineChartStepData: const LineChartStepData(
        stepDirection: LineChartStepData.stepDirectionForward,
      ),
      dotData: FlDotData(
        show: !chart.isStepped,
        getDotPainter: (_, _, _, _) => FlDotCirclePainter(
          radius: AppDimensions.historyDotRadius,
          color: series.color,
          strokeWidth: 0,
        ),
      ),
      belowBarData: BarAreaData(show: chart.isStepped, color: AppColors.softTint(series.color)),
    );
  }

  FlGridData _grid() {
    FlLine gridLine(double _) =>
        const FlLine(color: AppColors.chartGrid, strokeWidth: AppDimensions.borderWidth);

    return FlGridData(
      horizontalInterval: chart.interval,
      verticalInterval: 1,
      getDrawingHorizontalLine: gridLine,
      getDrawingVerticalLine: gridLine,
    );
  }

  AxisTitles _valueAxis() {
    return AxisTitles(
      axisNameSize: AppDimensions.historyAxisNameSize,
      axisNameWidget: CustomText(
        text: chart.axisTitle,
        style: AppTextStyles.chartAxisTitle,
        maxLines: 1,
      ),
      sideTitles: SideTitles(
        showTitles: true,
        interval: chart.interval,
        reservedSize: AppDimensions.historyLeftAxisSize,
        getTitlesWidget: (value, meta) {
          if (value % chart.interval != 0) return const SizedBox.shrink();
          return SideTitleWidget(
            meta: meta,
            child: CustomText(text: chart.axisLabel(value), style: AppTextStyles.chartAxis),
          );
        },
      ),
    );
  }

  AxisTitles _timeAxis(int labelStep) {
    return AxisTitles(
      axisNameSize: AppDimensions.historyAxisNameSize,
      axisNameWidget: CustomText(
        text: range.axisTitle,
        style: AppTextStyles.chartAxisTitle,
        maxLines: 1,
      ),
      sideTitles: SideTitles(
        showTitles: true,
        interval: labelStep.toDouble(),
        reservedSize: AppDimensions.historyBottomAxisSize,
        getTitlesWidget: (value, meta) {
          if (value % labelStep != 0 || value >= hours.length) return const SizedBox.shrink();
          return SideTitleWidget(
            meta: meta,
            child: CustomText(text: _timeLabel(value.toInt()), style: AppTextStyles.chartAxis),
          );
        },
      ),
    );
  }

  LineTouchData _touch() {
    return LineTouchData(
      touchSpotThreshold: AppDimensions.historyTouchThreshold,
      getTouchedSpotIndicator: (bar, indexes) => [
        for (final _ in indexes)
          TouchedSpotIndicatorData(
            const FlLine(
              color: AppColors.chartCrosshair,
              strokeWidth: AppDimensions.historyCrosshairWidth,
              dashArray: [AppDimensions.historyDash, AppDimensions.historyDash],
            ),
            FlDotData(
              getDotPainter: (_, _, _, _) => FlDotCirclePainter(
                radius: AppDimensions.historyTouchDotRadius,
                color: AppColors.cardBg,
                strokeColor: bar.color ?? AppColors.textPrimary,
                strokeWidth: AppDimensions.historyTouchDotStroke,
              ),
            ),
          ),
      ],
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (_) => AppColors.cardBgElevated,
        tooltipBorder: const BorderSide(color: AppColors.cardBorder),
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        maxContentWidth: AppDimensions.historyTooltipWidth,
        getTooltipItems: (spots) => [
          for (var i = 0; i < spots.length; i++) _tooltipItem(spots[i], isFirst: i == 0),
        ],
      ),
    );
  }

  LineTooltipItem _tooltipItem(LineBarSpot spot, {required bool isFirst}) {
    final series = chart.series[spot.barIndex];
    final valueLine = '${series.label}${AppStrings.tooltipSeparator}${chart.valueLabel(spot.y)}';
    final text = isFirst ? '${_timeLabel(spot.x.toInt())}\n$valueLine' : valueLine;

    return LineTooltipItem(
      text,
      AppTextStyles.chartTooltip.copyWith(color: series.color),
      textAlign: TextAlign.start,
    );
  }

  String _timeLabel(int index) => Formatters.hour(hours[index]);
}
