import 'package:flutter/material.dart';

import '../extensions/responsive_extension.dart';
import '../extensions/responsive_size_extension.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_colors.dart';
import '../utils/app_dimensions.dart';
import 'constants.dart';
import 'custom_text.dart';

class AppCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Widget? trailing;

  final Widget? backgroundLayer;

  final bool expandChild;

  const AppCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
    this.iconColor = AppColors.success,
    this.padding,
    this.trailing,
    this.backgroundLayer,
    this.expandChild = true,
  });

  @override
  Widget build(BuildContext context) {
    final expand = expandChild && !context.isMobileLayout;

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      children: [
        _Header(
          title: title,
          subtitle: subtitle,
          icon: icon,
          iconColor: iconColor,
          trailing: trailing,
        ),
        HeightBox(height: AppDimensions.s16.h),
        if (expand) Expanded(child: child) else child,
      ],
    );

    final radius = BorderRadius.circular(AppDimensions.cardRadius.r);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: radius,
        border: Border.all(color: AppColors.cardBorder, width: AppDimensions.borderWidth),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          children: [
            if (backgroundLayer != null) Positioned.fill(child: backgroundLayer!),
            Padding(padding: padding ?? EdgeInsets.all(context.appCardPadding), child: body),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Widget? trailing;

  const _Header({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: iconColor, size: context.appPanelIconBox * 0.72),
        WidthBox(width: AppDimensions.s12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: title,
                style: AppTextStyles.panelTitle,
                maxLines: 1,
                autoManageSize: true,
                minFontSize: 13,
              ),
              HeightBox(height: AppDimensions.s2.h),
              CustomText(
                text: subtitle,
                style: AppTextStyles.panelSubtitle,
                maxLines: 1,
                autoManageSize: true,
                minFontSize: 9,
              ),
            ],
          ),
        ),
        if (trailing != null) ...[
          WidthBox(width: AppDimensions.s12.w),
          trailing!,
        ],
      ],
    );
  }
}
