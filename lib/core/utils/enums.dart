import 'package:flutter/material.dart';

import 'app_assets.dart';
import 'app_colors.dart';
import 'app_strings.dart';
import 'formatters.dart';

enum MetricStatus {
  normal(AppStrings.normal),
  warning(AppStrings.warning),
  critical(AppStrings.critical);

  final String label;
  const MetricStatus(this.label);

  bool get isNormal => this == MetricStatus.normal;
}

enum SoilDepth {
  surface(AppStrings.surfaceZone, AppStrings.depth5cm),
  root(AppStrings.rootZone, AppStrings.depth20cm),
  deep(AppStrings.deepZone, AppStrings.depth40cm);

  final String label;
  final String depthLabel;
  const SoilDepth(this.label, this.depthLabel);
}

enum PumpMode {
  auto(AppStrings.auto),
  manual(AppStrings.manual);

  final String label;
  const PumpMode(this.label);

  bool get isAuto => this == PumpMode.auto;
  bool get isManual => this == PumpMode.manual;
}

enum CropType {
  wheat(AppStrings.wheat),
  rice(AppStrings.rice),
  cotton(AppStrings.cotton),
  sugarcane(AppStrings.sugarcane),
  maize(AppStrings.maize);

  final String label;
  const CropType(this.label);
}

enum LocationIssue {
  permissionDenied(AppStrings.locationPermissionDenied),
  permissionBlocked(AppStrings.locationPermissionBlocked),
  serviceDisabled(AppStrings.locationServiceDisabled),
  unavailable(AppStrings.locationFetchFailed);

  final String message;
  const LocationIssue(this.message);

  bool get isPermissionDenied => this == LocationIssue.permissionDenied;
  bool get isPermissionBlocked => this == LocationIssue.permissionBlocked;
  bool get isServiceDisabled => this == LocationIssue.serviceDisabled;
  bool get isUnavailable => this == LocationIssue.unavailable;
}

enum WeatherCondition {
  clearSky(AppStrings.clearSky, AppAssets.weatherClearDay, AppAssets.weatherClearNight),
  mainlyClear(
    AppStrings.mainlyClear,
    AppAssets.weatherPartlyCloudyDay,
    AppAssets.weatherPartlyCloudyNight,
  ),
  partlyCloudy(
    AppStrings.partlyCloudy,
    AppAssets.weatherPartlyCloudyDay,
    AppAssets.weatherPartlyCloudyNight,
  ),
  overcast(AppStrings.overcast, AppAssets.weatherOvercastDay, AppAssets.weatherOvercastNight),
  fog(AppStrings.fog, AppAssets.weatherFogDay, AppAssets.weatherFogNight),
  drizzle(AppStrings.drizzle, AppAssets.weatherDrizzle, AppAssets.weatherDrizzle),
  freezingDrizzle(AppStrings.freezingDrizzle, AppAssets.weatherSleet, AppAssets.weatherSleet),
  rain(AppStrings.raining, AppAssets.weatherRain, AppAssets.weatherRain),
  heavyRain(AppStrings.heavyRain, AppAssets.weatherExtremeRain, AppAssets.weatherExtremeRain),
  freezingRain(AppStrings.freezingRain, AppAssets.weatherSleet, AppAssets.weatherSleet),
  snow(AppStrings.snow, AppAssets.weatherSnow, AppAssets.weatherSnow),
  heavySnow(AppStrings.heavySnow, AppAssets.weatherExtremeSnow, AppAssets.weatherExtremeSnow),
  snowGrains(AppStrings.snowGrains, AppAssets.weatherSnow, AppAssets.weatherSnow),
  rainShowers(
    AppStrings.rainShowers,
    AppAssets.weatherRainShowersDay,
    AppAssets.weatherRainShowersNight,
  ),
  heavyRainShowers(
    AppStrings.heavyRainShowers,
    AppAssets.weatherExtremeRain,
    AppAssets.weatherExtremeRain,
  ),
  snowShowers(
    AppStrings.snowShowers,
    AppAssets.weatherSnowShowersDay,
    AppAssets.weatherSnowShowersNight,
  ),
  thunderstorm(
    AppStrings.thunderstorm,
    AppAssets.weatherThunderstormDay,
    AppAssets.weatherThunderstormNight,
  ),
  thunderstormHail(
    AppStrings.thunderstormHail,
    AppAssets.weatherThunderstormExtreme,
    AppAssets.weatherThunderstormExtreme,
  ),
  unknown(
    AppStrings.unknownCondition,
    AppAssets.weatherNotAvailable,
    AppAssets.weatherNotAvailable,
  );

  final String label;
  final String dayIcon;
  final String nightIcon;
  const WeatherCondition(this.label, this.dayIcon, this.nightIcon);

  String iconFor({required bool isDay}) => isDay ? dayIcon : nightIcon;

  bool get isRaining => switch (this) {
    drizzle ||
    freezingDrizzle ||
    rain ||
    heavyRain ||
    freezingRain ||
    rainShowers ||
    heavyRainShowers ||
    thunderstorm ||
    thunderstormHail => true,
    _ => false,
  };
}

enum HistorySeries {
  surfaceMoisture(AppStrings.surfaceSeries, AppColors.chartBlue),
  rootMoisture(AppStrings.rootSeries, AppColors.chartYellow),
  deepMoisture(AppStrings.deepSeries, AppColors.chartPurple),
  compositeMoisture(AppStrings.compositeSeries, AppColors.chartGreen),
  fieldTemperature(AppStrings.fieldTemperatureSeries, AppColors.chartBlue),
  weatherTemperature(AppStrings.weatherTemperatureSeries, AppColors.chartYellow),
  fieldHumidity(AppStrings.fieldHumiditySeries, AppColors.chartGreen),
  weatherHumidity(AppStrings.weatherHumiditySeries, AppColors.chartPurple),
  pumpStatus(AppStrings.pumpStatusSeries, AppColors.chartBlue);

  final String label;
  final Color color;
  const HistorySeries(this.label, this.color);
}

enum HistoryChart {
  soilMoisture(
    title: AppStrings.historySoilTitle,
    subtitle: AppStrings.historySoilSubtitle,
    icon: AppAssets.historySoil,
    axisTitle: AppStrings.moistureAxis,
    minY: 0,
    maxY: 100,
    interval: 20,
    series: [
      HistorySeries.surfaceMoisture,
      HistorySeries.rootMoisture,
      HistorySeries.deepMoisture,
      HistorySeries.compositeMoisture,
    ],
  ),
  temperature(
    title: AppStrings.historyTemperatureTitle,
    subtitle: AppStrings.historyTemperatureSubtitle,
    icon: AppAssets.historyTemperature,
    axisTitle: AppStrings.temperatureAxis,
    minY: 0,
    maxY: 50,
    interval: 10,
    series: [HistorySeries.fieldTemperature, HistorySeries.weatherTemperature],
  ),
  humidity(
    title: AppStrings.historyHumidityTitle,
    subtitle: AppStrings.historyHumiditySubtitle,
    icon: AppAssets.historyHumidity,
    axisTitle: AppStrings.humidityAxis,
    minY: 0,
    maxY: 100,
    interval: 20,
    series: [HistorySeries.fieldHumidity, HistorySeries.weatherHumidity],
  ),
  pump(
    title: AppStrings.historyPumpTitle,
    subtitle: AppStrings.historyPumpSubtitle,
    icon: AppAssets.historyPump,
    axisTitle: AppStrings.pumpStatusSeries,
    minY: -0.15,
    maxY: 1.25,
    interval: 1,
    series: [HistorySeries.pumpStatus],
    isStepped: true,
  );

  final String title;
  final String subtitle;
  final IconData icon;
  final String axisTitle;
  final double minY;
  final double maxY;
  final double interval;
  final List<HistorySeries> series;
  final bool isStepped;

  const HistoryChart({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.axisTitle,
    required this.minY,
    required this.maxY,
    required this.interval,
    required this.series,
    this.isStepped = false,
  });

  bool get isPump => this == HistoryChart.pump;

  String axisLabel(double value) => switch (this) {
    soilMoisture => Formatters.percent(value, decimals: 0),
    pump => _onOff(value),
    temperature || humidity => value.toStringAsFixed(0),
  };

  String valueLabel(double value) => switch (this) {
    soilMoisture || humidity => Formatters.percent(value),
    temperature => Formatters.temperature(value),
    pump => _onOff(value),
  };

  static String _onOff(double value) => value >= 0.5 ? AppStrings.on : AppStrings.off;
}

enum HistoryRange {
  last6Hours(AppStrings.last6Hours, AppStrings.timeAxis6Hours, 6),
  last12Hours(AppStrings.last12Hours, AppStrings.timeAxis12Hours, 12),
  last24Hours(AppStrings.last24Hours, AppStrings.timeAxis24Hours, 24);

  final String label;
  final String axisTitle;
  final int hours;
  const HistoryRange(this.label, this.axisTitle, this.hours);
}
