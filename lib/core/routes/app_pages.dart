import 'package:get/get.dart';

import '../../features/dashboard/presentation/bindings/dashboard_binding.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import 'app_routes.dart';

abstract final class AppPages {
  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
    ),
  ];
}
