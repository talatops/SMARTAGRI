import 'package:flutter/material.dart';

import '../../../../core/utils/enums.dart';

@immutable
class IrrigationState {
  final PumpMode mode;
  final bool isPumpOn;

  const IrrigationState({required this.mode, required this.isPumpOn});

  IrrigationState copyWith({PumpMode? mode, bool? isPumpOn}) =>
      IrrigationState(mode: mode ?? this.mode, isPumpOn: isPumpOn ?? this.isPumpOn);
}
