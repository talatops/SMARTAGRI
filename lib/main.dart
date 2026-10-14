
import 'package:firebase_auth_web/firebase_auth_web.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  // if(kDebugMode){+
  FirebaseAuthWeb.instance;
  final auth = FirebaseAuthWeb.instance;
  final credential = await auth.signInWithEmailAndPassword(
     'abdul.hanan@irada.pk',
    'test@1234',
  );

  print(credential.user?.uid);



    // final credential = await FirebaseAuth.instance.signInAnonymously();
    // debugPrint('Anonymous login successful');
    // debugPrint('UID: ${credential.user?.uid}');
    // debugPrint('Is Anonymous: ${credential.user?.isAnonymous}');
  // }

  runApp(const ProviderScope(child: SmartAgriApp()));
}
