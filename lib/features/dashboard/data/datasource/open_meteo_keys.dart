abstract final class OpenMeteoKeys {
  static const forecastUrl = 'https://api.open-meteo.com/v1/forecast';

  static const latitudeParam = 'latitude';
  static const longitudeParam = 'longitude';
  static const currentParam = 'current';
  static const timezoneParam = 'timezone';
  static const timezoneAuto = 'auto';

  static const current = 'current';
  static const temperature = 'temperature_2m';
  static const humidity = 'relative_humidity_2m';
  static const weatherCode = 'weather_code';
  static const windSpeed = 'wind_speed_10m';
  static const precipitationProbability = 'precipitation_probability';

  static const currentFields = [
    temperature,
    humidity,
    weatherCode,
    windSpeed,
    precipitationProbability,
  ];
}
