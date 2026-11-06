import 'package:flutter/material.dart';
import 'package:ui_kit/src/widget/button/app_button.dart';
import 'package:ui_kit/src/widget/display/app_tone.dart';
import 'package:ui_kit/src/widget/state/state_icon.dart';

/// Kit `EmptyState` — secondaryContainer circle + message + optional action
/// ("Browse Flights", "Clear filters").
final class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final String? message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return StateMessage(
      icon: icon,
      tone: AppTone.brand,
      title: title,
      message: message,
      action: actionLabel == null
          ? null
          : AppButton.secondary(label: actionLabel!, onPressed: onAction),
    );
  }
}
