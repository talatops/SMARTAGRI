abstract final class AppStrings {
  static const appName = 'Smart Agriculture System';
  static const appNamePrefix = 'Smart Agriculture';
  static const appNameSuffix = 'System';
  static const tagline1 = 'Smarter Water';
  static const tagline2 = 'Healthier Crops';
  static const tagline3 = 'Higher Yields';
  static const location = 'Islamabad, PK';

  static const soilPanelTitle = 'Soil & Field Water Metrics';
  static const soilPanelSubtitle = 'Real-time soil moisture levels and field water status';
  static const surfaceZone = 'Surface Zone';
  static const rootZone = 'Root Zone';
  static const deepZone = 'Deep Zone';
  static const depth5cm = '(5 cm)';
  static const depth20cm = '(20 cm)';
  static const depth40cm = '(40 cm)';
  static const moistureLevel = 'Moisture Level';
  static const fieldWaterLevel = 'Field Water Level';
  static const waterLevel = 'Water Level';
  static const normalOk = 'Normal / OK';

  static const compositeTitle = 'Composite Soil Moisture';
  static const compositeSubtitle = 'Calculated from all depth sensors';
  static const compositeScore = 'Composite Score';
  static const optimalSoilMoisture = 'Optimal Soil Moisture';
  static const optimalDescription =
      'Soil moisture level is within optimal range for healthy crop growth.';
  static const belowRangeTitle = 'Low Soil Moisture';
  static const belowRangeDescription =
      'Soil moisture is below the acceptable range for the selected crop. '
      'Irrigation is recommended.';
  static const aboveRangeTitle = 'Excess Soil Moisture';
  static const aboveRangeDescription =
      'Soil moisture is above the acceptable range for the selected crop. '
      'Hold irrigation to avoid waterlogging.';

  static const telemetryTitle = 'Field Telemetry';
  static const telemetrySubtitle = 'Live microclimate data from on-board sensors';
  static const temperature = 'Temperature';
  static const relativeHumidity = 'Relative Humidity';
  static const normal = 'Normal';
  static const warning = 'Warning';
  static const critical = 'Critical';

  static const irrigationTitle = 'Irrigation Control';
  static const irrigationSubtitle = 'Manage pump and irrigation settings';
  static const auto = 'AUTO';
  static const manual = 'MANUAL';
  static const pumpOn = 'PUMP ON';
  static const pumpOff = 'PUMP OFF';
  static const statusLabel = 'Status:';
  static const on = 'ON';
  static const off = 'OFF';
  static const pumpDisabled = 'Pump is currently disabled';
  static const pumpEnabled = 'Pump is currently running';

  static const weatherTitle = 'Weather Status';
  static const weatherSubtitle = 'External weather forecast';
  static const partlyCloudy = 'Partly Cloudy';
  static const rainForecast = 'Rain Forecast';
  static const windSpeed = 'Wind Speed';
  static const humidity = 'Humidity';

  static const cropTitle = 'Crop Profile';
  static const cropSubtitle = 'Tap a crop to set it active';
  static const colCrop = 'Crop';
  static const colRange = 'Acceptable Moisture Range';
  static const wheat = 'Wheat';
  static const rice = 'Rice';
  static const cotton = 'Cotton';
  static const sugarcane = 'Sugarcane';
  static const maize = 'Maize';

  static const lastUpdated = 'Last Updated: ';
  static const appVersion = 'v1.0.0';

  static const refreshTooltip = 'Refresh dashboard';
}
