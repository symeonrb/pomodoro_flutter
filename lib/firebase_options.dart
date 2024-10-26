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
    apiKey: 'AIzaSyDdvDO20pdshe5adkJb0GAw3LHjm_OCgGc',
    appId: '1:421858371890:web:8fbb55b3c59a5f13a08f2b',
    messagingSenderId: '421858371890',
    projectId: 'pomodoro-5c1ff',
    authDomain: 'pomodoro-5c1ff.firebaseapp.com',
    storageBucket: 'pomodoro-5c1ff.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAYtVpOJmXS_2z3V7R75wH_P5hc2QV3dTQ',
    appId: '1:421858371890:android:92c04ae364fd8850a08f2b',
    messagingSenderId: '421858371890',
    projectId: 'pomodoro-5c1ff',
    storageBucket: 'pomodoro-5c1ff.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBJJDccNhPbhIry-5fhJ94uKk6XIHFlRqw',
    appId: '1:421858371890:ios:a5d3d6a3242dedd0a08f2b',
    messagingSenderId: '421858371890',
    projectId: 'pomodoro-5c1ff',
    storageBucket: 'pomodoro-5c1ff.appspot.com',
    androidClientId: '421858371890-e4ut6qjpgiqbglhamlfq5kpfvjgj7lnv.apps.googleusercontent.com',
    iosClientId: '421858371890-6vklaknsf4qe3m4qpjvcg1l1eo12odjl.apps.googleusercontent.com',
    iosBundleId: 'com.pomodoro.flutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBJJDccNhPbhIry-5fhJ94uKk6XIHFlRqw',
    appId: '1:421858371890:ios:148e22c3309f9fe3a08f2b',
    messagingSenderId: '421858371890',
    projectId: 'pomodoro-5c1ff',
    storageBucket: 'pomodoro-5c1ff.appspot.com',
    androidClientId:
        '421858371890-e4ut6qjpgiqbglhamlfq5kpfvjgj7lnv.apps.googleusercontent.com',
    iosClientId:
        '421858371890-s882koao4lt8dfjh5lr164e1bb8kd9na.apps.googleusercontent.com',
    iosBundleId: 'com.pomodoro.flutter',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDdvDO20pdshe5adkJb0GAw3LHjm_OCgGc',
    appId: '1:421858371890:web:a820b61aaff1cc60a08f2b',
    messagingSenderId: '421858371890',
    projectId: 'pomodoro-5c1ff',
    authDomain: 'pomodoro-5c1ff.firebaseapp.com',
    storageBucket: 'pomodoro-5c1ff.appspot.com',
  );
}