import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/utils/app_dimensions.dart';
import '../../../../core/utils/app_durations.dart';
import '../../../../core/utils/enums.dart';
import '../../domain/entities/geo_point.dart';
import '../../domain/entities/location_exception.dart';
import 'location_data_source.dart';

class DeviceLocationGeolocatorDataSource implements DeviceLocationDataSource {
  @override
  Future<GeoPoint> fetchDeviceLocation() async {
    if (!kIsWeb) {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw const LocationException(LocationIssue.serviceDisabled);
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        throw const LocationException(LocationIssue.permissionBlocked);
      }
      if (permission == LocationPermission.denied) {
        throw const LocationException(LocationIssue.permissionDenied);
      }
    }

    try {
      return await _readPosition();
    } on PermissionDeniedException {
      throw LocationException(await _deniedIssue());
    } on LocationServiceDisabledException {
      throw const LocationException(LocationIssue.serviceDisabled);
    } catch (_) {
      throw const LocationException(LocationIssue.unavailable);
    }
  }

  @override
  Future<bool> openSettings(LocationIssue issue) {
    if (kIsWeb) return Future.value(false);
    return issue.isServiceDisabled
        ? Geolocator.openLocationSettings()
        : Geolocator.openAppSettings();
  }

  Future<LocationIssue> _deniedIssue() async {
    try {
      final permission = await Geolocator.checkPermission();
      return permission == LocationPermission.deniedForever
          ? LocationIssue.permissionBlocked
          : LocationIssue.permissionDenied;
    } catch (_) {
      return LocationIssue.permissionDenied;
    }
  }

  Future<GeoPoint> _readPosition() async {
    for (var attempt = 1; ; attempt++) {
      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
        ).timeout(AppDurations.locationTimeout);

        return GeoPoint(latitude: position.latitude, longitude: position.longitude);
      } on PermissionDeniedException {
        rethrow;
      } on LocationServiceDisabledException {
        rethrow;
      } catch (_) {
        if (attempt >= AppDimensions.locationAttempts) rethrow;
        await Future<void>.delayed(AppDurations.slow);
      }
    }
  }
}
