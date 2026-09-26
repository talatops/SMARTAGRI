import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA1clS9XIfoMPffrmfavCxnxawG2he_Ldw',
    appId: '1:775461214160:web:8c5e3b6c3fa946f75b8bd5',
    messagingSenderId: '775461214160',
    projectId: 'smart-agri-system-model',
    authDomain: 'smart-agri-system-model.firebaseapp.com',
    databaseURL: 'https://smart-agri-system-model-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'smart-agri-system-model.firebasestorage.app',
    measurementId: 'G-WL9VCHDVDC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBUPDalBi6maSJzxAa6cIszZKng0P02hZg',
    appId: '1:775461214160:android:8940e430e57e4f685b8bd5',
    messagingSenderId: '775461214160',
    projectId: 'smart-agri-system-model',
    databaseURL: 'https://smart-agri-system-model-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'smart-agri-system-model.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyChhRjvZTGdyrNb8oSxPXNA9OK9upGBBKI',
    appId: '1:775461214160:ios:1915043e034ea4d75b8bd5',
    messagingSenderId: '775461214160',
    projectId: 'smart-agri-system-model',
    databaseURL: 'https://smart-agri-system-model-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'smart-agri-system-model.firebasestorage.app',
    iosBundleId: 'com.irada.sas',
  );
}
