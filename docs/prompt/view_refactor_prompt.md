# Flutter View Refactor Prompt

Bu prompt'u kullanarak herhangi bir Flutter sayfasını temiz mimari yapıya dönüştürebilirsin.

---

## PROMPT

```
Şu sayfayı refactor et: {SAYFA_PATH}

Hedef yapı:
lib/feature/{path}/{page_name}/
├── {page_name}_page.dart           # Ana view (part declarations + final class)
├── {page_name}_page_body.dart      # Body widget + sub widget class'ları (part of)
├── view/
│   ├── {page_name}_page_mixin.dart # View mixin (part of)
│   └── {page_name}_page_state.dart # State class (Equatable + copyWith)
├── model/
│   └── {page_name}_response_model.dart
└── view_model/
    └── {page_name}_view_model.dart

Kurallar:
- Tüm class'lar `final class` olacak
- Controller'lar `late final` olacak
- Constructor'lar `const` olacak
- Private build method YASAK - her widget için ayrı class
- UI State için: State class (Equatable + copyWith) + ValueNotifier
- State bağımlı widget'lar için: ValueListenableBuilder
- setState YASAK - state.value = state.value.copyWith(...) kullan
- Tema kullan: context.colorScheme.*, AppSizes.*, AppPagePadding.*
- TODO ekle: localization, asset path, cache key için "// TODO: Code gen ile ..."
- Hard-coded size varsa: "// TODO: AppSizes'a {name} eklenecek"

AppSizes Değerleri:
- spacingXs=8, spacingS=10, spacingM=16, spacingL=20, spacingXl=24, spacingXXl=32
- iconSmall=16, iconMedium=24, iconLarge=32
- buttonHeightSmall=36, buttonHeightMedium=48, buttonHeightLarge=56
- avatarSmall=32, avatarMedium=48, avatarLarge=64

Adımlar:
1. ViewModel oluştur (view_model/ klasörüne)
2. State class oluştur (view/ klasörüne, ayrı dosya)
3. Mixin oluştur (view/ klasörüne, part of)
4. Body + sub widget'lar oluştur (ValueListenableBuilder ile)
5. Ana dosyayı güncelle
6. flutter analyze çalıştır
```

---

## DOSYA ŞABLONLARI

### 1. Ana Dosya ({page_name}_page.dart)

```dart
import 'package:flight_booking/core/theme/theme.dart';
import 'package:flutter/material.dart';

import 'view/{page_name}_page_state.dart';
import 'view_model/{page_name}_view_model.dart';

part 'view/{page_name}_page_mixin.dart';
part '{page_name}_page_body.dart';

final class {PageName}Page extends StatefulWidget {
  const {PageName}Page({super.key});

  @override
  State<{PageName}Page> createState() => _{PageName}PageState();
}

final class _{PageName}PageState extends State<{PageName}Page> with {PageName}PageMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(...),
      body: _{PageName}PageBody(
        controller: controller,
        state: state,
        onPressed: onButtonPressed,
      ),
    );
  }
}
```

### 2. State Class (view/{page_name}_page_state.dart)

**AYRI DOSYA - part of DEĞİL**

```dart
import 'package:equatable/equatable.dart';

final class {PageName}PageState extends Equatable {
  const {PageName}PageState({
    this.errorMessage = '',
    this.isLoading = false,
  });

  final String errorMessage;
  final bool isLoading;

  {PageName}PageState copyWith({
    String? errorMessage,
    bool? isLoading,
  }) {
    return {PageName}PageState(
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [errorMessage, isLoading];
}
```

### 3. Mixin (view/{page_name}_page_mixin.dart)

```dart
part of '../{page_name}_page.dart';

mixin {PageName}PageMixin on State<{PageName}Page> {
  late final {PageName}ViewModel _viewModel;
  late final TextEditingController controller;
  late final ValueNotifier<{PageName}PageState> state;

  @override
  void initState() {
    super.initState();
    _viewModel = {PageName}ViewModel();
    controller = TextEditingController();
    state = ValueNotifier(const {PageName}PageState());
  }

  @override
  void dispose() {
    controller.dispose();
    state.dispose();
    super.dispose();
  }

  Future<void> onButtonPressed() async {
    state.value = state.value.copyWith(isLoading: true, errorMessage: '');

    try {
      // API call
      final response = await _viewModel.fetchData();

      if (!mounted) return;
      state.value = state.value.copyWith(isLoading: false);
      // Navigate or update state
    } on Exception catch (e) {
      state.value = state.value.copyWith(
        isLoading: false,
        errorMessage: 'Hata: $e',
      );
    }
  }
}
```

### 4. Body + Sub Widgets ({page_name}_page_body.dart)

```dart
part of '{page_name}_page.dart';

final class _{PageName}PageBody extends StatelessWidget {
  const _{PageName}PageBody({
    required this.controller,
    required this.state,
    required this.onPressed,
  });

  final TextEditingController controller;
  final ValueNotifier<{PageName}PageState> state;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const AppPagePadding.all20(),
      child: Column(
        children: [
          const _{PageName}Header(),
          const SizedBox(height: AppSizes.spacingL),
          _{PageName}Input(controller: controller),
          const SizedBox(height: AppSizes.spacingM),
          _{PageName}StateSection(state: state, onPressed: onPressed),
        ],
      ),
    );
  }
}

/// State dependent section with ValueListenableBuilder
final class _{PageName}StateSection extends StatelessWidget {
  const _{PageName}StateSection({
    required this.state,
    required this.onPressed,
  });

  final ValueNotifier<{PageName}PageState> state;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<{PageName}PageState>(
      valueListenable: state,
      builder: (context, currentState, _) {
        return Column(
          children: [
            if (currentState.errorMessage.isNotEmpty)
              _{PageName}ErrorText(message: currentState.errorMessage),
            const SizedBox(height: AppSizes.spacingL),
            _{PageName}Button(
              isLoading: currentState.isLoading,
              onPressed: onPressed,
            ),
          ],
        );
      },
    );
  }
}

final class _{PageName}Header extends StatelessWidget {
  const _{PageName}Header();

  @override
  Widget build(BuildContext context) {
    // TODO: Code gen ile localization
    return ProductText.h3(context, 'Title');
  }
}

final class _{PageName}Input extends StatelessWidget {
  const _{PageName}Input({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    // TODO: Code gen ile localization
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Label',
        border: const OutlineInputBorder(),
        prefixIcon: Icon(Icons.input, color: context.colorScheme.primary),
      ),
    );
  }
}

final class _{PageName}ErrorText extends StatelessWidget {
  const _{PageName}ErrorText({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return ProductText.bodySmall(context, message, color: context.colorScheme.error);
  }
}

final class _{PageName}Button extends StatelessWidget {
  const _{PageName}Button({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const CircularProgressIndicator();

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: context.appTheme.brandPrimary),
      // TODO: Code gen ile localization
      child: Center(
        child: ProductText.bodyMedium(context, 'Button', color: context.colorScheme.onPrimary),
      ),
    );
  }
}
```

### 5. ViewModel (view_model/{page_name}_view_model.dart)

**AYRI DOSYA - part of DEĞİL**

```dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/{page_name}_response_model.dart';

final class {PageName}ViewModel {
  {PageName}ViewModel();

  // TODO: Code gen ile baseUrl yönetimi
  static const String _baseUrl = 'http://localhost:8080';

  Future<ResponseModel> fetchData() async {
    final dio = Dio();
    final response = await dio.get<String>('$_baseUrl/endpoint');
    // ...
  }

  Future<void> saveToCache(ResponseModel data) async {
    final prefs = await SharedPreferences.getInstance();
    // TODO: Code gen ile cache key'leri
  }

  Future<void> logAnalytics() async {
    // Analytics
  }
}
```

### 6. Model (model/{page_name}_response_model.dart)

**AYRI DOSYA**

```dart
class {PageName}ResponseModel {
  // Response fields

  factory {PageName}ResponseModel.fromJson(Map<String, dynamic> json) {
    // ...
  }

  Map<String, dynamic> toJson() {
    // ...
  }
}
```

---

## APPSIZES REFERANSİ

```dart
// Spacing
AppSizes.spacingXs   // 8
AppSizes.spacingS    // 10
AppSizes.spacingM    // 16
AppSizes.spacingL    // 20
AppSizes.spacingXl   // 24
AppSizes.spacingXXl  // 32

// Icons
AppSizes.iconSmall   // 16
AppSizes.iconMedium  // 24
AppSizes.iconLarge   // 32

// Button Heights
AppSizes.buttonHeightSmall   // 36
AppSizes.buttonHeightMedium  // 48
AppSizes.buttonHeightLarge   // 56

// Avatar
AppSizes.avatarSmall   // 32
AppSizes.avatarMedium  // 48
AppSizes.avatarLarge   // 64
```

## COLORSCHEME REFERANSİ

```dart
context.colorScheme.primary
context.colorScheme.onPrimary
context.colorScheme.surface
context.colorScheme.onSurface
context.colorScheme.error
context.colorScheme.onError
context.appTheme.brandPrimary
```

---

## KLASÖR YAPISI ÖZETİ

```
lib/feature/{path}/{page_name}/
├── {page_name}_page.dart           # Ana view (part declarations)
├── {page_name}_page_body.dart      # Body widget (part of)
├── view/
│   ├── {page_name}_page_mixin.dart # View mixin (part of)
│   └── {page_name}_page_state.dart # State class (AYRI DOSYA)
├── model/
│   └── {page_name}_response_model.dart  # Response model (AYRI DOSYA)
└── view_model/
    └── {page_name}_view_model.dart      # ViewModel (AYRI DOSYA)
```

**Notlar:**
- `part of` sadece mixin ve body için kullanılır
- State class, ViewModel ve Model ayrı dosyalardır (import ile kullanılır)
- Mixin path: `part of '../{page_name}_page.dart';`
- Body path: `part of '{page_name}_page.dart';`
