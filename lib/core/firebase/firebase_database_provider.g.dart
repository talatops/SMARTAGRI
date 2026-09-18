// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_database_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(firebaseDatabase)
final firebaseDatabaseProvider = FirebaseDatabaseProvider._();

final class FirebaseDatabaseProvider
    extends
        $FunctionalProvider<
          FirebaseDatabase,
          FirebaseDatabase,
          FirebaseDatabase
        >
    with $Provider<FirebaseDatabase> {
  FirebaseDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseDatabaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseDatabaseHash();

  @$internal
  @override
  $ProviderElement<FirebaseDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FirebaseDatabase create(Ref ref) {
    return firebaseDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseDatabase>(value),
    );
  }
}

String _$firebaseDatabaseHash() => r'141907a52ab6fcfd89fb1dd69ae56a707f20868a';
