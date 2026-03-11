# From Chaos to Clean: Flutter Project Setup Done Right

Transform a messy Flutter project into a professional codebase — one PR at a time.

## Flutter Refactoring Masterclass — Part 1

https://github.com/VB10/flight_booking

> **PRs:** #1, #2, #3, #5

📺 **Video Series:** [1-Overview](https://youtu.be/Lz9TJJPqi1o) · [2-Pubspec](https://youtu.be/A8RQupxiv5A) · [3-Linter](https://youtu.be/fMlJAy3pr0k) · [4-Architecture](https://youtu.be/fSDYS5Lr59g) · [5-Main.dart](https://youtu.be/JAzdG1_MKWw)

🤖 *Want to apply these changes to your project? See the [AI prompt](#-apply-this-to-your-project) at the end.*

---

## What is Flutter Refactoring Masterclass?

After years of building Flutter applications—some from scratch, some inherited—I've seen the same patterns repeat. Projects that start clean eventually become messy. New team members struggle to understand the codebase. Even the original developers forget why things are the way they are.

This series is my attempt to fix that. I took a typical "bad" Flutter project and I'm cleaning it up **piece by piece**, documenting every step with:

- **YouTube videos** — Walking through the reasoning and implementation
- **GitHub PRs** — Real code changes you can review and copy
- **Articles** — Written summaries with before/after comparisons
- **AI prompts** — So you can apply the same refactoring to your own projects

The goal isn't to teach you something new—it's to show you **how to apply what you already know** in a systematic, repeatable way. When a new developer joins your team, they should be able to understand the project structure in minutes, not hours.

Let's start with the foundation.

---

## The Problem

Every Flutter developer has inherited—or created—a messy project. Files scattered in `lib/` root. Dependencies listed without any organization. Default linter rules that catch nothing. A `main.dart` bloated with Firebase initialization, analytics setup, and business logic.

When someone new joins the team, they spend hours just understanding where things are. When you return to the project after a month, you wonder who wrote this chaos. That developer was you.

This article covers the **foundation refactoring**—the boring-but-essential changes that transform a hobby project into a professional codebase. We'll work through real PR diffs from the [flight_booking](https://github.com/VB10/flight_booking) repository.

---

## What We Changed

- **pubspec.yaml** — Organized dependencies by category, removed boilerplate comments
- **analysis_options.yaml** — Switched to `very_good_analysis`, enabled strict mode
- **.gitignore** — Added `*.lock` pattern
- **.vscode/settings.json** — Format on save, organize imports
- **.vscode/launch.json** — Flavor-based launch configurations
- **lib/ folder structure** — Feature-based architecture
- **main.dart** — Clean initialization with `AppInitializer` pattern

---

## 1. Pubspec.yaml: Your Project's Table of Contents

The pubspec is the first file anyone reads. It should communicate what your project does and what it depends on—at a glance.

**Before:**
```yaml
# ❌ Before — pubspec.yaml (86 lines with comments)
dependencies:
  flutter:
    sdk: flutter

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.8
  dio: ^5.3.2
  shared_preferences: ^2.2.2
  shimmer: ^3.0.0
  lottie: ^2.7.0
  flutter_svg: ^2.0.9
  firebase_core: ^2.24.2
  firebase_remote_config: ^4.3.8
  firebase_analytics: ^10.7.4
  package_info_plus: ^4.2.0

# ... 40 more lines of Flutter-generated comments
```

**After:**
```yaml
# ✅ After — pubspec.yaml (64 lines, organized)
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

  # Network
  dio: ^5.3.2

  # Database
  shared_preferences: ^2.2.2

  # Firebase
  firebase_core: ^2.24.2
  firebase_remote_config: ^4.3.8
  firebase_analytics: ^10.7.4

  # View utilities
  shimmer: ^3.0.0
  lottie: ^2.7.0
  flutter_svg: ^2.0.9

  # Native plugins
  package_info_plus: ^4.2.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  very_good_analysis: ^10.0.0
  build_runner: ^2.9.0
```

> **Why this matters:** When a package causes issues, you immediately know which category it belongs to. When onboarding a new developer, they understand the project's tech stack in seconds.

---

## 2. Analysis Options: The Team's Code Contract

Default Flutter linting catches almost nothing. When you write code that works but isn't maintainable, nobody tells you. The `very_good_analysis` package changes that—it's the linter used by Very Good Ventures, one of the most respected Flutter consultancies.

**Before:**
```yaml
# ❌ Before — analysis_options.yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    # avoid_print: false  # Uncomment to disable the `avoid_print` rule
    # prefer_single_quotes: true  # Uncomment to enable...
```

**After:**
```yaml
# ✅ After — analysis_options.yaml
include: package:very_good_analysis/analysis_options.yaml

analyzer:
  language:
    strict-casts: true
    strict-raw-types: true

  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - test/**

  errors:
    missing_return: error
    dead_code: error
    unused_import: error
    argument_type_not_assignable: info  # TODO: fix this

linter:
  rules:
    avoid_print: true
    prefer_single_quotes: true
    always_declare_return_types: true
    prefer_const_constructors: true
    prefer_final_locals: true
    use_super_parameters: true
    public_member_api_docs: false
    lines_longer_than_80_chars: false
```

> **Why this matters:** `strict-casts: true` catches implicit type conversions that cause runtime crashes. `prefer_final_locals` enforces immutability. These aren't preferences—they're bug prevention.

---

## 3. VSCode Settings & .gitignore

Lock files cause merge conflicts. Team members have different editors. Imports get shuffled randomly.

**New: `.vscode/settings.json`**
```json
{
    "dart.lineLength": 80,
    "[dart]": {
        "editor.formatOnSave": true,
        "editor.formatOnType": true,
        "editor.rulers": [80],
        "editor.codeActionsOnSave": {
            "source.organizeImports": "explicit",
            "source.fixAll": "explicit"
        }
    }
}
```

**New: `.vscode/launch.json`**
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "App (Development)",
            "request": "launch",
            "type": "dart",
            "toolArgs": ["--dart-define", "FLAVOR=development"]
        },
        {
            "name": "App (Production)",
            "request": "launch",
            "type": "dart",
            "toolArgs": ["--dart-define", "FLAVOR=production"]
        }
    ]
}
```

**Updated: `.gitignore`**
```gitignore
# Added
*.lock
```

> **Why this matters:** When every save auto-formats and organizes imports, code reviews focus on logic—not style. Removing lock files from git eliminates 90% of merge conflicts in iOS projects.

---

## 4. Folder Structure: Feature-Based Architecture

All files dumped in `lib/` root is the #1 sign of a beginner project.

**Before:**
```
lib/
├── main.dart
├── cart_page.dart
├── checkout_response_model.dart
├── flight_detail_page.dart
├── flight_list_page.dart
├── flights_response_model.dart
├── login_page.dart
├── login_response_model.dart
├── profile_page.dart
├── splash_page.dart
└── firebase_options.dart
```

**After:**
```
lib/
├── main.dart
├── core/
│   └── util/
│       └── string_helper.dart
├── feature/
│   ├── auth/
│   │   ├── cart/
│   │   │   ├── cart_page.dart
│   │   │   └── checkout_response_model.dart
│   │   ├── flight/
│   │   │   ├── flight_list_page.dart
│   │   │   └── flights_response_model.dart
│   │   ├── flight_detail/
│   │   │   └── flight_detail_page.dart
│   │   └── profile/
│   │       └── profile_page.dart
│   ├── unauth/
│   │   ├── login/
│   │   │   ├── login_page.dart
│   │   │   └── login_response_model.dart
│   │   └── splash/
│   │       └── splash_page.dart
│   └── sub_feature/
│       └── main/
│           └── main_app.dart
├── product/
│   ├── initialize/
│   │   ├── app_initializer.dart
│   │   ├── platform_initializer.dart
│   │   └── firebase/
│   │       └── custom_remote_config.dart
│   └── package/
│       └── firebase/
│           └── firebase_options.dart
└── module/
    └── utils/
```

> **Why this matters:** When someone asks "where's the login logic?", the answer is obvious: `feature/unauth/login/`. When you need to add a new feature, you know exactly where to create the folder.

---

## 5. Main.dart: The 10-Line Ideal

Your `main.dart` should be readable in 5 seconds.

**Before:**
```dart
// ❌ Before — main.dart (65 lines)
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

// Global variables - bad practice
late FirebaseRemoteConfig remoteConfig;
late FirebaseAnalytics analytics;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setDefaults({
    'minimum_app_version': '1.0.0',
    'force_update_required': false,
    // ... more config
  });

  analytics = FirebaseAnalytics.instance;
  await analytics.setAnalyticsCollectionEnabled(true);

  runApp(MyApp());
}
```

**After:**
```dart
// ✅ After — main.dart (10 lines)
import 'package:flight_booking/feature/sub_feature/main/main_app.dart';
import 'package:flight_booking/product/initialize/app_initializer.dart';
import 'package:flutter/material.dart';

void main() async {
  AppInitializer.run();
  await AppInitializer().prepare();
  runApp(const MainApp());
}
```

**New: `app_initializer.dart`**
```dart
// ✅ After — product/initialize/app_initializer.dart
final class AppInitializer {
  AppInitializer() {
    platformInitializer = kIsWeb
        ? WebPlatformInitializer()
        : MobilePlatformInitializer();
  }

  static void run() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  late final PlatformInitializer platformInitializer;

  Future<void> prepare() async {
    await Future.wait([
      platformInitializer.prepare(),
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
      CustomRemoteConfig.instance.initialize(),
    ]);
  }
}
```

**New: `custom_remote_config.dart`**
```dart
// ✅ After — product/initialize/firebase/custom_remote_config.dart
final class CustomRemoteConfig {
  static final CustomRemoteConfig instance = CustomRemoteConfig._();
  CustomRemoteConfig._();

  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> initialize() async {
    await remoteConfig.setDefaults({
      'minimum_app_version': '1.0.0',
      'force_update_required': false,
    });
  }
}
```

> **Why this matters:** Global variables are gone. Firebase logic is encapsulated. Platform-specific initialization is abstracted. Adding a new initialization step means adding one line to `Future.wait()`.

---

## Key Takeaways

1. **Organize pubspec.yaml by category** — Network, Database, Firebase, UI. Future you will thank present you.

2. **Use `very_good_analysis`** — It catches bugs before they reach production. Enable `strict-casts` and `strict-raw-types`.

3. **Remove lock files from git** — Add `*.lock` to `.gitignore`. Run `pod install` locally.

4. **Feature-based folder structure** — `feature/auth/`, `feature/unauth/`, `product/`, `core/`. Each feature is self-contained.

5. **10-line main.dart** — Everything else goes in `AppInitializer`. Parallel initialization with `Future.wait()`.

---

## What's Next

In **Part 2**, we'll tackle the **Theme & Design System**—building a proper `AppTheme`, `AppColors`, and `AppTextStyles` that support light/dark modes and scale across the app.

---

*This article is part of the **Flutter Refactoring Masterclass** series, where we transform a messy real-world project into production-ready code, one PR at a time.*

---

## 📺 Watch the Full Series

https://youtu.be/Lz9TJJPqi1o

https://youtu.be/A8RQupxiv5A

https://youtu.be/fMlJAy3pr0k

https://youtu.be/fSDYS5Lr59g

https://youtu.be/JAzdG1_MKWw

---

## 🤖 Apply This to Your Project

Use this prompt with Claude or your AI assistant to analyze and refactor your Flutter project:

```
Analyze my Flutter project and apply these refactoring steps:

1. **pubspec.yaml** — Organize dependencies by category (Network, Database, Firebase, UI, Native plugins). Remove all Flutter-generated comments.

2. **analysis_options.yaml** — Switch to very_good_analysis with strict-casts and strict-raw-types enabled. Add exclude patterns for generated files.

3. **.gitignore** — Add *.lock pattern to prevent merge conflicts.

4. **.vscode/settings.json** — Add formatOnSave, organizeImports, and 80-char ruler for Dart files.

5. **Folder structure** — Reorganize lib/ into feature-based architecture:
   - feature/auth/ (authenticated screens)
   - feature/unauth/ (login, splash)
   - product/initialize/ (app initialization)
   - core/util/ (shared utilities)

6. **main.dart** — Reduce to ~10 lines using AppInitializer pattern. Move all Firebase/analytics setup to separate initialization classes.

Show before/after for each change. Create PRs or commits for each step.
```

Or run a quick analysis:
```
/sc:analyze --quality --architecture
```

---

## 📋 Full Series Roadmap

This is Part 1 of a 20-part series. Here's the complete roadmap:

https://gist.github.com/VB10/1e38a0b9cb95104de24b756787026357

**Completed:** v1–v7 (Project Setup, Theme, View-ViewModel-Mixin)

**Coming Next:** Navigation, State Management, Network Layer, Code Generation, Testing, and more.

---

*⭐ [github.com/VB10/flight_booking](https://github.com/VB10/flight_booking)*
