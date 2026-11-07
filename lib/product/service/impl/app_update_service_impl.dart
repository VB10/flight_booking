import 'package:flight_booking/product/initialize/firebase/custom_remote_config.dart';
import 'package:flight_booking/product/service/app_update_service.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

final class AppUpdateServiceImpl implements IAppUpdateService {
  @override
  Future<AppUpdateInfo?> checkUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final remoteConfig = CustomRemoteConfig.instance.remoteConfig;
      final minimumVersion = remoteConfig.getString('minimum_app_version');
      if (!_isVersionOlder(packageInfo.version, minimumVersion)) return null;
      return AppUpdateInfo(
        forceUpdate: remoteConfig.getBool('force_update_required'),
        message: remoteConfig.getString('update_message_tr'),
      );
    } on Object catch (e) {
      debugPrint('Version check failed: $e');
      return null;
    }
  }

  bool _isVersionOlder(String current, String minimum) {
    final currentParts = current.split('.').map(int.parse).toList();
    final minimumParts = minimum.split('.').map(int.parse).toList();

    for (var i = 0; i < 3; i++) {
      if (currentParts[i] < minimumParts[i]) return true;
      if (currentParts[i] > minimumParts[i]) return false;
    }
    return false;
  }
}
