import 'package:flutter/widgets.dart';

import 'app_dimensions.dart';

enum DeviceType { mobile, tablet, desktop }

class SizeConfig {
  SizeConfig._();

  static double screenWidth = AppDimensions.maxContentWidth;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.sizeOf(context).width;
  }

  static DeviceType deviceTypeOf(double width) {
    if (width >= AppDimensions.bpDesktop) return DeviceType.desktop;
    if (width >= AppDimensions.bpTablet) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  static DeviceType get deviceType => deviceTypeOf(screenWidth);

  static double textScaleOf(DeviceType type) => switch (type) {
    DeviceType.desktop => 1.0,
    DeviceType.tablet => 0.94,
    DeviceType.mobile => 0.88,
  };

  static double spaceScaleOf(DeviceType type) => switch (type) {
    DeviceType.desktop => 1.0,
    DeviceType.tablet => 0.95,
    DeviceType.mobile => 0.90,
  };

  static double get textScale => textScaleOf(deviceType);
  static double get spaceScale => spaceScaleOf(deviceType);
}
