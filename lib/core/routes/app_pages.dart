import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import 'app_routes.dart';

abstract final class AppPages {
  static final router = GoRouter(
    initialLocation: AppRoutes.dashboard,
    onException: (context, state, router) => router.go(AppRoutes.dashboard),
    routes: [
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardPage(),
      ),
    ],
  );
}
