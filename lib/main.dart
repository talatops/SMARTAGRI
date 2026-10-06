import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.signInAnonymously();

  if(kDebugMode){
    final credential = await FirebaseAuth.instance.signInAnonymously();
    debugPrint('Anonymous login successful');
    debugPrint('UID: ${credential.user?.uid}');
    debugPrint('Is Anonymous: ${credential.user?.isAnonymous}');
  }

  runApp(const ProviderScope(child: SmartAgriApp()));
}
