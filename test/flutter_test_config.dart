import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_agri_system/core/utils/app_fonts.dart';

const _interFonts = [
  'assets/fonts/inter/inter.ttf',
  'assets/fonts/inter/inter_medium.ttf',
  'assets/fonts/inter/inter_semi_bold.ttf',
  'assets/fonts/inter/inter_bold.ttf',
];

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final loader = FontLoader(AppFonts.primary);
  for (final font in _interFonts) {
    loader.addFont(rootBundle.load(font));
  }
  await loader.load();
  await testMain();
}
