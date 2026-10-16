
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  // if(kDebugMode){+
  FirebaseAuth.instance;
  final auth = FirebaseAuth.instance;
  final credential = await auth.signInWithEmailAndPassword(
     email:  'abdul.hanan@irada.pk',
    password:  'test@1234',
  );

  print(credential.user?.uid);


  runApp(const ProviderScope(child: SmartAgriApp()));

}
