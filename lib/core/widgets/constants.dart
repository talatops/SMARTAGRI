import 'package:flutter/material.dart';

class HeightBox extends StatelessWidget {
  final double height;
  const HeightBox({super.key, required this.height});

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}

class WidthBox extends StatelessWidget {
  final double width;
  const WidthBox({super.key, required this.width});

  @override
  Widget build(BuildContext context) => SizedBox(width: width);
}
