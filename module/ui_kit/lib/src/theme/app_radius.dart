import 'package:flutter/material.dart';

/// Corner radius — `Main.dc.html` › "4 · Corner radius & sizing".
///
/// Use the semantic names in new code:
/// - [small]  8  — StatusBadge, AppChip, AppSnackbar, shimmer blocks
/// - [medium] 12 — AppButton, AppTextField, FlightCard, StatTile, InfoBanner
/// - [large]  24 — AppDialog, bottom sheets, route hero, large surfaces
final class AppRadius {
  AppRadius._();

  static const double smallValue = 8;
  static const double mediumValue = 12;
  static const double largeValue = 24;

  static const BorderRadius small = BorderRadius.all(
    Radius.circular(smallValue),
  );
  static const BorderRadius medium = BorderRadius.all(
    Radius.circular(mediumValue),
  );
  static const BorderRadius large = BorderRadius.all(
    Radius.circular(largeValue),
  );
  static const BorderRadius topLarge = BorderRadius.vertical(
    top: Radius.circular(largeValue),
  );

  // Legacy numeric radii — kept so pages that are not migrated yet compile.
  static BorderRadius get circular4 => BorderRadius.circular(4);
  static BorderRadius get circular8 => BorderRadius.circular(8);
  static BorderRadius get circular12 => BorderRadius.circular(12);
  static BorderRadius get circular16 => BorderRadius.circular(16);
  static BorderRadius get circular20 => BorderRadius.circular(20);
  static BorderRadius get circular24 => BorderRadius.circular(24);
  static BorderRadius get circular32 => BorderRadius.circular(32);
  static BorderRadius get top8 =>
      const BorderRadius.vertical(top: Radius.circular(8));
  static BorderRadius get top16 =>
      const BorderRadius.vertical(top: Radius.circular(16));
  static BorderRadius get bottom8 =>
      const BorderRadius.vertical(bottom: Radius.circular(8));
  static BorderRadius get bottom16 =>
      const BorderRadius.vertical(bottom: Radius.circular(16));
}
