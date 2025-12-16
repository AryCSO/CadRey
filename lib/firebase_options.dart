import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: "AIzaSyAPRHWYhEBhf5z7CttOHOIKLFG7J984-T4",
    authDomain: "cadrey-f8a6f.firebaseapp.com",
    projectId: "cadrey-f8a6f",
    storageBucket: "cadrey-f8a6f.firebasestorage.app",
    messagingSenderId: "814496571300",
    appId: "1:814496571300:web:3e96723c586440db7e6b31",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAz0ysZHfSHyxpQHqJWMOPIWHScjYVKbBU',
    appId: '1:814496571300:android:81bdce8da57b32c17e6b31',
    messagingSenderId: 'COLE_SEU_SENDER_ID',
    projectId: 'cadrey-f8a6f',
    storageBucket: 'cadrey-f8a6f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'COLE_SUA_API_KEY_IOS_AQUI',
    appId: 'COLE_SEU_APP_ID_IOS_AQUI',
    messagingSenderId: 'COLE_SEU_SENDER_ID',
    projectId: 'COLE_SEU_PROJECT_ID',
    storageBucket: 'COLE_SEU_STORAGE_BUCKET',
    iosBundleId: 'com.example.cadrey',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'COLE_SUA_API_KEY_MACOS_AQUI',
    appId: 'COLE_SEU_APP_ID_MACOS_AQUI',
    messagingSenderId: 'COLE_SEU_SENDER_ID',
    projectId: 'COLE_SEU_PROJECT_ID',
    storageBucket: 'COLE_SEU_STORAGE_BUCKET',
    iosBundleId: 'com.example.cadrey',
  );
}
