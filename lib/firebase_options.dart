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

  // --- CONFIGURAÇÃO WEB (Seu Foco) ---
  // Substitua os valores abaixo pelos dados do Console do Firebase -> Configurações do Projeto -> Seus Aplicativos -> Web
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAPRHWYhEBhf5z7CttOHOIKLFG7J984-T4",
    authDomain: "cadrey-f8a6f.firebaseapp.com",
    projectId: "cadrey-f8a6f",
    storageBucket: "cadrey-f8a6f.firebasestorage.app",
    messagingSenderId: "814496571300",
    appId: "1:814496571300:web:3e96723c586440db7e6b31",
  );

  // --- CONFIGURAÇÃO ANDROID (Opcional, preencher se for usar Android) ---
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'COLE_SUA_API_KEY_ANDROID_AQUI',
    appId: 'COLE_SEU_APP_ID_ANDROID_AQUI',
    messagingSenderId: 'COLE_SEU_SENDER_ID',
    projectId: 'COLE_SEU_PROJECT_ID',
    storageBucket: 'COLE_SEU_STORAGE_BUCKET',
  );

  // --- CONFIGURAÇÃO IOS (Opcional, preencher se for usar iOS) ---
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'COLE_SUA_API_KEY_IOS_AQUI',
    appId: 'COLE_SEU_APP_ID_IOS_AQUI',
    messagingSenderId: 'COLE_SEU_SENDER_ID',
    projectId: 'COLE_SEU_PROJECT_ID',
    storageBucket: 'COLE_SEU_STORAGE_BUCKET',
    iosBundleId: 'com.example.cadrey',
  );

  // --- CONFIGURAÇÃO MACOS (Opcional) ---
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'COLE_SUA_API_KEY_MACOS_AQUI',
    appId: 'COLE_SEU_APP_ID_MACOS_AQUI',
    messagingSenderId: 'COLE_SEU_SENDER_ID',
    projectId: 'COLE_SEU_PROJECT_ID',
    storageBucket: 'COLE_SEU_STORAGE_BUCKET',
    iosBundleId: 'com.example.cadrey',
  );
}
