abstract final class AppStrings {
  static const appName = 'Smart Agriculture System';
  static const poweredBy = 'Copyright 2026 - IRADA Islamabad, PK';
  static const appNamePrefix = 'Smart Agriculture';
  static const appNameSuffix = 'System';
  static const tagline1 = 'Smarter Water';
  static const tagline2 = 'Healthier Crops';
  static const tagline3 = 'Higher Yields';
  static const location = 'Islamabad, PK';

  static const soilPanelTitle = 'Soil & Field Water Metrics';
  static const soilPanelSubtitle =
      'Real-time soil moisture levels and field water status';
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
  static const telemetrySubtitle =
      'Live microclimate data from on-board sensors';
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
  static const raining = 'Raining';
  static const rainForecast = 'Rain Forecast';
  static const windSpeed = 'Wind Speed';
  static const humidity = 'Humidity';
  static const clearSky = 'Clear Sky';
  static const mainlyClear = 'Mainly Clear';
  static const overcast = 'Overcast';
  static const fog = 'Fog';
  static const drizzle = 'Drizzle';
  static const snow = 'Snow';
  static const rainShowers = 'Rain Showers';
  static const snowShowers = 'Snow Showers';
  static const thunderstorm = 'Thunderstorm';
  static const thunderstormHail = 'Thunderstorm with Hail';
  static const freezingDrizzle = 'Freezing Drizzle';
  static const heavyRain = 'Heavy Rain';
  static const freezingRain = 'Freezing Rain';
  static const heavySnow = 'Heavy Snow';
  static const snowGrains = 'Snow Grains';
  static const heavyRainShowers = 'Heavy Rain Showers';
  static const unknownCondition = 'Unknown';
  static const weatherUnavailable = 'Weather unavailable';
  static const locationUnavailable = 'Location unavailable';
  static const locationSeparator = ', ';
  static const locationPermissionDenied =
      'Allow location access to see the weather for your field.';
  static const locationPermissionBlocked =
      'Location access is blocked. Enable it in settings to see the weather for your field.';
  static const locationPermissionBlockedWeb =
      'Location access is blocked. Click the site icon in the address bar, allow Location, then try again.';
  static const locationServiceDisabled =
      'Location services are turned off. Turn them on to see the weather for your field.';
  static const locationFetchFailed =
      'Couldn\'t get your location. Please try again.';
  static const allowLocation = 'Allow Location';
  static const openSettings = 'Open Settings';
  static const tryAgain = 'Try Again';
  static const noValue = '--';

  static const cropTitle = 'Crop Profile';
  static const cropSubtitle = 'Tap a crop to set it active';
  static const colCrop = 'Crop';
  static const colRange = 'Acceptable Moisture Range';
  static const wheat = 'Wheat';
  static const rice = 'Rice';
  static const cotton = 'Cotton';
  static const sugarcane = 'Sugarcane';
  static const maize = 'Maize';

  static const historySoilTitle = 'Historical Soil Moisture Analytics';
  static const historySoilSubtitle = 'Soil moisture levels across different depths and composite';
  static const historyTemperatureTitle = 'Temperature Comparison';
  static const historyTemperatureSubtitle = 'Field telemetry vs Weather API temperature';
  static const historyHumidityTitle = 'Field Telemetry Humidity';
  static const historyHumiditySubtitle = 'Relative humidity from field sensors and weather API';
  static const historyPumpTitle = 'Pump ON/OFF History';
  static const historyPumpSubtitle = 'Irrigation pump status';
  static const historyRangeTooltip = 'Select time range';
  static const today = 'Today';
  static const last6Hours = 'Last 6 Hours';
  static const last12Hours = 'Last 12 Hours';
  static const last24Hours = 'Last 24 Hours';
  static const timeAxisToday = 'Time (Today)';
  static const timeAxis6Hours = 'Time (6 Hours)';
  static const timeAxis12Hours = 'Time (12 Hours)';
  static const timeAxis24Hours = 'Time (24 Hours)';
  static const moistureAxis = 'Moisture Level (%)';
  static const temperatureAxis = 'Temperature (°C)';
  static const humidityAxis = 'Humidity (%)';
  static const surfaceSeries = 'Surface (5cm)';
  static const rootSeries = 'Root (20cm)';
  static const deepSeries = 'Deep (40cm)';
  static const compositeSeries = 'Composite';
  static const fieldTemperatureSeries = 'Field Telemetry Temperature';
  static const weatherTemperatureSeries = 'Weather API Temperature';
  static const fieldHumiditySeries = 'Field Humidity (Sensor)';
  static const weatherHumiditySeries = 'Weather API Humidity';
  static const pumpStatusSeries = 'Pump Status';
  static const tooltipSeparator = ': ';

  static const lastUpdated = 'Last Updated: ';
  static const appVersion = 'v1.0.0';

  static const refreshTooltip = 'Refresh dashboard';

  static const loadingDashboard = 'Loading dashboard…';
  static const taglineSeparator = ' · ';
}
