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
    apiKey: 'AIzaSyBOcMj_oVagaSuyGtD4qVE6ICuXQ3Kdo-M',
    appId: '1:457761980851:web:5c7a16e2866b46000fcbc6',
    messagingSenderId: '457761980851',
    projectId: 'social-app-16e23',
    authDomain: 'social-app-16e23.firebaseapp.com',
    storageBucket: 'social-app-16e23.appspot.com',
    measurementId: 'G-RSGGP0Q1L2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCkWPECG_5rVaffZjqxGI4TU1vK2CCBFh8',
    appId: '1:457761980851:android:1be00351af76dd9c0fcbc6',
    messagingSenderId: '457761980851',
    projectId: 'social-app-16e23',
    storageBucket: 'social-app-16e23.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyACHEapnoxH9E58DcynkxT2TG9S19qTKmg',
    appId: '1:457761980851:ios:00f7971614f51c870fcbc6',
    messagingSenderId: '457761980851',
    projectId: 'social-app-16e23',
    storageBucket: 'social-app-16e23.appspot.com',
    androidClientId: '457761980851-jrh6vtq2eqtmabmsg6toifb87f3h0nup.apps.googleusercontent.com',
    iosClientId: '457761980851-bp4dapo4r2s06gf4gtl29hah6btbslsf.apps.googleusercontent.com',
    iosBundleId: 'com.example.socialApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyACHEapnoxH9E58DcynkxT2TG9S19qTKmg',
    appId: '1:457761980851:ios:00f7971614f51c870fcbc6',
    messagingSenderId: '457761980851',
    projectId: 'social-app-16e23',
    storageBucket: 'social-app-16e23.appspot.com',
    androidClientId: '457761980851-jrh6vtq2eqtmabmsg6toifb87f3h0nup.apps.googleusercontent.com',
    iosClientId: '457761980851-bp4dapo4r2s06gf4gtl29hah6btbslsf.apps.googleusercontent.com',
    iosBundleId: 'com.example.socialApp',
  );
}
