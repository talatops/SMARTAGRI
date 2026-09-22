import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';

abstract final class AppTheme {
  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.scaffoldTop,
      canvasColor: AppColors.scaffoldTop,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primaryBlue,
        secondary: AppColors.success,
        surface: AppColors.cardBg,
        error: AppColors.danger,
        onSurface: AppColors.textPrimary,
      ),
      dividerTheme: const DividerThemeData(color: AppColors.divider, thickness: 1, space: 1),
      iconTheme: const IconThemeData(color: AppColors.textSecondary),
      textTheme: base.textTheme.apply(
        fontFamily: AppFonts.primary,
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primaryBlue,
        selectionColor: Color(0x331FA2FF),
      ),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
    );
  }
}
