import '../utils/size_config.dart';

extension ResponsiveSize on num {
  double get sp => this * SizeConfig.textScale;
  double get w => this * SizeConfig.spaceScale;
  double get h => this * SizeConfig.spaceScale;
  double get r => this * SizeConfig.spaceScale;
}
