// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCw4K-4y5TIFc6cVTLWaDFKjQQ3cytqpWQ',
    appId: '1:670155865500:android:73486d46ba9a6c4000dc59',
    messagingSenderId: '670155865500',
    projectId: 'etiop-b0051',
    storageBucket: 'etiop-b0051.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDBvszB0AzifB7kasMw171XaEki-rWKguI',
    appId: '1:670155865500:web:a7ee7e30709ba0b700dc59',
    messagingSenderId: '670155865500',
    projectId: 'etiop-b0051',
    authDomain: 'etiop-b0051.firebaseapp.com',
    storageBucket: 'etiop-b0051.firebasestorage.app',
    measurementId: 'G-38WJ0G4CZY',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDK8AfB4Rn_uB4akI5XwGSDHp2RbMzBuAo',
    appId: '1:670155865500:ios:d88d22c77b74353000dc59',
    messagingSenderId: '670155865500',
    projectId: 'etiop-b0051',
    storageBucket: 'etiop-b0051.firebasestorage.app',
    iosBundleId: 'com.example.etiopApplication',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDK8AfB4Rn_uB4akI5XwGSDHp2RbMzBuAo',
    appId: '1:670155865500:ios:e6a6f8780144f89100dc59',
    messagingSenderId: '670155865500',
    projectId: 'etiop-b0051',
    storageBucket: 'etiop-b0051.firebasestorage.app',
    iosBundleId: 'com.atc.etiop',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDBvszB0AzifB7kasMw171XaEki-rWKguI',
    appId: '1:670155865500:web:d58593c2c02e4e7a00dc59',
    messagingSenderId: '670155865500',
    projectId: 'etiop-b0051',
    authDomain: 'etiop-b0051.firebaseapp.com',
    storageBucket: 'etiop-b0051.firebasestorage.app',
    measurementId: 'G-CBDVCN52RN',
  );

}