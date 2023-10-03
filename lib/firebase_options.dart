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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyCQ0VKFsFUlxDYJodAJyJiPnAAY5T1m5Vk',
    appId: '1:253454957943:web:bd0d4538d8362c4e80f572',
    messagingSenderId: '253454957943',
    projectId: 'bts-portal',
    authDomain: 'bts-portal.firebaseapp.com',
    storageBucket: 'bts-portal.appspot.com',
    measurementId: 'G-1YMD2H9EWE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCTKckKKUBkgDDJsBxX5vNQ4db8Kkt2gAs',
    appId: '1:253454957943:android:e3035c03501dc80180f572',
    messagingSenderId: '253454957943',
    projectId: 'bts-portal',
    storageBucket: 'bts-portal.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDiO6FMC-HAaTKeqNXZsYM7sYMgHA4XDkA',
    appId: '1:253454957943:ios:1a715591c138831e80f572',
    messagingSenderId: '253454957943',
    projectId: 'bts-portal',
    storageBucket: 'bts-portal.appspot.com',
    iosClientId: '253454957943-fqnd863v31ho893vgenirfdpqemdkaht.apps.googleusercontent.com',
    iosBundleId: 'com.example.homePage',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDiO6FMC-HAaTKeqNXZsYM7sYMgHA4XDkA',
    appId: '1:253454957943:ios:1f6e91fdd1db0dd680f572',
    messagingSenderId: '253454957943',
    projectId: 'bts-portal',
    storageBucket: 'bts-portal.appspot.com',
    iosClientId: '253454957943-uuhq3jfgk34kf21buihb7vg92402ldsg.apps.googleusercontent.com',
    iosBundleId: 'com.example.homePage.RunnerTests',
  );
}