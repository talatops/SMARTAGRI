import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/utils/app_dimensions.dart';
import '../../../../core/utils/app_durations.dart';
import '../../domain/entities/geo_point.dart';
import 'location_data_source.dart';

class DeviceLocationGeolocatorDataSource implements DeviceLocationDataSource {
  @override
  Future<GeoPoint> fetchDeviceLocation() async {
    if (!kIsWeb) {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception(permission.name);
      }
    }

    return _readPosition();
  }

  Future<GeoPoint> _readPosition() async {
    for (var attempt = 1; ; attempt++) {
      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
        ).timeout(AppDurations.locationTimeout);

        return GeoPoint(latitude: position.latitude, longitude: position.longitude);
      } catch (_) {
        if (attempt >= AppDimensions.locationAttempts) rethrow;
        await Future<void>.delayed(AppDurations.slow);
      }
    }
  }
}
