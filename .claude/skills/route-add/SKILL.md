---
name: route-add
description: >-
  Adds a new typed route to the existing go_router navigation architecture.
  Takes a page name and path, creates a GoRouteData class in app_routes.dart,
  runs build_runner to regenerate app_routes.g.dart, and optionally updates
  auth_guard.dart if the route is public. Use when user runs /route-add
  or asks to add a new screen/route to the navigation.
---

# Add Route to Existing Navigation

## When to apply

- User invokes **`/route-add`** or asks to add a new page/screen/route.
- The go_router navigation infrastructure already exists (`lib/product/navigation/`).

## Prerequisites

These must already exist (set up by `/route-setup`):
- `lib/product/navigation/app_routes.dart` (with `part 'app_routes.g.dart'`)
- `lib/product/navigation/app_router.dart`
- `lib/product/navigation/guards/auth_guard.dart`

If they don't exist, run `/route-setup` first.

## Authoritative spec

Read and follow:

- [docs/prompt/navigation_routing_prompt.md](../../../docs/prompt/navigation_routing_prompt.md) — **ROUTE ADD PROMPT** section

## Required information

Ask the user for (or infer from context):

| Field | Example | Required |
|-------|---------|----------|
| **Page name** | `Settings`, `BookingDetail` | Yes |
| **Path** | `/settings`, `/bookings/:bookingId` | Yes |
| **Auth required** | Yes (default) / No | Yes |
| **Parent route** | None (top-level) / `FlightListRoute` (nested) | No |
| **Path params** | `bookingId: String` | If path has `:param` |
| **Extra params** | `$extra: BookingModel` | If page needs data |
| **Page widget path** | `lib/feature/auth/settings/settings_page.dart` | Yes |

## Implementation checklist

### 1. Define the route class

Add to `lib/product/navigation/app_routes.dart`:

**Top-level route:**
```dart
@TypedGoRoute<SettingsRoute>(path: '/settings')
class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsPage();
}
```

**Nested route** (child of existing route):
```dart
// Add to parent's routes list:
@TypedGoRoute<FlightListRoute>(
  path: '/flights',
  routes: [
    TypedGoRoute<FlightDetailRoute>(path: ':flightId'),
    TypedGoRoute<FlightBookingRoute>(path: ':flightId/booking'), // NEW
  ],
)
```

**Route with path param + extra:**
```dart
@TypedGoRoute<BookingDetailRoute>(path: '/bookings/:bookingId')
class BookingDetailRoute extends GoRouteData with $BookingDetailRoute {
  const BookingDetailRoute({required this.bookingId, required this.$extra});

  final String bookingId;
  final BookingModel $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      BookingDetailPage(bookingId: bookingId, booking: $extra);
}
```

### 2. Update auth guard (only if public)

If the route does **NOT** require authentication, add its path to `_publicPaths` in `lib/product/navigation/guards/auth_guard.dart`:

```dart
const publicPaths = {'/splash', '/login', '/settings'}; // added /settings
```

If auth IS required (default) — no change needed; the guard blocks unauthenticated access by default.

### 3. Add page import

Add the page widget import to `app_routes.dart`:
```dart
import 'package:flight_booking/feature/{area}/{feature}/{page}.dart';
```

### 4. Run build_runner

```bash
dart run build_runner build --delete-conflicting-outputs
```

Verify `app_routes.g.dart` includes the new route's `$` mixin and `$appRoutes` list entry.

### 5. Add navigation call(s)

In the source page(s) that navigate to this new route:

```dart
// Simple
const SettingsRoute().go(context);

// With params
BookingDetailRoute(bookingId: '456', $extra: booking).go(context);

// Push (adds to stack, back button returns)
const SettingsRoute().push(context);
```

Import `app_routes.dart` in the source page and remove any direct page widget imports.

### 6. Verify

```bash
flutter analyze lib/product/navigation/ lib/feature/{area}/{feature}/
```

## Do not

- Manually edit `app_routes.g.dart` — it's generated.
- Use `Navigator.push` for the new route — use typed route's `.go()` or `.push()`.
- Forget to add page import to `app_routes.dart` before running build_runner.
- Add auth-required routes to `_publicPaths` — only public routes go there.

## Navigation method guide

| Action | Method | Example |
|--------|--------|---------|
| Replace current (no back) | `.go(context)` | `const LoginRoute().go(context)` |
| Push onto stack (back ok) | `.push(context)` | `const ProfileRoute().push(context)` |
| Replace top of stack | `.pushReplacement(context)` | - |
| Replace current match | `.replace(context)` | - |

## Reference code in this repo

- Route definitions: `lib/product/navigation/app_routes.dart`
- Generated routes: `lib/product/navigation/app_routes.g.dart`
- Auth guard: `lib/product/navigation/guards/auth_guard.dart`
- Existing routes: `SplashRoute`, `LoginRoute`, `FlightListRoute`, `FlightDetailRoute`, `CartRoute`, `ProfileRoute`

## Slash command

Users can trigger this workflow with:

- `.claude/commands/route-add.md` → **`/route-add {page_name} {path}`**
