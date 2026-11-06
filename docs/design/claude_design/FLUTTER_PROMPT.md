# Task: implement the "Flight Booking" redesign in this Flutter project

Source of truth: the design files in `design/` (each `*.dc.html` is plain HTML/CSS; open them as text).
- `Main.dc.html`  -> tokens: color roles (light+dark hex), spacing, type scale, radius
- `Components.dc.html`, `States.dc.html` -> every widget and its states
- `Splash/Login/Flights/Detail/Cart/Profile.dc.html` -> screens, all states, light+dark
- `Handoff.dc.html` -> component inventory with tokens, NEW DATA / NEW FEATURE list, navigation map

Rules
- Material 3, Roboto, light + dark. Names must match the design 1:1.
- Step 1 (design system only, stop and show me): `AppTheme` (ColorScheme + ThemeExtension for brandPrimary, brandSecondary, success, warning, info, cardBackground, divider, shimmerBase, shimmerHighlight and the *Container/on* roles), `AppSpacing` (8,10,16,20,24,32; pagePadding 20), `AppRadius` (8/12/24), text styles, then widgets: AppButton, AppTextField, AppTopBar, BadgeIconButton, FlightCard(full/compact), PriceTag, InfoRow, StatTile, StatusBadge, AppDialog, AppSnackbar, LoadingState, EmptyState, ErrorState, AppChip, AppAvatar, InfoBanner, SummaryBar, SettingsRow, LoadingOverlay. Add a gallery/widgetbook page showing all states.
- Step 2 (after I approve): screens feature-first, Clean Architecture, MVVM, Riverpod, Freezed, GoRouter, following the navigation map in Handoff.
- Only wire NEW DATA / NEW FEATURE items behind clearly named fields; keep existing data models unchanged.
- No hardcoded colors/sizes in screens; tokens only. Strings in l10n (EN + TR, allow ~30% longer text).
- Production quality, typed errors, tests for widgets' states, semantics labels on icon buttons.
