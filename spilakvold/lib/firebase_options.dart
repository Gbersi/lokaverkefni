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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAfdfMKCXFxzt9zZzNsbdkHShtYMmSBYtg',
    appId: '1:50837171146:web:48d8fd56daa34454d93d33',
    messagingSenderId: '50837171146',
    projectId: 'spilakvold',
    authDomain: 'spilakvold.firebaseapp.com',
    storageBucket: 'spilakvold.firebasestorage.app',
    measurementId: 'G-TG4NY7ESGN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCDMSg8Wj5vSLiPAPD510DC0KjwVvmIAdg',
    appId: '1:50837171146:android:baae61f1be15c919d93d33',
    messagingSenderId: '50837171146',
    projectId: 'spilakvold',
    storageBucket: 'spilakvold.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCEj0gEPGmBNiPNIdj7dskDjuZmIcCjnqc',
    appId: '1:50837171146:ios:ba2ab42d89e95341d93d33',
    messagingSenderId: '50837171146',
    projectId: 'spilakvold',
    storageBucket: 'spilakvold.firebasestorage.app',
    iosClientId: '50837171146-u0r1elov8ilu0u6k08n5jkr43fmp386u.apps.googleusercontent.com',
    iosBundleId: 'com.example.spilakvold',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCEj0gEPGmBNiPNIdj7dskDjuZmIcCjnqc',
    appId: '1:50837171146:ios:ba2ab42d89e95341d93d33',
    messagingSenderId: '50837171146',
    projectId: 'spilakvold',
    storageBucket: 'spilakvold.firebasestorage.app',
    iosClientId: '50837171146-u0r1elov8ilu0u6k08n5jkr43fmp386u.apps.googleusercontent.com',
    iosBundleId: 'com.example.spilakvold',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAfdfMKCXFxzt9zZzNsbdkHShtYMmSBYtg',
    appId: '1:50837171146:web:39cacb8351c48f76d93d33',
    messagingSenderId: '50837171146',
    projectId: 'spilakvold',
    authDomain: 'spilakvold.firebaseapp.com',
    storageBucket: 'spilakvold.firebasestorage.app',
    measurementId: 'G-WT1TRJDD38',
  );
}
