import 'package:flutter/widgets.dart';

import '../utils/app_dimensions.dart';
import '../utils/size_config.dart';

extension ResponsiveContext on BuildContext {
  double get appWidth => MediaQuery.sizeOf(this).width;

  DeviceType get appDevice => SizeConfig.deviceTypeOf(appWidth);

  bool get isMobileLayout => appDevice == DeviceType.mobile;
  bool get isTabletLayout => appDevice == DeviceType.tablet;
  bool get isDesktopLayout => appDevice == DeviceType.desktop;
  bool get isCompactLayout => !isDesktopLayout;

  double get appTextScale => SizeConfig.textScaleOf(appDevice);
  double get appSpaceScale => SizeConfig.spaceScaleOf(appDevice);

  double get appPageGutter =>
      isMobileLayout ? AppDimensions.pageGutterMobile : AppDimensions.pageGutterDesktop;

  double get appGridGutter =>
      isMobileLayout ? AppDimensions.gridGutterMobile : AppDimensions.gridGutter;

  double get appCardPadding =>
      isMobileLayout ? AppDimensions.cardPaddingMobile : AppDimensions.cardPadding;

  double get appPanelIconBox =>
      isMobileLayout ? AppDimensions.panelIconBoxMobile : AppDimensions.panelIconBox;

  T adaptive<T>({required T mobile, T? tablet, required T desktop}) => switch (appDevice) {
    DeviceType.desktop => desktop,
    DeviceType.tablet => tablet ?? desktop,
    DeviceType.mobile => mobile,
  };
}
