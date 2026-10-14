import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/extensions/responsive_extension.dart';
import '../../../../../core/extensions/responsive_size_extension.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_dimensions.dart';
import '../../../../../core/utils/app_durations.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/constants.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/selectable_table.dart';
import '../../../domain/entities/crop_profile.dart';
import '../../notifier/dashboard_notifier.dart';

class CropProfilePanel extends StatelessWidget {
  const CropProfilePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: AppStrings.cropTitle,
      subtitle: AppStrings.cropSubtitle,
      icon: AppAssets.cropPanel,
      iconColor: AppColors.success,
      child: Consumer(builder: (context, ref, _) {
        final (crops, selected) = ref.watch(
          dashboardProvider.select((state) => (state.crops, state.selectedCrop)),
        );
        if (crops.isEmpty || selected == null) {
          return const SizedBox.shrink();
        }

        return SelectableTable<CropProfile>(
          headers: const [AppStrings.colCrop, AppStrings.colRange],
          columnFlex: const [5, 6],
          items: crops,
          selected: selected,
          onSelect: (crop) => ref.read(dashboardProvider.notifier).selectCrop(crop),
          fillHeight: !context.isMobileLayout,
          rowBuilder: (context, crop, isSelected, isHovered) =>
              CropRangeRow(crop: crop, isSelected: isSelected, isHovered: isHovered),
        );
      }),
    );
  }
}

class CropRangeRow extends StatelessWidget {
  final CropProfile crop;
  final bool isSelected;
  final bool isHovered;

  const CropRangeRow({
    super.key,
    required this.crop,
    required this.isSelected,
    required this.isHovered,
  });

  @override
  Widget build(BuildContext context) {
    final fill = isSelected
        ? AppColors.pillFill(AppColors.success)
        : isHovered
        ? AppColors.hoverFill
        : Colors.transparent;

    return AnimatedContainer(
      duration: AppDurations.fast,
      curve: Curves.easeOut,
      margin: EdgeInsets.symmetric(vertical: 2.h),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isSelected ? AppColors.pillBorder(AppColors.success) : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedContainer(
            duration: AppDurations.fast,
            width: 3.w,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.success : Colors.transparent,
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.only(left: AppDimensions.s10.w),
              child: Row(
                children: [
                  Icon(crop.icon, color: crop.iconColor, size: 20.r),
                  WidthBox(width: AppDimensions.s10.w),
                  Flexible(
                    child: CustomText(
                      text: crop.name,
                      style: AppTextStyles.tableCell,
                      fontColor: AppColors.textPrimary,
                      maxLines: 1,
                      autoManageSize: true,
                      minFontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.softTint(AppColors.success) : Colors.transparent,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: CustomText(
                text: Formatters.range(crop.minMoisture, crop.maxMoisture),
                style: AppTextStyles.tableCell,
                fontColor: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                maxLines: 1,
                textAlign: TextAlign.center,
                autoManageSize: true,
                minFontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
