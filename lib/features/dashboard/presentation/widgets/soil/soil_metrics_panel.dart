import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/extensions/responsive_extension.dart';
import '../../../../../core/extensions/responsive_size_extension.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_dimensions.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../notifier/dashboard_notifier.dart';
import 'field_water_tile.dart';
import 'soil_zone_tile.dart';

class SoilMetricsPanel extends StatelessWidget {
  const SoilMetricsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: AppStrings.soilPanelTitle,
      subtitle: AppStrings.soilPanelSubtitle,
      icon: AppAssets.soilPanel,
      iconColor: AppColors.success,
      child: Consumer(builder: (context, ref, _) {
        final (readings, waterLevel) = ref.watch(
          dashboardProvider.select(
            (state) => (state.snapshot?.soilReadings, state.snapshot?.waterLevel),
          ),
        );
        if (readings == null || waterLevel == null) return const SizedBox.shrink();

        final tiles = <Widget>[
          for (final reading in readings) SoilZoneTile(reading: reading),
          FieldWaterTile(waterLevel: waterLevel),
        ];
        final gap = AppDimensions.s10.w;

        return !context.isDesktopLayout
            ? _StackedGrid(tiles: tiles, gap: gap)
            : Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < tiles.length; i++) ...[
                    if (i > 0) SizedBox(width: gap),
                    Expanded(flex: i == tiles.length - 1 ? 7 : 5, child: tiles[i]),
                  ],
                ],
              );
      }),
    );
  }
}

class _StackedGrid extends StatelessWidget {
  final List<Widget> tiles;
  final double gap;

  const _StackedGrid({required this.tiles, required this.gap});

  @override
  Widget build(BuildContext context) {
    Widget row(Widget a, Widget b) => SizedBox(
      height: context.isMobileLayout
          ? AppDimensions.soilTileRowHeightMobile.h
          : AppDimensions.soilTileRowHeightTablet.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: a),
          SizedBox(width: gap),
          Expanded(child: b),
        ],
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        row(tiles[0], tiles[1]),
        SizedBox(height: gap),
        row(tiles[2], tiles[3]),
      ],
    );
  }
}
