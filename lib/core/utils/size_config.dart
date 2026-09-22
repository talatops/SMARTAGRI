import 'package:flutter/widgets.dart';

import 'app_dimensions.dart';

enum DeviceType { mobile, tablet, desktop }

class SizeConfig {
  SizeConfig._();

  static double screenWidth = AppDimensions.maxContentWidth;
  static double screenHeight = 800;

  static void init(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    screenWidth = size.width;
    screenHeight = size.height;
  }

  static DeviceType deviceTypeOf(double width) {
    if (width >= AppDimensions.bpDesktop) return DeviceType.desktop;
    if (width >= AppDimensions.bpTablet) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  static DeviceType get deviceType => deviceTypeOf(screenWidth);

  static bool get isMobile => deviceType == DeviceType.mobile;
  static bool get isTablet => deviceType == DeviceType.tablet;
  static bool get isDesktop => deviceType == DeviceType.desktop;

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
