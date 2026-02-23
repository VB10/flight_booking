import 'package:flutter/material.dart';

final class AppRadius {
  AppRadius._();

  static BorderRadius get circular4 => BorderRadius.circular(4);
  static BorderRadius get circular8 => BorderRadius.circular(8);
  static BorderRadius get circular12 => BorderRadius.circular(12);
  static BorderRadius get circular16 => BorderRadius.circular(16);
  static BorderRadius get circular20 => BorderRadius.circular(20);
  static BorderRadius get circular24 => BorderRadius.circular(24);
  static BorderRadius get circular32 => BorderRadius.circular(32);

  static BorderRadius get top8 => const BorderRadius.vertical(
        top: Radius.circular(8),
      );
  static BorderRadius get top16 => const BorderRadius.vertical(
        top: Radius.circular(16),
      );
  static BorderRadius get bottom8 => const BorderRadius.vertical(
        bottom: Radius.circular(8),
      );
  static BorderRadius get bottom16 => const BorderRadius.vertical(
        bottom: Radius.circular(16),
      );
}
