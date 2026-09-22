import 'package:flutter/material.dart';

import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/responsive_size_extension.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_dimensions.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/field_water_level.dart';
import '../../domain/entities/soil_reading.dart';
import 'field_water_tile.dart';
import 'soil_zone_tile.dart';

class SoilMetricsPanel extends StatelessWidget {
  final List<SoilReading> readings;
  final FieldWaterLevel waterLevel;

  const SoilMetricsPanel({super.key, required this.readings, required this.waterLevel});

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[
      for (final reading in readings) SoilZoneTile(reading: reading),
      FieldWaterTile(waterLevel: waterLevel),
    ];
    final gap = AppDimensions.s10.w;

    return AppCard(
      title: AppStrings.soilPanelTitle,
      subtitle: AppStrings.soilPanelSubtitle,
      icon: AppAssets.soilPanel,
      iconColor: AppColors.success,
      child: !context.isDesktopLayout
          ? _StackedGrid(tiles: tiles, gap: gap)
          : Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < tiles.length; i++) ...[
                  if (i > 0) SizedBox(width: gap),
                  Expanded(flex: i == tiles.length - 1 ? 7 : 5, child: tiles[i]),
                ],
              ],
            ),
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
