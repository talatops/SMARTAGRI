import 'package:flutter/material.dart';

import '../../../../../core/extensions/responsive_extension.dart';
import '../../../../../core/utils/app_dimensions.dart';

class DashboardGrid extends StatelessWidget {
  final Widget soilPanel;
  final Widget compositePanel;
  final Widget telemetryPanel;
  final Widget irrigationPanel;
  final Widget weatherPanel;
  final Widget cropPanel;

  const DashboardGrid({
    super.key,
    required this.soilPanel,
    required this.compositePanel,
    required this.telemetryPanel,
    required this.irrigationPanel,
    required this.weatherPanel,
    required this.cropPanel,
  });

  @override
  Widget build(BuildContext context) {
    final gap = context.appGridGutter;

    if (context.isMobileLayout) {
      return Column(
        children: [
          soilPanel,
          SizedBox(height: gap),
          compositePanel,
          SizedBox(height: gap),
          telemetryPanel,
          SizedBox(height: gap),
          irrigationPanel,
          SizedBox(height: gap),
          weatherPanel,
          SizedBox(height: gap),
          cropPanel,
        ],
      );
    }

    final isTablet = context.isTabletLayout;
    final rowOne = isTablet ? AppDimensions.rowOneHeightTablet : AppDimensions.rowOneHeightDesktop;
    final rowTwo = isTablet ? AppDimensions.rowTwoHeightTablet : AppDimensions.rowTwoHeightDesktop;

    if (isTablet) {
      return Column(
        children: [
          EqualHeightRow(height: rowOne, gap: gap, children: [soilPanel, telemetryPanel]),
          SizedBox(height: gap),
          EqualHeightRow(height: rowTwo, gap: gap, children: [compositePanel, irrigationPanel]),
          SizedBox(height: gap),
          EqualHeightRow(height: rowTwo, gap: gap, children: [weatherPanel, cropPanel]),
        ],
      );
    }

    const desktopFlex = [AppDimensions.flexLeft, AppDimensions.flexMiddle, AppDimensions.flexRight];

    return Column(
      children: [
        EqualHeightRow(
          height: rowOne,
          gap: gap,
          flex: desktopFlex,
          children: [soilPanel, telemetryPanel, weatherPanel],
        ),
        SizedBox(height: gap),
        EqualHeightRow(
          height: rowTwo,
          gap: gap,
          flex: desktopFlex,
          children: [compositePanel, irrigationPanel, cropPanel],
        ),
      ],
    );
  }
}

class EqualHeightRow extends StatelessWidget {
  final List<Widget> children;
  final List<int>? flex;
  final double gap;
  final double height;

  const EqualHeightRow({
    super.key,
    required this.children,
    required this.gap,
    required this.height,
    this.flex,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(width: gap),
            Expanded(flex: flex?[i] ?? 1, child: children[i]),
          ],
        ],
      ),
    );
  }
}
