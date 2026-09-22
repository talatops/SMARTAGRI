import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';

abstract final class AppTextStyles {
  static const appTitle = TextStyle(
    fontSize: 22,
    fontWeight: AppFonts.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static const tagline = TextStyle(
    fontSize: 13,
    fontWeight: AppFonts.regular,
    color: AppColors.textSecondary,
  );

  static const headerMeta = TextStyle(
    fontSize: 13,
    fontWeight: AppFonts.medium,
    color: AppColors.textPrimary,
  );

  static const panelTitle = TextStyle(
    fontSize: 18,
    fontWeight: AppFonts.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
  );

  static const panelSubtitle = TextStyle(
    fontSize: 12.5,
    fontWeight: AppFonts.regular,
    color: AppColors.textSecondary,
  );

  static const metricValueXL = TextStyle(
    fontSize: 40,
    fontWeight: AppFonts.bold,
    color: AppColors.textPrimary,
    letterSpacing: -1,
  );

  static const metricValueL = TextStyle(
    fontSize: 30,
    fontWeight: AppFonts.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const gaugeValue = TextStyle(
    fontSize: 20,
    fontWeight: AppFonts.bold,
    color: AppColors.textPrimary,
  );

  static const gaugeValueXL = TextStyle(
    fontSize: 36,
    fontWeight: AppFonts.bold,
    color: AppColors.textPrimary,
    letterSpacing: -1,
  );

  static const tileLabel = TextStyle(
    fontSize: 12.5,
    fontWeight: AppFonts.semiBold,
    color: AppColors.textPrimary,
  );

  static const tileSubLabel = TextStyle(
    fontSize: 10.5,
    fontWeight: AppFonts.regular,
    color: AppColors.textTertiary,
  );

  static const captionLabel = TextStyle(
    fontSize: 11.5,
    fontWeight: AppFonts.regular,
    color: AppColors.textSecondary,
  );

  static const pillLabel = TextStyle(
    fontSize: 11.5,
    fontWeight: AppFonts.semiBold,
    color: AppColors.success,
  );

  static const pillLabelLarge = TextStyle(
    fontSize: 14,
    fontWeight: AppFonts.bold,
    color: AppColors.success,
  );

  static const tableHeader = TextStyle(
    fontSize: 12.5,
    fontWeight: AppFonts.semiBold,
    color: AppColors.textSecondary,
  );

  static const tableCell = TextStyle(
    fontSize: 13.5,
    fontWeight: AppFonts.medium,
    color: AppColors.textPrimary,
  );

  static const bodyText = TextStyle(
    fontSize: 13.5,
    fontWeight: AppFonts.regular,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const statusValue = TextStyle(
    fontSize: 28,
    fontWeight: AppFonts.bold,
    color: AppColors.textPrimary,
  );

  static const segmentLabel = TextStyle(
    fontSize: 13.5,
    fontWeight: AppFonts.bold,
    color: AppColors.textPrimary,
    letterSpacing: 0.6,
  );

  static const pumpLabel = TextStyle(
    fontSize: 12.5,
    fontWeight: AppFonts.bold,
    color: AppColors.textPrimary,
    letterSpacing: 0.4,
  );

  static const footerText = TextStyle(
    fontSize: 12,
    fontWeight: AppFonts.regular,
    color: AppColors.textTertiary,
  );
}
