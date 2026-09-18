import 'package:flutter/material.dart';

import '../../../../core/constants/app_container.dart';

import 'dashboard_content.dart';
import 'dashboard_footer.dart';
import 'dashboard_header.dart';

class DashboardDesktopLayout extends StatelessWidget {
  const DashboardDesktopLayout({super.key, required this.deviceId});

  final String deviceId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppContainer(
        child: Column(
          children: [
            DashboardHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: const DashboardContent(),
              ),
            ),

            const DashboardFooter(),
          ],
        ),
      ),
    );
  }
}
