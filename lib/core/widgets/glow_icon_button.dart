import 'package:flutter/material.dart';

import '../extensions/responsive_size_extension.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_colors.dart';
import '../utils/app_dimensions.dart';
import '../utils/app_durations.dart';
import 'constants.dart';
import 'custom_text.dart';
import 'hover_region.dart';

class GlowIconButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;
  final double size;
  final Color activeColor;
  final Color idleColor;

  const GlowIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.size = AppDimensions.pumpButtonSize,
    this.activeColor = AppColors.success,
    this.idleColor = AppColors.cyan,
  });

  @override
  State<GlowIconButton> createState() => _GlowIconButtonState();
}

class _GlowIconButtonState extends State<GlowIconButton> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: AppDurations.pulse,
  );

  @override
  void initState() {
    super.initState();
    _syncPulse();
  }

  @override
  void didUpdateWidget(GlowIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncPulse();
  }

  void _syncPulse() {
    if (widget.isActive && widget.onTap != null) {
      if (!_pulse.isAnimating) _pulse.repeat(reverse: true);
    } else {
      _pulse.stop();
      _pulse.value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    final color = widget.isActive ? widget.activeColor : widget.idleColor;
    final size = widget.size.r;

    return HoverRegion(
      onTap: widget.onTap,
      builder: (context, hovered) => AnimatedOpacity(
        duration: AppDurations.normal,
        opacity: enabled ? 1 : 0.55,
        child: AnimatedBuilder(
          animation: _pulse,
          builder: (context, _) {
            final pulseStrength = 0.55 + (_pulse.value * 0.45);
            final hoverBoost = hovered && enabled ? 1.25 : 1.0;
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.tileBg,
                border: Border.all(color: color, width: 2.2),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.30 * pulseStrength * hoverBoost),
                    blurRadius: 26 * pulseStrength,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.icon, color: color, size: size * 0.29),
                  HeightBox(height: AppDimensions.s8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: CustomText(
                      text: widget.label,
                      style: AppTextStyles.pumpLabel,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      autoManageSize: true,
                      minFontSize: 9,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
