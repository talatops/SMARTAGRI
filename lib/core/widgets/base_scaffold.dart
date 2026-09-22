import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_scroll_behavior.dart';
import '../utils/size_config.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final Color? backgroundColor;
  final bool scrollable;

  const BaseScaffold({super.key, required this.body, this.backgroundColor, this.scrollable = true});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final content = scrollable
        ? ScrollConfiguration(
            behavior: const AppScrollBehavior(),
            child: SingleChildScrollView(child: body),
          )
        : body;

    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.scaffoldTop,
      body: Container(
        decoration: backgroundColor == null
            ? const BoxDecoration(gradient: AppColors.scaffoldGradient)
            : null,
        child: SafeArea(child: content),
      ),
    );
  }
}
