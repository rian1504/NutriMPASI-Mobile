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
    apiKey: 'AIzaSyAX454tK4vQkWuXkbOoWZgCNrlKkAq-orQ',
    appId: '1:1099390437436:web:3e63cf200964dc6f499b39',
    messagingSenderId: '1099390437436',
    projectId: 'nutrimpasi-7e538',
    authDomain: 'nutrimpasi-7e538.firebaseapp.com',
    storageBucket: 'nutrimpasi-7e538.firebasestorage.app',
    measurementId: 'G-SS6HDWW80V',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyASUuOU3GCTTgCjwOexVQXXB_Qm33UWx18',
    appId: '1:1099390437436:android:87706033c8aeadb7499b39',
    messagingSenderId: '1099390437436',
    projectId: 'nutrimpasi-7e538',
    storageBucket: 'nutrimpasi-7e538.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDtxfIAEbB0-rhkh6moapxD0wW4Fb8FCgw',
    appId: '1:1099390437436:ios:972775a595cd4f7b499b39',
    messagingSenderId: '1099390437436',
    projectId: 'nutrimpasi-7e538',
    storageBucket: 'nutrimpasi-7e538.firebasestorage.app',
    iosBundleId: 'com.example.nutrimpasi',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDtxfIAEbB0-rhkh6moapxD0wW4Fb8FCgw',
    appId: '1:1099390437436:ios:972775a595cd4f7b499b39',
    messagingSenderId: '1099390437436',
    projectId: 'nutrimpasi-7e538',
    storageBucket: 'nutrimpasi-7e538.firebasestorage.app',
    iosBundleId: 'com.example.nutrimpasi',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAX454tK4vQkWuXkbOoWZgCNrlKkAq-orQ',
    appId: '1:1099390437436:web:ba3ae435b5b05d6d499b39',
    messagingSenderId: '1099390437436',
    projectId: 'nutrimpasi-7e538',
    authDomain: 'nutrimpasi-7e538.firebaseapp.com',
    storageBucket: 'nutrimpasi-7e538.firebasestorage.app',
    measurementId: 'G-YPTLD4RB1Y',
  );
}
