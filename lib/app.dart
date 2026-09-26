import 'package:flutter/material.dart';

import 'core/routes/app_pages.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_scroll_behavior.dart';
import 'core/utils/app_strings.dart';
import 'core/utils/size_config.dart';

class SmartAgriApp extends StatelessWidget {
  const SmartAgriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      scrollBehavior: const AppScrollBehavior(),
      routerConfig: AppPages.router,
      builder: (context, child) {
        SizeConfig.init(context);
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
