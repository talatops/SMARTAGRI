import 'package:flutter/material.dart';

import '../widgets/dashboard_mobile_layout.dart';
import '../widgets/dashboard_tablet_layout.dart';
import '../widgets/dashboard_desktop_layout.dart';
import '../../../../core/widgets/responsive_layout.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.deviceId});

  final String deviceId;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: DashboardMobileLayout(deviceId: deviceId),
      tablet: DashboardTabletLayout(deviceId: deviceId),
      desktop: DashboardDesktopLayout(deviceId: deviceId),
      largeWeb: DashboardDesktopLayout(deviceId: deviceId),
    );
  }
}
