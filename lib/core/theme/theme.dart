/// Single theme import for the app.
///
/// Tokens, theme builder and kit widgets live in `module/ui_kit`; this file
/// re-exports them and adds the app-owned `AppTheme` (it knows the font).
library;

export 'package:flight_booking/core/theme/app_theme.dart';
export 'package:ui_kit/ui_kit.dart';
