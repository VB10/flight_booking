# Theme System and View-ViewModel-Mixin: Building a Scalable Flutter UI Layer

How to centralize design tokens with `ThemeExtension`, then split chaotic page widgets into View, ViewModel, and Mixin layers — without any state management library.

## Flutter Refactoring Masterclass — Part 2

https://github.com/VB10/flight_booking

> **PRs:** #7, #9

📺 **Video Series:** [6-Theme & Design System](https://youtu.be/2-Q91EDSiTg) · [7.1-View-ViewModel-Mixin](https://youtu.be/Uyp0rWupYJc)

🤖 *Want to apply these changes to your project? See the [AI prompt](#-apply-this-to-your-project) at the end.*

---

## The Problem

Two patterns kill Flutter projects faster than any other: **scattered design tokens** and **god-class widgets**.

A typical login page accumulates network calls, cache writes, analytics events, controllers, error state, loading flags, and 100 lines of UI — all in one `_LoginPageState`. Padding values like `EdgeInsets.all(20)` get sprinkled across files. Hex colors live next to widgets. When the design team renames "primary" to "brand," you're searching the entire codebase by hand.

When a new developer joins the team, they ask "where's the loading state for login?" and the answer is "scroll to line 137." When the designer asks for dark mode, you cry.

This article fixes both problems on the same module — first by establishing a **centralized theme system** (PR #7), then by **splitting the login page** into View, ViewModel, and Mixin layers (PR #9). Same module, two complementary refactors.

---

## What We Changed

**Theme System (PR #7):**
- `lib/core/theme/app_color_scheme.dart` — Material 3 ColorScheme generator from palette
- `lib/core/theme/app_colors.dart` — Light/dark color palette (single source of truth)
- `lib/core/theme/app_theme.dart` — Final ThemeData factories (no getters)
- `lib/core/theme/app_theme_extension.dart` — Custom brand colors via `ThemeExtension`
- `lib/core/theme/app_text_styles.dart` — Typography scale (h1, h3, body, caption)
- `lib/core/theme/app_page_padding.dart` — Const-only spacing primitives
- `lib/core/theme/product_text.dart` — Reusable text widget bound to theme
- `docs/theme.md` + `.cursor/skills/theme/SKILL.md` — Documentation + AI skill

**View Architecture (PR #9):**
- `lib/feature/unauth/login/login_page.dart` — Reduced from 211 → 37 lines
- `lib/feature/unauth/login/view/login_page_mixin.dart` — Controllers + actions
- `lib/feature/unauth/login/view/login_page_state.dart` — Immutable state (Equatable)
- `lib/feature/unauth/login/view/widget/login_page_body.dart` — UI body
- `lib/feature/unauth/login/view_model/login_view_model.dart` — Business logic
- `docs/prompt/view_refactor_prompt.md` + `.claude/commands/flutter-view-refactor.md` — Reusable refactor prompt

---

## 1. Final ThemeData, Not Getters

A theme is built once and lives for the app's lifetime. Defining it as a getter forces Flutter to recompute the entire `ThemeData` graph on every read. That's wasteful and signals the wrong intent.

**Before:**
```dart
// ❌ Before — typical pattern in many projects
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      // ...everything inline, mixed with magic numbers
    );
  }
}
```

**After:**
```dart
// ✅ After — lib/core/theme/app_theme.dart
final class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final scheme = AppColorScheme.light;
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: AppTextStyles.textTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
      fontFamily: 'Roboto',
      extensions: <ThemeExtension<dynamic>>[
        AppThemeExtension.light,
      ],
    );
  }

  static ThemeData get darkTheme { /* mirror of lightTheme */ }
}
```

> **Why this matters:** `final class` prevents accidental inheritance. The private constructor (`AppTheme._()`) prevents instantiation. The theme delegates to specialized files (`AppColorScheme`, `AppTextStyles`, `AppThemeExtension`) — each one a single concern.

---

## 2. ColorScheme as the Source of Truth

Material 3's `ColorScheme` already covers 90% of UI use cases. Don't reinvent it — generate it from your palette.

**After:**
```dart
// ✅ After — lib/core/theme/app_color_scheme.dart
final class AppColorScheme {
  AppColorScheme._();

  static ColorScheme get light {
    final palette = AppColors.light;
    return ColorScheme(
      brightness: Brightness.light,
      primary: palette.primary,
      onPrimary: palette.onPrimary,
      primaryContainer: palette.primaryContainer,
      onPrimaryContainer: palette.onPrimaryContainer,
      secondary: palette.secondary,
      onSecondary: palette.onSecondary,
      tertiary: palette.tertiary,
      onTertiary: palette.onTertiary,
      error: palette.error,
      onError: palette.onError,
      surface: palette.surface,
      onSurface: palette.onSurface,
      surfaceContainerHighest: palette.surfaceContainerHighest,
      onSurfaceVariant: palette.onSurfaceVariant,
      outline: palette.outline,
      outlineVariant: palette.outlineVariant,
      // ...full M3 token coverage
    );
  }

  static ColorScheme get dark { /* mirror with AppColors.dark */ }
}
```

> **Why this matters:** Every screen reads colors from `Theme.of(context).colorScheme`. Switching to dark mode is one prop change on `MaterialApp`. The palette in `AppColors` is the *only* place hex codes live.

---

## 3. ThemeExtension for Brand-Specific Colors

Not every color fits Material's slot system. "Brand primary," "shimmer base," "warning amber" — these are app-specific. `ThemeExtension` is built for exactly this case: extra theme data that travels with the theme and respects light/dark mode.

**After:**
```dart
// ✅ After — lib/core/theme/app_theme_extension.dart
final class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.brandPrimary,
    required this.brandSecondary,
    required this.success,
    required this.warning,
    required this.cardBackground,
    required this.shimmerBase,
    required this.shimmerHighlight,
    // ...
  });

  final Color brandPrimary;
  final Color brandSecondary;
  final Color success;
  final Color warning;
  final Color cardBackground;
  final Color shimmerBase;
  final Color shimmerHighlight;

  static AppThemeExtension light = AppThemeExtension(
    brandPrimary: AppColors.light.primary,
    brandSecondary: AppColors.light.secondary,
    success: AppColors.light.tertiary,
    warning: const Color(0xFFFF9800),
    cardBackground: AppColors.light.surface,
    shimmerBase: const Color(0xFFE0E0E0),
    shimmerHighlight: const Color(0xFFF5F5F5),
  );

  static AppThemeExtension dark = AppThemeExtension(
    // ...dark variants
  );

  @override
  ThemeExtension<AppThemeExtension> copyWith({ /* ... */ }) { /* ... */ }

  @override
  ThemeExtension<AppThemeExtension> lerp(
    ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    // Color.lerp for every field — gives you free animations
  }
}

extension AppThemeExtensionContext on BuildContext {
  AppThemeExtension get appTheme =>
      Theme.of(this).extension<AppThemeExtension>()!;
}

extension AppTextThemeContext on BuildContext {
  TextTheme get appTextTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
```

Usage in widgets:

```dart
// Before
Container(color: const Color(0xFF1976D2))

// After
Container(color: context.appTheme.brandPrimary)
```

> **Why this matters:** Colors that change at runtime (light/dark, theme switching) **must** come from context, not from constants. The `BuildContext` extension makes that one-liner ergonomic. `lerp` gives you free crossfade animations during theme changes.

---

## 4. Padding That Doesn't Allocate

`EdgeInsets.all(20)` is fine — but writing it on every widget is noise. And making spacing helpers into getters allocates a fresh `EdgeInsets` on every call.

**Before:**
```dart
// ❌ Before — scattered across the codebase
Padding(padding: const EdgeInsets.all(20), child: ...)
Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: ...)
SizedBox(height: 20)
```

**After:**
```dart
// ✅ After — lib/core/theme/app_page_padding.dart
final class AppPagePadding extends EdgeInsets {
  const AppPagePadding.all16() : super.all(_spacingM);
  const AppPagePadding.all20() : super.all(_spacingL);
  const AppPagePadding.all24() : super.all(_spacingXl);

  const AppPagePadding.horizontalSymmetric()
      : super.symmetric(horizontal: _spacingL);
  const AppPagePadding.verticalSymmetric()
      : super.symmetric(vertical: _spacingL);
  const AppPagePadding.marginBottom16() : super.only(bottom: _spacingM);

  static const double _spacingXs = 8;
  static const double _spacingM = 16;
  static const double _spacingL = 20;
  static const double _spacingXl = 24;
  static const double _spacingXXl = 32;
}

// Usage
Padding(padding: const AppPagePadding.all20(), child: ...)
```

> **Why this matters:** `const` constructors mean zero allocation — Dart canonicalizes them at compile time. The named constructors (`all16`, `marginBottom16`) read like intent, not magic numbers. The `_spacingXs`/`_spacingM`/`_spacingL` ladder enforces a 4-multiple system.

---

## 5. The Login Page Before View-ViewModel-Mixin

Now the second refactor. Here's what the login page looked like before PR #9 — even *after* the theme refactor was applied.

**Before:**
```dart
// ❌ Before — login_page.dart (211 lines)
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  bool isLoading = false;

  void login() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    Dio dio = Dio();
    String baseUrl = 'http://localhost:8080'; // hard-coded URL

    try {
      Response response = await dio.post('$baseUrl/login', data: {
        'email': emailController.text,
        'password': passwordController.text,
      });

      if (response.statusCode == 200) {
        final loginResponse = LoginResponseModel.fromJson(
          jsonDecode(response.data),
        );
        if (loginResponse.success) {
          await saveUserToCache(loginResponse);     // cache logic in widget
          await _logSuccessfulLogin(loginResponse); // analytics in widget
          setState(() => isLoading = false);
          Navigator.pushReplacement(/* ... */);
        } else {
          setState(() {
            isLoading = false;
            errorMessage = loginResponse.message;
          });
        }
      }
    } catch (e) {
      setState(() => errorMessage = 'Bağlantı hatası: $e');
    }
  }

  Future<void> saveUserToCache(LoginResponseModel r) async { /* ... */ }
  Future<void> _logSuccessfulLogin(LoginResponseModel r) async { /* ... */ }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 100+ lines of UI mixed with controllers and state
    );
  }
}
```

Network logic, SharedPreferences writes, Firebase Analytics calls, error formatting, and 100 lines of widget tree — all in `_LoginPageState`. This is the file I was talking about: when you open the file, you can't reach `build()` without scrolling.

---

## 6. Splitting Into View, ViewModel, and Mixin

The fix is structural, not stateful. Three rules:

1. **View** owns layout. Nothing else.
2. **Mixin** owns controllers, lifecycle, and UI actions.
3. **ViewModel** owns business operations (network, cache, analytics).

`part`/`part of` keeps related files visually separate but lexically one unit — no public API leakage.

**After:**
```dart
// ✅ After — login_page.dart (37 lines)
import 'package:flight_booking/core/theme/theme.dart';
import 'package:flight_booking/feature/auth/flight/flight_list_page.dart';
import 'package:flight_booking/feature/unauth/login/view/login_page_state.dart';
import 'package:flight_booking/feature/unauth/login/view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

part 'view/login_page_mixin.dart';
part 'view/widget/_login_test_account_info.dart';
part 'view/widget/login_page_body.dart';

final class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final class _LoginPageState extends State<LoginPage> with LoginPageMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        title: ProductText.h3(context, 'Flight Booking'),
        centerTitle: true,
        backgroundColor: context.colorScheme.primary,
      ),
      body: _LoginPageBody(
        emailController: emailController,
        passwordController: passwordController,
        state: state,
        onLogin: onLoginPressed,
      ),
    );
  }
}
```

That's the whole page. You can read it in 5 seconds.

> **Why this matters:** The `View` only knows three things: layout, what controllers to pass down, and what callback to wire. Everything else — controllers, state, network — lives next door, accessible because of `part of`.

---

## 7. The Mixin: Controllers and UI Actions

Controllers are stateful. Their lifecycle is tied to the widget. They belong to the mixin, not the build method.

**After:**
```dart
// ✅ After — view/login_page_mixin.dart
part of '../login_page.dart';

mixin LoginPageMixin on State<LoginPage> {
  // ViewModel
  late final LoginViewModel _viewModel;

  // Controllers
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  // UI state via ValueNotifier — no setState
  late final ValueNotifier<LoginPageState> state;

  @override
  void initState() {
    super.initState();
    _viewModel = LoginViewModel();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    state = ValueNotifier(const LoginPageState());
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    state.dispose();
    super.dispose();
  }

  Future<void> onLoginPressed() async {
    state.value = state.value.copyWith(isLoading: true, errorMessage: '');

    try {
      final response = await _viewModel.login(
        email: emailController.text,
        password: passwordController.text,
      );

      if (response.success) {
        await _viewModel.saveUserToCache(response);
        await _viewModel.logSuccessfulLogin(response);

        if (!mounted) return;
        state.value = state.value.copyWith(isLoading: false);

        await Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(builder: (_) => FlightListPage()),
        );
      } else {
        state.value = state.value.copyWith(
          isLoading: false,
          errorMessage: response.message,
        );
      }
    } on Exception catch (e) {
      state.value = state.value.copyWith(
        isLoading: false,
        errorMessage: 'Bağlantı hatası: $e',
      );
    }
  }
}
```

> **Why this matters:** A mixin is an abstract "plugin" you attach to a class. Only widgets that opt into `LoginPageMixin` get these controllers — no global access, no leak. `late final` lets us defer initialization to `initState` while keeping fields immutable. `ValueNotifier` replaces `setState` so the page rebuilds nothing it doesn't have to.

---

## 8. Immutable State with Equatable

`bool isLoading; String errorMessage;` works — but every `setState` mutates the widget directly. Equatable + `copyWith` give you predictable, comparable, history-friendly state.

**After:**
```dart
// ✅ After — view/login_page_state.dart
@immutable
final class LoginPageState extends Equatable {
  const LoginPageState({
    this.errorMessage = '',
    this.isLoading = false,
  });

  final String errorMessage;
  final bool isLoading;

  LoginPageState copyWith({String? errorMessage, bool? isLoading}) {
    return LoginPageState(
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [errorMessage, isLoading];
}
```

Wired to the body via `ValueListenableBuilder`:

```dart
// In login_page_body.dart
ValueListenableBuilder<LoginPageState>(
  valueListenable: state,
  builder: (context, value, _) {
    if (value.isLoading) return const CircularProgressIndicator();
    if (value.errorMessage.isNotEmpty) {
      return ProductText.bodySmall(
        context,
        value.errorMessage,
        color: context.colorScheme.error,
      );
    }
    return ElevatedButton(onPressed: onLogin, child: const Text('Login'));
  },
);
```

> **Why this matters:** No state management library needed. `ValueNotifier` ships with Flutter. Equatable makes `state == oldState` cheap and reliable, so `ValueListenableBuilder` only rebuilds when fields actually change. For most pages, this is enough — Bloc/Riverpod come later when you outgrow it.

---

## 9. The ViewModel: Pure Business Logic

The ViewModel doesn't know about widgets, BuildContext, or navigation. It returns data and throws exceptions. The mixin decides what to do with results.

**After:**
```dart
// ✅ After — view_model/login_view_model.dart
final class LoginViewModel {
  LoginViewModel();

  static const String _baseUrl = 'http://localhost:8080';

  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final dio = Dio();
    final response = await dio.post<String>(
      '$_baseUrl/login',
      data: {'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(
        jsonDecode(response.data!) as Map<String, dynamic>,
      );
    }
    throw Exception('Server hatası: ${response.statusCode}');
  }

  Future<void> saveUserToCache(LoginResponseModel r) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', r.token);
    await prefs.setString('user_email', r.user.email);
    await prefs.setBool('is_logged_in', true);
    // ...
  }

  Future<void> logSuccessfulLogin(LoginResponseModel r) async {
    try {
      await CustomRemoteConfig.instance.analytics.logLogin(loginMethod: 'email');
      await CustomRemoteConfig.instance.analytics.logEvent(
        name: 'successful_login',
        parameters: {
          'login_timestamp': DateTime.now().millisecondsSinceEpoch,
          'user_id': r.user.id,
          'platform': 'mobile',
        },
      );
    } on Exception catch (e) {
      debugPrint('Analytics logging failed: $e');
    }
  }
}
```

> **Why this matters:** This file is testable without a Flutter binding. You can mock Dio, call `login()`, assert the response. The `saveUserToCache` call doesn't sit inside a widget anymore — it's a method you can run in isolation. The next step (covered in PR #11) is wrapping `Dio` in an `INetworkManager` interface — but the seam is already cut here.

---

## Key Takeaways

1. **Theme = `final class` + private constructor** — Themes are built once. Don't make them getters that recompute. Don't allow inheritance you don't need.

2. **`ColorScheme` first, `ThemeExtension` second** — Material 3 covers most slots. Use `ThemeExtension` only for *brand-specific* additions, never for things M3 already provides.

3. **`AppPagePadding` with `const` constructors** — Named, intent-revealing, zero-allocation spacing. The 4-multiple ladder (8/16/20/24/32) becomes a contract.

4. **`part`/`part of` over public files** — When the View, Mixin, State, and Body are conceptually one page, lexically separating with `part` keeps the file count small and the imports clean.

5. **Mixin owns lifecycle, ViewModel owns business** — Controllers and `ValueNotifier`s die with the widget (mixin). Network/cache/analytics outlive the widget conceptually (ViewModel).

6. **`ValueNotifier` + Equatable beats `setState` for state pages** — You don't need Bloc on day one. Start with what Flutter ships with. Migrate when you actually need cross-widget state.

7. **The View should be readable in 5 seconds** — If you can't see the widget tree without scrolling, the page is doing too much. Refactor until `build()` fits on one screen.

---

## What's Next

In **Part 3**, we'll tackle the **Network & Service Layer** — wrapping Dio behind an `INetworkManager` interface, generating models with `freezed`/`json_serializable`, and centralizing error handling. The `LoginViewModel` we built here will become a thin caller of `IAuthService`.

---

*This article is part of the **Flutter Refactoring Masterclass** series, where we transform a messy real-world project into production-ready code, one PR at a time.*

---

## 📺 Watch the Full Series

https://youtu.be/2-Q91EDSiTg

https://youtu.be/Uyp0rWupYJc

---

## 🤖 Apply This to Your Project

Use this prompt with Claude or your AI assistant to refactor an existing Flutter screen:

```
Refactor my Flutter feature into the View / ViewModel / Mixin architecture
and align it with a centralized theme system.

Theme layer (lib/core/theme/):
1. Create AppColors (light/dark palettes — single source of truth for hex values).
2. Create AppColorScheme with two static getters that map AppColors → Material 3 ColorScheme.
3. Create AppTheme as a `final class` with private constructor and static
   `lightTheme`/`darkTheme` getters that compose ColorScheme + TextTheme + extensions.
4. Create AppThemeExtension extends ThemeExtension<AppThemeExtension> for brand-specific
   colors (brandPrimary, success, warning, shimmer, etc.). Implement copyWith and lerp.
5. Add BuildContext extensions: `context.appTheme`, `context.colorScheme`,
   `context.appTextTheme`.
6. Create AppPagePadding extends EdgeInsets with named const constructors
   (all16, all20, horizontalSymmetric, marginBottom16, etc.) backed by 4-multiple
   spacing constants.
7. Create AppTextStyles (h1, h3, body, caption) and a ProductText widget that
   reads from theme.

View architecture (lib/feature/<area>/<feature>/):
1. Reduce the page file to <50 lines. It should only contain the StatefulWidget,
   _<Page>State with the mixin, and a build() method that returns Scaffold +
   _<Page>Body.
2. Create view/<feature>_page_mixin.dart as a `part of` the page.
   Move all controllers, ValueNotifiers, initState, dispose, and UI action
   methods (onXPressed) here.
3. Create view/<feature>_page_state.dart with @immutable + Equatable +
   copyWith. Default-init all fields. props lists every field.
4. Create view/widget/<feature>_page_body.dart as `part of` the page.
   This is the large UI tree. Use ValueListenableBuilder for state-driven
   sections.
5. Create view_model/<feature>_view_model.dart as a final class with no
   Flutter imports. Network calls, cache writes, analytics — all return
   plain data or throw.

Rules:
- Use `final class` everywhere unless the class is meant to be extended.
- Replace setState with ValueNotifier<State> + ValueListenableBuilder.
- No raw EdgeInsets in widgets — always AppPagePadding.
- No raw hex colors in widgets — always context.colorScheme or context.appTheme.
- Files inside the same feature use `part`/`part of`, not public exports,
  unless shared across features.

Show before/after for the page file and list every new file created.
```

Or invoke the existing skill directly:
```
/flutter-view-refactor lib/feature/unauth/login
```

---

## 📋 Full Series Roadmap

This is Part 2 of a 20-part series. Here's the complete roadmap:

https://gist.github.com/VB10/1e38a0b9cb95104de24b756787026357

**Completed:** v1–v5 (Project Setup), v6 (Theme & Design System), v7.1 (View-ViewModel-Mixin)

**Coming Next:** v7.2 Service & Model Layer, v8 Network Architecture, v9 State Management with Cubit, v10 Navigation with go_router, plus testing, code generation, and more.

---

*⭐ [github.com/VB10/flight_booking](https://github.com/VB10/flight_booking)*
