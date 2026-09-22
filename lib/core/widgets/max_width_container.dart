import 'package:flutter/material.dart';

import '../extensions/responsive_extension.dart';
import '../utils/app_dimensions.dart';

class MaxWidthContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const MaxWidthContainer({
    super.key,
    required this.child,
    this.maxWidth = AppDimensions.maxContentWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.appPageGutter),
          child: child,
        ),
      ),
    );
  }
}
