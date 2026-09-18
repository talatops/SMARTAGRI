// firebase_database_provider.dart

import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_database_provider.g.dart';

@riverpod
FirebaseDatabase firebaseDatabase(Ref ref) {
  return FirebaseDatabase.instance;
}