// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBid9zCORxOheEA_VEZc86TgRJu2OvmKfE',
    appId: '1:965375790662:web:64d79a936425ad2be50447',
    messagingSenderId: '965375790662',
    projectId: 'e-commerce-app-20dbd',
    authDomain: 'e-commerce-app-20dbd.firebaseapp.com',
    storageBucket: 'e-commerce-app-20dbd.appspot.com',
    measurementId: 'G-0ZLGZB4B50',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB0R8SsbDfgiu51XegCVRb1OK_DiAsyDsY',
    appId: '1:965375790662:android:a6f5c536a96921fde50447',
    messagingSenderId: '965375790662',
    projectId: 'e-commerce-app-20dbd',
    storageBucket: 'e-commerce-app-20dbd.appspot.com',
  );
}
