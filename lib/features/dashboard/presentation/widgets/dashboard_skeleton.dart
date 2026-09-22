import 'package:flutter/material.dart';

import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/responsive_size_extension.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_dimensions.dart';
import '../../../../core/widgets/constants.dart';
import '../../../../core/widgets/shimmer.dart';
import 'dashboard_grid.dart';

class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Column(
        children: [
          HeightBox(height: AppDimensions.s16.h),
          const _HeaderSkeleton(),
          HeightBox(height: AppDimensions.s16.h),
          DashboardGrid(
            soilPanel: _CardSkeleton(
              mobileBodyHeight:
                  AppDimensions.soilTileRowHeightMobile.h * 2 + AppDimensions.s10.w,
              body: const _SoilBody(),
            ),
            compositePanel: _CardSkeleton(
              mobileBodyHeight: AppDimensions.skeletonGaugeBodyMobile.h,
              body: const _GaugeBody(),
            ),
            telemetryPanel: _CardSkeleton(
              mobileBodyHeight:
                  AppDimensions.skeletonTelemetryTileMobile.h * 2 + AppDimensions.s10.w,
              body: const _TelemetryBody(),
            ),
            irrigationPanel: _CardSkeleton(
              mobileBodyHeight: AppDimensions.skeletonGaugeBodyMobile.h,
              body: const _GaugeBody(),
            ),
            weatherPanel: _CardSkeleton(
              mobileBodyHeight: AppDimensions.skeletonWeatherBodyMobile.h,
              body: const _WeatherBody(),
            ),
            cropPanel: _CardSkeleton(
              mobileBodyHeight: AppDimensions.skeletonCropBodyMobile.h,
              body: const _CropBody(),
            ),
          ),
          HeightBox(height: AppDimensions.s16.h),
          const _FooterSkeleton(),
        ],
      ),
    );
  }
}

class _HeaderSkeleton extends StatelessWidget {
  const _HeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    final brand = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShimmerBox(
          width: AppDimensions.skeletonLogoSize.r,
          height: AppDimensions.skeletonLogoSize.r,
          circle: true,
        ),
        WidthBox(width: AppDimensions.s10.w),
        ShimmerBox(
          width: AppDimensions.skeletonBrandWidth.w,
          height: AppDimensions.skeletonBrandHeight.h,
        ),
      ],
    );
    final meta = ShimmerBox(
      width: AppDimensions.skeletonMetaWidth.w,
      height: AppDimensions.skeletonMetaHeight.h,
    );

    if (context.isMobileLayout) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          brand,
          HeightBox(height: AppDimensions.s10.h),
          meta,
        ],
      );
    }

    return Row(children: [brand, const Spacer(), meta]);
  }
}

class _FooterSkeleton extends StatelessWidget {
  const _FooterSkeleton();

  @override
  Widget build(BuildContext context) {
    final line = ShimmerBox(
      width: AppDimensions.skeletonFooterWidth.w,
      height: AppDimensions.skeletonFooterHeight.h,
    );

    return Column(
      children: [
        const Divider(color: AppColors.divider, height: 1),
        HeightBox(height: AppDimensions.s14.h),
        if (context.isMobileLayout)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              line,
              HeightBox(height: AppDimensions.s8.h),
              line,
            ],
          )
        else
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [line, line]),
        HeightBox(height: AppDimensions.s8.h),
      ],
    );
  }
}

class _CardSkeleton extends StatelessWidget {
  final Widget body;
  final double mobileBodyHeight;

  const _CardSkeleton({required this.body, required this.mobileBodyHeight});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobileLayout;
    final iconSize = context.appPanelIconBox * AppDimensions.skeletonIconFactor;

    return Container(
      padding: EdgeInsets.all(context.appCardPadding),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius.r),
        border: Border.all(color: AppColors.cardBorder, width: AppDimensions.borderWidth),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: isMobile ? MainAxisSize.min : MainAxisSize.max,
        children: [
          Row(
            children: [
              ShimmerBox(width: iconSize, height: iconSize, circle: true),
              WidthBox(width: AppDimensions.s12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLine(
                      widthFactor: AppDimensions.skeletonShortFactor,
                      height: AppDimensions.skeletonTitleHeight.h,
                    ),
                    HeightBox(height: AppDimensions.s6.h),
                    ShimmerLine(
                      widthFactor: AppDimensions.skeletonMediumFactor,
                      height: AppDimensions.skeletonSubtitleHeight.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
          HeightBox(height: AppDimensions.s16.h),
          if (isMobile)
            SizedBox(height: mobileBodyHeight, child: body)
          else
            Expanded(child: body),
        ],
      ),
    );
  }
}

class _TileSkeleton extends StatelessWidget {
  const _TileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.tilePadding.w),
      decoration: BoxDecoration(
        color: AppColors.tileBg,
        borderRadius: BorderRadius.circular(AppDimensions.tileRadius.r),
        border: Border.all(color: AppColors.tileBorder, width: AppDimensions.borderWidth),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ShimmerLine(
            widthFactor: AppDimensions.skeletonMediumFactor,
            height: AppDimensions.skeletonLineHeight.h,
            alignment: Alignment.center,
          ),
          ShimmerLine(
            widthFactor: AppDimensions.skeletonLongFactor,
            height: AppDimensions.skeletonValueHeight.h,
            alignment: Alignment.center,
          ),
          ShimmerLine(
            widthFactor: AppDimensions.skeletonShortFactor,
            height: AppDimensions.skeletonPillHeight.h,
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }
}

class _SoilBody extends StatelessWidget {
  const _SoilBody();

  @override
  Widget build(BuildContext context) {
    final gap = AppDimensions.s10.w;

    if (context.isDesktopLayout) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < 4; i++) ...[
            if (i > 0) SizedBox(width: gap),
            Expanded(flex: i == 3 ? 7 : 5, child: const _TileSkeleton()),
          ],
        ],
      );
    }

    Widget row() => Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(child: _TileSkeleton()),
          SizedBox(width: gap),
          const Expanded(child: _TileSkeleton()),
        ],
      ),
    );

    return Column(children: [row(), SizedBox(height: gap), row()]);
  }
}

class _TelemetryBody extends StatelessWidget {
  const _TelemetryBody();

  @override
  Widget build(BuildContext context) {
    final gap = AppDimensions.s10.w;

    if (context.isMobileLayout) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(child: _TileSkeleton()),
          SizedBox(height: gap),
          const Expanded(child: _TileSkeleton()),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Expanded(child: _TileSkeleton()),
        SizedBox(width: gap),
        const Expanded(child: _TileSkeleton()),
      ],
    );
  }
}

class _GaugeBody extends StatelessWidget {
  const _GaugeBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          child: Center(
            child: AspectRatio(aspectRatio: 1, child: ShimmerBox(circle: true)),
          ),
        ),
        HeightBox(height: AppDimensions.s16.h),
        ShimmerLine(
          widthFactor: AppDimensions.skeletonMediumFactor,
          height: AppDimensions.skeletonTitleHeight.h,
          alignment: Alignment.center,
        ),
        HeightBox(height: AppDimensions.s8.h),
        ShimmerLine(
          widthFactor: AppDimensions.skeletonLongFactor,
          height: AppDimensions.skeletonLineHeight.h,
          alignment: Alignment.center,
        ),
      ],
    );
  }
}

class _WeatherBody extends StatelessWidget {
  const _WeatherBody();

  @override
  Widget build(BuildContext context) {
    final gap = AppDimensions.s10.w;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Expanded(child: ShimmerBox()),
        HeightBox(height: AppDimensions.s16.h),
        Row(
          children: [
            for (var i = 0; i < 3; i++) ...[
              if (i > 0) SizedBox(width: gap),
              Expanded(child: ShimmerBox(height: AppDimensions.skeletonValueHeight.h)),
            ],
          ],
        ),
      ],
    );
  }
}

class _CropBody extends StatelessWidget {
  const _CropBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < AppDimensions.skeletonCropRows; i++) ...[
          if (i > 0) HeightBox(height: AppDimensions.s8.h),
          const Expanded(child: ShimmerBox()),
        ],
      ],
    );
  }
}
