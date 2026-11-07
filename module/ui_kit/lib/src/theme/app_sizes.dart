/// Spacing scale and component sizes — `Main.dc.html` › "2 · Spacing scale"
/// and "4 · Corner radius & sizing".
///
/// Spacing: 8 icon-to-label / button gaps · 10 inner card rows · 16 card
/// padding and gap between cards · 20 page padding · 24 dialog padding and
/// section gaps · 32 state illustrations and hero spacing.
final class AppSizes {
  AppSizes._();

  static const double spacingXs = 8;
  static const double spacingS = 10;
  static const double spacingM = 16;
  static const double spacingL = 20;
  static const double spacingXl = 24;
  static const double spacingXXl = 32;

  /// Horizontal page padding.
  static const double pagePadding = spacingL;

  static const double iconSmall = 16;
  static const double iconMedium = 24;
  static const double iconLarge = 32;

  /// Minimum touch target.
  static const double touchTarget = 44;
  static const double iconButton = 48;

  static const double buttonHeightSmall = 36;
  static const double buttonHeightMedium = 48;
  static const double buttonHeightLarge = 56;
  static const double textFieldHeight = 56;
  static const double chipHeight = 44;
  static const double statusBadgeHeight = 28;

  static const double appBarHeight = 64;

  static const double avatarSmall = 32;
  static const double avatarMedium = 48;
  static const double avatarLarge = 72;

  /// Circle behind Empty / Error / success state icons.
  static const double stateIllustration = 96;
}
