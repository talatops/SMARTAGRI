import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WeatherIllustration extends StatelessWidget {
  final String icon;
  final double size;

  const WeatherIllustration({super.key, required this.icon, this.size = 92});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(icon, width: size, height: size);
  }
}
