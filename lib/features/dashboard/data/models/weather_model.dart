class WeatherModel {
  final bool isRaining;
  final double rainProbability;
  final double temperatureC;

  const WeatherModel({
    required this.isRaining,
    required this.rainProbability,
    required this.temperatureC,
  });

  factory WeatherModel.fromMap(Map<dynamic, dynamic> map) {
    return WeatherModel(
      isRaining: map['is_raining'] == true,
      rainProbability:
          (map['rain_probability'] as num?)?.toDouble() ?? 0,
      temperatureC:
          (map['temperature_c'] as num?)?.toDouble() ?? 0,
    );
  }
}