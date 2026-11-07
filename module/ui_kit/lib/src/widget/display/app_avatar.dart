import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/app_sizes.dart';

/// Kit `AppAvatar` — initials on primaryContainer, no photo. 72 by default.
final class AppAvatar extends StatelessWidget {
  const AppAvatar({
    required this.initials,
    this.size = AppSizes.avatarLarge,
    super.key,
  });

  final String initials;
  final double size;

  /// "Ayşe Demir" → "AD". Empty input gives "?".
  static String initialsOf(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    final first = parts.first.characters.first;
    final last = parts.length > 1 ? parts.last.characters.first : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size * 28 / 72,
          height: 36 / 28,
          fontWeight: FontWeight.w500,
          color: scheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
