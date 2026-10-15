import 'package:flutter/material.dart';

import '../../../../core/utils/enums.dart';

@immutable
class IrrigationState {
  final PumpMode mode;
  final bool isPumpCommandOn;
  final bool isPumpOn;
  final String? irrigationNeed;

  const IrrigationState({
    required this.mode,
    required this.isPumpCommandOn,
    required this.isPumpOn,
    this.irrigationNeed,
  });

  IrrigationState copyWith({PumpMode? mode, bool? isPumpCommandOn, bool? isPumpOn}) =>
      IrrigationState(
        mode: mode ?? this.mode,
        isPumpCommandOn: isPumpCommandOn ?? this.isPumpCommandOn,
        isPumpOn: isPumpOn ?? this.isPumpOn,
        irrigationNeed: irrigationNeed,
      );
}
