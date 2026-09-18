import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
    required this.largeWeb,
  });

  final Widget mobile;
  final Widget tablet;
  final Widget desktop;
  final Widget largeWeb;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        if (constraints.maxWidth >= 1441) {
          return largeWeb;
        }

        if (constraints.maxWidth >= 993) {
          return desktop;
        }

        if (constraints.maxWidth >= 577) {
          return tablet;
        }

        return mobile;
      },
    );
  }
}