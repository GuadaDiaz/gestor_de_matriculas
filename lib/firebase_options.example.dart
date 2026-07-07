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
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'INSERT_YOUR_WEB_API_KEY_HERE',
    appId: 'INSERT_YOUR_WEB_APP_ID_HERE',
    messagingSenderId: 'INSERT_YOUR_SENDER_ID',
    projectId: 'INSERT_YOUR_PROJECT_ID',
    authDomain: 'INSERT_YOUR_AUTH_DOMAIN',
    storageBucket: 'INSERT_YOUR_STORAGE_BUCKET',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'INSERT_YOUR_ANDROID_API_KEY_HERE',
    appId: 'INSERT_YOUR_ANDROID_APP_ID_HERE',
    messagingSenderId: 'INSERT_YOUR_SENDER_ID',
    projectId: 'INSERT_YOUR_PROJECT_ID',
    storageBucket: 'INSERT_YOUR_STORAGE_BUCKET',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'INSERT_YOUR_IOS_API_KEY_HERE',
    appId: 'INSERT_YOUR_IOS_APP_ID_HERE',
    messagingSenderId: 'INSERT_YOUR_SENDER_ID',
    projectId: 'INSERT_YOUR_PROJECT_ID',
    storageBucket: 'INSERT_YOUR_STORAGE_BUCKET',
    iosBundleId: 'INSERT_YOUR_BUNDLE_ID',
  );
}
