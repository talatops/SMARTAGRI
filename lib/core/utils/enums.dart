import 'app_assets.dart';
import 'app_strings.dart';

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
}
