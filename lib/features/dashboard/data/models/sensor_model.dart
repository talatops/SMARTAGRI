class SensorModel {
  final String soilMoistureStatus;
  final double compositeMoisture;
  final double humidity;
  final double soil5cm;
  final double soil20cm;
  final double soil40cm;
  final double temperature;
  final double waterLevel;

  const SensorModel({
    required this.soilMoistureStatus,
    required this.compositeMoisture,
    required this.humidity,
    required this.soil5cm,
    required this.soil20cm,
    required this.soil40cm,
    required this.temperature,
    required this.waterLevel,
  });

  factory SensorModel.fromMap(Map<dynamic, dynamic> map) {
    return SensorModel(
      soilMoistureStatus:
          map['c_soil_moisture_st']?.toString() ?? '',
      compositeMoisture:
          (map['composite_moisture'] as num?)?.toDouble() ?? 0,
      humidity:
          (map['humidity'] as num?)?.toDouble() ?? 0,
      soil5cm:
          (map['soil_5cm'] as num?)?.toDouble() ?? 0,
      soil20cm:
          (map['soil_20cm'] as num?)?.toDouble() ?? 0,
      soil40cm:
          (map['soil_40cm'] as num?)?.toDouble() ?? 0,
      temperature:
          (map['temperature'] as num?)?.toDouble() ?? 0,
      waterLevel:
          (map['water_level'] as num?)?.toDouble() ?? 0,
    );
  }
}