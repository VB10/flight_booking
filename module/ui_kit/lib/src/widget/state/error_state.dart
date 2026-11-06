import 'package:flutter/material.dart';
import 'package:ui_kit/src/widget/button/app_button.dart';
import 'package:ui_kit/src/widget/display/app_tone.dart';
import 'package:ui_kit/src/widget/state/state_icon.dart';

/// Kit `ErrorState` — errorContainer circle + message + primary "Try Again".
final class ErrorState extends StatelessWidget {
  const ErrorState({
    required this.title,
    required this.retryLabel,
    required this.onRetry,
    this.message,
    this.icon = Icons.cloud_off_outlined,
    super.key,
  });

  final String title;
  final String? message;
  final IconData icon;
  final String retryLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return StateMessage(
      icon: icon,
      tone: AppTone.error,
      title: title,
      message: message,
      action: AppButton.primary(
        label: retryLabel,
        icon: Icons.refresh,
        onPressed: onRetry,
      ),
    );
  }
}
