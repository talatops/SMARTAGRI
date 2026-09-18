class ControlModel {
  final String cropProfile;
  final String mode;
  final bool pumpCommand;
  final bool pumpStatus;

  const ControlModel({
    required this.cropProfile,
    required this.mode,
    required this.pumpCommand,
    required this.pumpStatus,
  });

  factory ControlModel.fromMap(Map<dynamic, dynamic> map) {
    return ControlModel(
      cropProfile: map['crop_profile']?.toString() ?? '',
      mode: map['mode']?.toString() ?? 'AUTO',
      pumpCommand: map['pump_command'] == true,
      pumpStatus: map['pump_status'] == true,
    );
  }
}