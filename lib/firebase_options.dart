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
    apiKey: 'AIzaSyCaA0RPO3IdjlSTmMauqjaB36R1JFup9_Y',
    appId: '1:834693505829:web:69ea7e304a519715d430cc',
    messagingSenderId: '834693505829',
    projectId: 'engelsiz-22',
    authDomain: 'engelsiz-22.firebaseapp.com',
    databaseURL: 'https://engelsiz-22-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'engelsiz-22.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC7Yd9fg9ifD_Ev4CYCK3Bb3lCL7wbYTiE',
    appId: '1:834693505829:android:2101421c673bca1fd430cc',
    messagingSenderId: '834693505829',
    projectId: 'engelsiz-22',
    databaseURL: 'https://engelsiz-22-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'engelsiz-22.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAZLFl9n-9qRUfgcb50KL7_kH0UIHmtGeI',
    appId: '1:834693505829:ios:6fec431723365c23d430cc',
    messagingSenderId: '834693505829',
    projectId: 'engelsiz-22',
    databaseURL: 'https://engelsiz-22-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'engelsiz-22.appspot.com',
    iosClientId: '834693505829-bvvudhcjb4tuvc83hfq205lf1u1472se.apps.googleusercontent.com',
    iosBundleId: 'com.engelsiz.engelsiz',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAZLFl9n-9qRUfgcb50KL7_kH0UIHmtGeI',
    appId: '1:834693505829:ios:6fec431723365c23d430cc',
    messagingSenderId: '834693505829',
    projectId: 'engelsiz-22',
    databaseURL: 'https://engelsiz-22-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'engelsiz-22.appspot.com',
    iosClientId: '834693505829-bvvudhcjb4tuvc83hfq205lf1u1472se.apps.googleusercontent.com',
    iosBundleId: 'com.engelsiz.engelsiz',
  );
}
