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
