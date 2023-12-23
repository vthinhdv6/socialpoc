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
    apiKey: 'AIzaSyCwYXKIKtxVac96yHLW3IOvv9ESj77MJhU',
    appId: '1:318035904995:web:f9645d4d8e5c0f6e2db8d6',
    messagingSenderId: '318035904995',
    projectId: 'project1-e1b0b',
    authDomain: 'project1-e1b0b.firebaseapp.com',
    storageBucket: 'project1-e1b0b.appspot.com',
    measurementId: 'G-2MS2FMNQ5J',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBsjKLyum87rZSQ4AazPKX7TkyC_jtCX-I',
    appId: '1:318035904995:android:dc6fb0c43631e0962db8d6',
    messagingSenderId: '318035904995',
    projectId: 'project1-e1b0b',
    storageBucket: 'project1-e1b0b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD5tDYSR21Fgs0Gh3I-GX3UYHLFo46k7qw',
    appId: '1:318035904995:ios:eb4276679d25507e2db8d6',
    messagingSenderId: '318035904995',
    projectId: 'project1-e1b0b',
    storageBucket: 'project1-e1b0b.appspot.com',
    iosBundleId: 'com.example.socialpoc',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD5tDYSR21Fgs0Gh3I-GX3UYHLFo46k7qw',
    appId: '1:318035904995:ios:f9c6fa7da4cbd2322db8d6',
    messagingSenderId: '318035904995',
    projectId: 'project1-e1b0b',
    storageBucket: 'project1-e1b0b.appspot.com',
    iosBundleId: 'com.example.socialpoc.RunnerTests',
  );
}
