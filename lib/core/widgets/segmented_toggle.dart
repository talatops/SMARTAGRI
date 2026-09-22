import 'package:flutter/material.dart';

import '../extensions/responsive_size_extension.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_colors.dart';
import '../utils/app_durations.dart';
import 'custom_text.dart';
import 'hover_region.dart';

class SegmentItem<T> {
  final T value;
  final String label;

  const SegmentItem({required this.value, required this.label});
}

class SegmentedToggle<T> extends StatelessWidget {
  final List<SegmentItem<T>> segments;
  final T value;
  final ValueChanged<T> onChanged;
  final double height;

  const SegmentedToggle({
    super.key,
    required this.segments,
    required this.value,
    required this.onChanged,
    this.height = 46,
  });

  @override
  Widget build(BuildContext context) {
    final selectedIndex = segments.indexWhere((s) => s.value == value);
    final count = segments.length;
    final h = height.h;

    return Container(
      height: h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.tileBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.tileBorder, width: 1),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final segmentWidth = constraints.maxWidth / count;
          return Stack(
            children: [
              if (selectedIndex >= 0)
                AnimatedPositioned(
                  duration: AppDurations.normal,
                  curve: Curves.easeOutCubic,
                  left: segmentWidth * selectedIndex,
                  width: segmentWidth,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(7.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.glow(AppColors.primaryBlue),
                          blurRadius: 12,
                          spreadRadius: -2,
                        ),
                      ],
                    ),
                  ),
                ),
              Row(
                children: [
                  for (final segment in segments)
                    Expanded(
                      child: HoverRegion(
                        onTap: () => onChanged(segment.value),
                        builder: (context, hovered) => Center(
                          child: CustomText(
                            text: segment.label,
                            style: AppTextStyles.segmentLabel,
                            fontColor: segment.value == value || hovered
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
