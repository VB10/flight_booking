import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

final class CustomRemoteConfig {
  static final CustomRemoteConfig instance = CustomRemoteConfig._();
  CustomRemoteConfig._();
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> initialize() async {
    await remoteConfig.setDefaults({
      'minimum_app_version': '1.0.0',
      'force_update_required': false,
      'update_message_tr':
          'Yeni versiyon mevcut! Lütfen uygulamayı güncelleyin.',
      'update_message_en': 'New version available! Please update the app.',
    });
  }
}
