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
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCphgLwb_2UG7nxg3TY4zzZqIjNbXZd1sA',
    appId: '1:730684313659:android:3d52c3b0ea81314e',
    messagingSenderId: '730684313659',
    projectId: 'i-attend-705aa',
    databaseURL: 'https://i-attend-705aa.firebaseio.com',
    storageBucket: 'i-attend-705aa.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAhmq3oOXSCW1CiIFTzczMMg9f2pFraW88',
    appId: '1:730684313659:ios:3d52c3b0ea81314e',
    messagingSenderId: '730684313659',
    projectId: 'i-attend-705aa',
    databaseURL: 'https://i-attend-705aa.firebaseio.com',
    storageBucket: 'i-attend-705aa.appspot.com',
    iosClientId:
        '730684313659-k5de0jbumkc08m988rej3ug6617mtdl9.apps.googleusercontent.com',
    iosBundleId: 'com.tnetic.capture',
  );

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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
}
