import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import '../extensions/responsive_extension.dart';

class CustomText extends StatelessWidget {
  final String text;

  final double? fontSize;
  final Color? fontColor;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final bool? lineThrough;
  final bool? underLined;
  final double? lineSpacing;
  final double? letterSpacing;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softWrap;

  final TextStyle? style;

  final bool autoManageSize;

  final double minFontSize;

  final bool scaleWithScreen;

  const CustomText({
    super.key,
    required this.text,
    this.overflow,
    this.fontSize,
    this.fontColor,
    this.fontFamily,
    this.maxLines,
    this.fontWeight,
    this.underLined,
    this.textAlign,
    this.lineThrough,
    this.lineSpacing,
    this.letterSpacing,
    this.softWrap = true,
    this.style,
    this.autoManageSize = false,
    this.minFontSize = 10,
    this.scaleWithScreen = true,
  });

  TextDecoration get _decoration {
    final decorations = <TextDecoration>[
      if (lineThrough == true) TextDecoration.lineThrough,
      if (underLined == true) TextDecoration.underline,
    ];
    if (decorations.isEmpty) return TextDecoration.none;
    if (decorations.length == 1) return decorations.first;
    return TextDecoration.combine(decorations);
  }

  @override
  Widget build(BuildContext context) {
    final value = text.tr;
    final inherited = DefaultTextStyle.of(context).style.merge(this.style);
    final scale = scaleWithScreen ? context.appTextScale : 1.0;

    final resolvedColor = fontColor ?? inherited.color ?? AppColors.textPrimary;
    final resolvedSize = (fontSize ?? inherited.fontSize ?? 16) * scale;

    final style = inherited.copyWith(
      fontSize: resolvedSize,
      color: resolvedColor,
      fontFamily: fontFamily ?? inherited.fontFamily ?? AppFonts.primary,
      fontWeight: fontWeight ?? inherited.fontWeight,
      decoration: _decoration,
      decorationColor: resolvedColor,
      decorationThickness: underLined == true ? 1.2 : null,
      height: lineSpacing ?? 1.2,
      letterSpacing: letterSpacing,
    );

    if (!autoManageSize) {
      return Text(
        value,
        style: style,
        maxLines: maxLines,
        softWrap: softWrap,
        textAlign: textAlign,
        overflow: overflow ?? TextOverflow.ellipsis,
      );
    }

    final fitLines = maxLines ?? 1;
    final scaledMin = math.min(minFontSize * scale, resolvedSize);
    final textScaler = MediaQuery.textScalerOf(context);
    final direction = Directionality.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.hasBoundedWidth) {
          return Text(
            value,
            style: style,
            maxLines: fitLines,
            softWrap: softWrap,
            textAlign: textAlign,
            overflow: overflow ?? TextOverflow.ellipsis,
          );
        }

        final fitted = _fitFontSize(
          value: value,
          style: style,
          maxLines: fitLines,
          maxWidth: constraints.maxWidth,
          maxHeight: constraints.maxHeight,
          startSize: resolvedSize,
          minSize: scaledMin,
          textScaler: textScaler,
          direction: direction,
        );

        return Text(
          value,
          style: style.copyWith(fontSize: fitted),
          maxLines: fitLines,
          softWrap: softWrap,
          textAlign: textAlign,
          overflow: overflow ?? TextOverflow.ellipsis,
        );
      },
    );
  }

  double _fitFontSize({
    required String value,
    required TextStyle style,
    required int maxLines,
    required double maxWidth,
    required double maxHeight,
    required double startSize,
    required double minSize,
    required TextScaler textScaler,
    required TextDirection direction,
  }) {
    if (startSize <= minSize) return minSize;

    final painter = TextPainter(
      textDirection: direction,
      maxLines: maxLines,
      textScaler: textScaler,
      textAlign: textAlign ?? TextAlign.start,
    );

    var size = startSize;
    try {
      while (size > minSize) {
        painter.text = TextSpan(
          text: value,
          style: style.copyWith(fontSize: size),
        );
        painter.layout(maxWidth: maxWidth);

        final overflowsWidth = painter.width > maxWidth + _epsilon;
        final overflowsHeight = maxHeight.isFinite && painter.height > maxHeight + _epsilon;

        if (!painter.didExceedMaxLines && !overflowsWidth && !overflowsHeight) {
          break;
        }
        size -= _step;
      }
    } finally {
      painter.dispose();
    }

    return size.clamp(minSize, startSize);
  }

  static const double _step = 1;
  static const double _epsilon = 0.5;
}
