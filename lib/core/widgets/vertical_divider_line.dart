import 'package:flutter/material.dart';

import '../extensions/responsive_size_extension.dart';
import '../utils/app_colors.dart';

class VerticalDividerLine extends StatelessWidget {
  final double height;
  final EdgeInsetsGeometry? margin;

  const VerticalDividerLine({super.key, this.height = 28, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: height.h, margin: margin, color: AppColors.divider);
  }
}
