import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';
import 'splash_page.dart';

// Firebase services - Kötü pratik: Global değişkenler
late FirebaseRemoteConfig remoteConfig;
late FirebaseAnalytics analytics;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization - Kötü pratik: Main'de çok fazla işlem
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Remote Config initialization
  remoteConfig = FirebaseRemoteConfig.instance;
  await _initializeRemoteConfig();

  // Analytics initialization
  analytics = FirebaseAnalytics.instance;
  await analytics.setAnalyticsCollectionEnabled(true);

  runApp(MyApp());
}

Future<void> _initializeRemoteConfig() async {
  // Kötü pratik: Hard coded default values
  await remoteConfig.setDefaults({
    'minimum_app_version': '1.0.0',
    'force_update_required': false,
    'update_message_tr': 'Yeni versiyon mevcut! Lütfen uygulamayı güncelleyin.',
    'update_message_en': 'New version available! Please update the app.',
  });

  // Kötü pratik: Hard coded fetch interval
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ),
  );

  try {
    await remoteConfig.fetchAndActivate();
  } catch (e) {
    // Kötü pratik: Silent error handling
    debugPrint('Remote config fetch failed: $e');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight Booking',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
