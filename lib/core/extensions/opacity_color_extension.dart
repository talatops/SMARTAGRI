import 'package:flutter/material.dart';

extension OpacityColorExtension on Color {
  Color setOpacity(double opacity) => withValues(alpha: opacity.clamp(0.0, 1.0));
}
