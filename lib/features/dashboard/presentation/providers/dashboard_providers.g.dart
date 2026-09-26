// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(clock)
final clockProvider = ClockProvider._();

final class ClockProvider
    extends
        $FunctionalProvider<
          DateTime Function(),
          DateTime Function(),
          DateTime Function()
        >
    with $Provider<DateTime Function()> {
  ClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockHash();

  @$internal
  @override
  $ProviderElement<DateTime Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DateTime Function() create(Ref ref) {
    return clock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime Function()>(value),
    );
  }
}

String _$clockHash() => r'3f65ad34ac6fcd532de9004042bdf2ed2bd85b13';

@ProviderFor(dashboardDataSource)
final dashboardDataSourceProvider = DashboardDataSourceProvider._();

final class DashboardDataSourceProvider
    extends
        $FunctionalProvider<
          DashboardDataSource,
          DashboardDataSource,
          DashboardDataSource
        >
    with $Provider<DashboardDataSource> {
  DashboardDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardDataSourceHash();

  @$internal
  @override
  $ProviderElement<DashboardDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DashboardDataSource create(Ref ref) {
    return dashboardDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DashboardDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DashboardDataSource>(value),
    );
  }
}

String _$dashboardDataSourceHash() =>
    r'9aa3bd9c3c7ac155e335b896461af17b52f751ef';

@ProviderFor(sensorHistoryDataSource)
final sensorHistoryDataSourceProvider = SensorHistoryDataSourceProvider._();

final class SensorHistoryDataSourceProvider
    extends
        $FunctionalProvider<
          SensorHistoryDataSource,
          SensorHistoryDataSource,
          SensorHistoryDataSource
        >
    with $Provider<SensorHistoryDataSource> {
  SensorHistoryDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sensorHistoryDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sensorHistoryDataSourceHash();

  @$internal
  @override
  $ProviderElement<SensorHistoryDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SensorHistoryDataSource create(Ref ref) {
    return sensorHistoryDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SensorHistoryDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SensorHistoryDataSource>(value),
    );
  }
}

String _$sensorHistoryDataSourceHash() =>
    r'26938d7812b2953f5024c5f6b5217720e974f765';

@ProviderFor(weatherDataSource)
final weatherDataSourceProvider = WeatherDataSourceProvider._();

final class WeatherDataSourceProvider
    extends
        $FunctionalProvider<
          WeatherDataSource,
          WeatherDataSource,
          WeatherDataSource
        >
    with $Provider<WeatherDataSource> {
  WeatherDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherDataSourceHash();

  @$internal
  @override
  $ProviderElement<WeatherDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WeatherDataSource create(Ref ref) {
    return weatherDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeatherDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeatherDataSource>(value),
    );
  }
}

String _$weatherDataSourceHash() => r'50b95b033570cc145f4c8cca04e7d7a0005ef008';

@ProviderFor(deviceLocationDataSource)
final deviceLocationDataSourceProvider = DeviceLocationDataSourceProvider._();

final class DeviceLocationDataSourceProvider
    extends
        $FunctionalProvider<
          DeviceLocationDataSource,
          DeviceLocationDataSource,
          DeviceLocationDataSource
        >
    with $Provider<DeviceLocationDataSource> {
  DeviceLocationDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceLocationDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceLocationDataSourceHash();

  @$internal
  @override
  $ProviderElement<DeviceLocationDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeviceLocationDataSource create(Ref ref) {
    return deviceLocationDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceLocationDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceLocationDataSource>(value),
    );
  }
}

String _$deviceLocationDataSourceHash() =>
    r'bcb00fd326b8d8d33272456f96e6316adfddcfec';

@ProviderFor(placeNameDataSource)
final placeNameDataSourceProvider = PlaceNameDataSourceProvider._();

final class PlaceNameDataSourceProvider
    extends
        $FunctionalProvider<
          PlaceNameDataSource,
          PlaceNameDataSource,
          PlaceNameDataSource
        >
    with $Provider<PlaceNameDataSource> {
  PlaceNameDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'placeNameDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$placeNameDataSourceHash();

  @$internal
  @override
  $ProviderElement<PlaceNameDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PlaceNameDataSource create(Ref ref) {
    return placeNameDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlaceNameDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlaceNameDataSource>(value),
    );
  }
}

String _$placeNameDataSourceHash() =>
    r'37496534d7f60cda11ae6646a1ca8f6db973be41';

@ProviderFor(dashboardRepository)
final dashboardRepositoryProvider = DashboardRepositoryProvider._();

final class DashboardRepositoryProvider
    extends
        $FunctionalProvider<
          DashboardRepository,
          DashboardRepository,
          DashboardRepository
        >
    with $Provider<DashboardRepository> {
  DashboardRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardRepositoryHash();

  @$internal
  @override
  $ProviderElement<DashboardRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DashboardRepository create(Ref ref) {
    return dashboardRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DashboardRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DashboardRepository>(value),
    );
  }
}

String _$dashboardRepositoryHash() =>
    r'3e98fdb819eb3c35109a9227d9690ac34a2a00da';

@ProviderFor(sensorHistoryRepository)
final sensorHistoryRepositoryProvider = SensorHistoryRepositoryProvider._();

final class SensorHistoryRepositoryProvider
    extends
        $FunctionalProvider<
          SensorHistoryRepository,
          SensorHistoryRepository,
          SensorHistoryRepository
        >
    with $Provider<SensorHistoryRepository> {
  SensorHistoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sensorHistoryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sensorHistoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<SensorHistoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SensorHistoryRepository create(Ref ref) {
    return sensorHistoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SensorHistoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SensorHistoryRepository>(value),
    );
  }
}

String _$sensorHistoryRepositoryHash() =>
    r'c132abe46bcdbc18037451f4433ac3738b4739a8';

@ProviderFor(weatherRepository)
final weatherRepositoryProvider = WeatherRepositoryProvider._();

final class WeatherRepositoryProvider
    extends
        $FunctionalProvider<
          WeatherRepository,
          WeatherRepository,
          WeatherRepository
        >
    with $Provider<WeatherRepository> {
  WeatherRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherRepositoryHash();

  @$internal
  @override
  $ProviderElement<WeatherRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WeatherRepository create(Ref ref) {
    return weatherRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeatherRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeatherRepository>(value),
    );
  }
}

String _$weatherRepositoryHash() => r'1e6cab75948923a25fdd4da456abf14771092bac';

@ProviderFor(locationRepository)
final locationRepositoryProvider = LocationRepositoryProvider._();

final class LocationRepositoryProvider
    extends
        $FunctionalProvider<
          LocationRepository,
          LocationRepository,
          LocationRepository
        >
    with $Provider<LocationRepository> {
  LocationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationRepositoryHash();

  @$internal
  @override
  $ProviderElement<LocationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocationRepository create(Ref ref) {
    return locationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationRepository>(value),
    );
  }
}

String _$locationRepositoryHash() =>
    r'6f744c68ffb28a4e8a02ed34a859187429e87c28';

@ProviderFor(getCurrentWeatherUseCase)
final getCurrentWeatherUseCaseProvider = GetCurrentWeatherUseCaseProvider._();

final class GetCurrentWeatherUseCaseProvider
    extends
        $FunctionalProvider<
          GetCurrentWeatherUseCase,
          GetCurrentWeatherUseCase,
          GetCurrentWeatherUseCase
        >
    with $Provider<GetCurrentWeatherUseCase> {
  GetCurrentWeatherUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCurrentWeatherUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCurrentWeatherUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetCurrentWeatherUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetCurrentWeatherUseCase create(Ref ref) {
    return getCurrentWeatherUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetCurrentWeatherUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetCurrentWeatherUseCase>(value),
    );
  }
}

String _$getCurrentWeatherUseCaseHash() =>
    r'e17d96c0e6a70a66c100e07fb9c38c950a2119eb';

@ProviderFor(getDeviceLocationUseCase)
final getDeviceLocationUseCaseProvider = GetDeviceLocationUseCaseProvider._();

final class GetDeviceLocationUseCaseProvider
    extends
        $FunctionalProvider<
          GetDeviceLocationUseCase,
          GetDeviceLocationUseCase,
          GetDeviceLocationUseCase
        >
    with $Provider<GetDeviceLocationUseCase> {
  GetDeviceLocationUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getDeviceLocationUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getDeviceLocationUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetDeviceLocationUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetDeviceLocationUseCase create(Ref ref) {
    return getDeviceLocationUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetDeviceLocationUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetDeviceLocationUseCase>(value),
    );
  }
}

String _$getDeviceLocationUseCaseHash() =>
    r'594f7bafe5466e8411b6a05bdce371f1c1947345';

@ProviderFor(getPlaceNameUseCase)
final getPlaceNameUseCaseProvider = GetPlaceNameUseCaseProvider._();

final class GetPlaceNameUseCaseProvider
    extends
        $FunctionalProvider<
          GetPlaceNameUseCase,
          GetPlaceNameUseCase,
          GetPlaceNameUseCase
        >
    with $Provider<GetPlaceNameUseCase> {
  GetPlaceNameUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getPlaceNameUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getPlaceNameUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetPlaceNameUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetPlaceNameUseCase create(Ref ref) {
    return getPlaceNameUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetPlaceNameUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetPlaceNameUseCase>(value),
    );
  }
}

String _$getPlaceNameUseCaseHash() =>
    r'5c8f2ec7f8c232a28ec2906d49169f6d05428a26';

@ProviderFor(openLocationSettingsUseCase)
final openLocationSettingsUseCaseProvider =
    OpenLocationSettingsUseCaseProvider._();

final class OpenLocationSettingsUseCaseProvider
    extends
        $FunctionalProvider<
          OpenLocationSettingsUseCase,
          OpenLocationSettingsUseCase,
          OpenLocationSettingsUseCase
        >
    with $Provider<OpenLocationSettingsUseCase> {
  OpenLocationSettingsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openLocationSettingsUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openLocationSettingsUseCaseHash();

  @$internal
  @override
  $ProviderElement<OpenLocationSettingsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OpenLocationSettingsUseCase create(Ref ref) {
    return openLocationSettingsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OpenLocationSettingsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OpenLocationSettingsUseCase>(value),
    );
  }
}

String _$openLocationSettingsUseCaseHash() =>
    r'2f270454128c9bb922cf470529b30b04327cc1b8';

@ProviderFor(getDashboardSnapshotUseCase)
final getDashboardSnapshotUseCaseProvider =
    GetDashboardSnapshotUseCaseProvider._();

final class GetDashboardSnapshotUseCaseProvider
    extends
        $FunctionalProvider<
          GetDashboardSnapshotUseCase,
          GetDashboardSnapshotUseCase,
          GetDashboardSnapshotUseCase
        >
    with $Provider<GetDashboardSnapshotUseCase> {
  GetDashboardSnapshotUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getDashboardSnapshotUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getDashboardSnapshotUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetDashboardSnapshotUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetDashboardSnapshotUseCase create(Ref ref) {
    return getDashboardSnapshotUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetDashboardSnapshotUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetDashboardSnapshotUseCase>(value),
    );
  }
}

String _$getDashboardSnapshotUseCaseHash() =>
    r'41ae3956a8885bf4ac9efa062b0bfbe09e0ea595';

@ProviderFor(watchDashboardSnapshotUseCase)
final watchDashboardSnapshotUseCaseProvider =
    WatchDashboardSnapshotUseCaseProvider._();

final class WatchDashboardSnapshotUseCaseProvider
    extends
        $FunctionalProvider<
          WatchDashboardSnapshotUseCase,
          WatchDashboardSnapshotUseCase,
          WatchDashboardSnapshotUseCase
        >
    with $Provider<WatchDashboardSnapshotUseCase> {
  WatchDashboardSnapshotUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchDashboardSnapshotUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchDashboardSnapshotUseCaseHash();

  @$internal
  @override
  $ProviderElement<WatchDashboardSnapshotUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WatchDashboardSnapshotUseCase create(Ref ref) {
    return watchDashboardSnapshotUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WatchDashboardSnapshotUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WatchDashboardSnapshotUseCase>(
        value,
      ),
    );
  }
}

String _$watchDashboardSnapshotUseCaseHash() =>
    r'a7dc748f71ab33e70fc42926b72891d234605fca';

@ProviderFor(watchSensorHistoryUseCase)
final watchSensorHistoryUseCaseProvider = WatchSensorHistoryUseCaseProvider._();

final class WatchSensorHistoryUseCaseProvider
    extends
        $FunctionalProvider<
          WatchSensorHistoryUseCase,
          WatchSensorHistoryUseCase,
          WatchSensorHistoryUseCase
        >
    with $Provider<WatchSensorHistoryUseCase> {
  WatchSensorHistoryUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchSensorHistoryUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchSensorHistoryUseCaseHash();

  @$internal
  @override
  $ProviderElement<WatchSensorHistoryUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WatchSensorHistoryUseCase create(Ref ref) {
    return watchSensorHistoryUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WatchSensorHistoryUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WatchSensorHistoryUseCase>(value),
    );
  }
}

String _$watchSensorHistoryUseCaseHash() =>
    r'b75ecb470fff366312cb7b0d14aa3e57ec444ba6';

@ProviderFor(setPumpModeUseCase)
final setPumpModeUseCaseProvider = SetPumpModeUseCaseProvider._();

final class SetPumpModeUseCaseProvider
    extends
        $FunctionalProvider<
          SetPumpModeUseCase,
          SetPumpModeUseCase,
          SetPumpModeUseCase
        >
    with $Provider<SetPumpModeUseCase> {
  SetPumpModeUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setPumpModeUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setPumpModeUseCaseHash();

  @$internal
  @override
  $ProviderElement<SetPumpModeUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SetPumpModeUseCase create(Ref ref) {
    return setPumpModeUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SetPumpModeUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SetPumpModeUseCase>(value),
    );
  }
}

String _$setPumpModeUseCaseHash() =>
    r'ea1081327a9fec85de67f34db550047015184eb4';

@ProviderFor(togglePumpUseCase)
final togglePumpUseCaseProvider = TogglePumpUseCaseProvider._();

final class TogglePumpUseCaseProvider
    extends
        $FunctionalProvider<
          TogglePumpUseCase,
          TogglePumpUseCase,
          TogglePumpUseCase
        >
    with $Provider<TogglePumpUseCase> {
  TogglePumpUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'togglePumpUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$togglePumpUseCaseHash();

  @$internal
  @override
  $ProviderElement<TogglePumpUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TogglePumpUseCase create(Ref ref) {
    return togglePumpUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TogglePumpUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TogglePumpUseCase>(value),
    );
  }
}

String _$togglePumpUseCaseHash() => r'8c423bbe7b4bd9e00e1d5f7185d27f741c8ce709';

@ProviderFor(selectCropUseCase)
final selectCropUseCaseProvider = SelectCropUseCaseProvider._();

final class SelectCropUseCaseProvider
    extends
        $FunctionalProvider<
          SelectCropUseCase,
          SelectCropUseCase,
          SelectCropUseCase
        >
    with $Provider<SelectCropUseCase> {
  SelectCropUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectCropUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectCropUseCaseHash();

  @$internal
  @override
  $ProviderElement<SelectCropUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SelectCropUseCase create(Ref ref) {
    return selectCropUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SelectCropUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SelectCropUseCase>(value),
    );
  }
}

String _$selectCropUseCaseHash() => r'baad7588f259e593846ee062ed077dfd084b7097';

@ProviderFor(saveWeatherUseCase)
final saveWeatherUseCaseProvider = SaveWeatherUseCaseProvider._();

final class SaveWeatherUseCaseProvider
    extends
        $FunctionalProvider<
          SaveWeatherUseCase,
          SaveWeatherUseCase,
          SaveWeatherUseCase
        >
    with $Provider<SaveWeatherUseCase> {
  SaveWeatherUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'saveWeatherUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$saveWeatherUseCaseHash();

  @$internal
  @override
  $ProviderElement<SaveWeatherUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SaveWeatherUseCase create(Ref ref) {
    return saveWeatherUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SaveWeatherUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SaveWeatherUseCase>(value),
    );
  }
}

String _$saveWeatherUseCaseHash() =>
    r'008419f59d5b9712cfac5b486bbb9c2e7571bb5e';
