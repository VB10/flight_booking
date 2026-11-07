import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Result of the start-up version check.
@immutable
final class AppUpdateInfo extends Equatable {
  const AppUpdateInfo({required this.forceUpdate, required this.message});

  /// Remote Config `force_update_required`.
  final bool forceUpdate;

  /// Remote Config `update_message_tr`; empty means "use the localized default".
  final String message;

  @override
  List<Object?> get props => [forceUpdate, message];
}

/// Seam over Remote Config + package info. Never throws.
abstract interface class IAppUpdateService {
  /// Returns the update info when the installed version is older than the
  /// minimum version, otherwise (or on any failure) `null`.
  Future<AppUpdateInfo?> checkUpdate();
}
