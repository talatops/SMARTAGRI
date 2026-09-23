import 'package:flutter/material.dart';

import '../../../../core/utils/enums.dart';

@immutable
class LocationException implements Exception {
  final LocationIssue issue;

  const LocationException(this.issue);
}
