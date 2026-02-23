import 'package:firebase_core/firebase_core.dart';
import 'package:flight_booking/product/initialize/firebase/custom_remote_config.dart';
import 'package:flight_booking/product/initialize/platform_initializer.dart';
import 'package:flight_booking/product/package/firebase/firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final class AppInitializer {
  AppInitializer() {
    platformInitializer = kIsWeb
        ? WebPlatformInitializer()
        : MobilePlatformInitializer();
  }

  static void run() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  late final PlatformInitializer platformInitializer;

  Future<void> prepare() async {
    await Future.wait([
      platformInitializer.prepare(),
      Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
    ]);
    await CustomRemoteConfig.instance.initialize();
  }
}
