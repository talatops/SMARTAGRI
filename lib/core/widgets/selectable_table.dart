import 'package:flutter/material.dart';

import '../extensions/responsive_size_extension.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_colors.dart';
import '../utils/app_dimensions.dart';
import 'custom_text.dart';
import 'hover_region.dart';

class SelectableTable<T> extends StatelessWidget {
  final List<String> headers;
  final List<int> columnFlex;
  final List<T> items;
  final T selected;
  final ValueChanged<T> onSelect;
  final Widget Function(BuildContext context, T item, bool isSelected, bool isHovered) rowBuilder;
  final bool fillHeight;
  final double headerHeight;
  final double minRowHeight;

  const SelectableTable({
    super.key,
    required this.headers,
    required this.columnFlex,
    required this.items,
    required this.selected,
    required this.onSelect,
    required this.rowBuilder,
    this.fillHeight = true,
    this.headerHeight = 38,
    this.minRowHeight = 44,
  });

  Widget _buildRow(T item) {
    return HoverRegion(
      onTap: () => onSelect(item),
      builder: (context, hovered) => rowBuilder(context, item, item == selected, hovered),
    );
  }

  @override
  Widget build(BuildContext context) {
    final header = Container(
      height: headerHeight.h,
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.s12.w),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < headers.length; i++)
            Expanded(
              flex: columnFlex[i],
              child: CustomText(
                text: headers[i],
                style: AppTextStyles.tableHeader,
                maxLines: 1,
                textAlign: i == 0 ? TextAlign.start : TextAlign.center,
              ),
            ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: fillHeight ? MainAxisSize.max : MainAxisSize.min,
      children: [
        header,
        for (final item in items)
          if (fillHeight)
            Expanded(child: _buildRow(item))
          else
            SizedBox(height: minRowHeight.h, child: _buildRow(item)),
      ],
    );
  }
}
