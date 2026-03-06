# Flutter View Refactor

Verilen sayfayı temiz mimari yapıya dönüştür.

## Kullanım

```
/flutter-view-refactor {page_path}
```

## Hedef Klasör Yapısı

```
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
```

## Kurallar

### Ana Dosya ({page_name}_page.dart)
- `final class` + `const` constructor
- Part declarations: `part 'view/{page_name}_page_mixin.dart';` ve `part '{page_name}_page_body.dart';`
- State import: `import 'view/{page_name}_page_state.dart';`
- ViewModel import: `import 'view_model/{page_name}_view_model.dart';`

### State Class (view/{page_name}_page_state.dart)
- Ayrı dosya (part of DEĞİL)
- `final class` + Equatable + copyWith
- `import 'package:equatable/equatable.dart';`

### Mixin (view/{page_name}_page_mixin.dart)
- `part of '../{page_name}_page.dart';`
- `late final ValueNotifier<{PageName}PageState> state`
- `late final` controller'lar
- Callback metodları: `state.value = state.value.copyWith(...)`

### Body + Sub Widgets ({page_name}_page_body.dart)
- `part of '{page_name}_page.dart';`
- **Private build method YASAK** - her widget için ayrı `final class`
- State bağımlı widget'lar için `ValueListenableBuilder`

### ViewModel (view_model/{page_name}_view_model.dart)
- Ayrı dosya (part of DEĞİL)
- `final class`
- Model import: `import '../model/{page_name}_response_model.dart';`
- API, cache, analytics

### Model (model/{page_name}_response_model.dart)
- Ayrı dosya
- Response/Request modelleri

## State Class Şablonu

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

## ValueListenableBuilder Kullanımı

```dart
ValueListenableBuilder<{PageName}PageState>(
  valueListenable: state,
  builder: (context, currentState, _) {
    return Column(
      children: [
        if (currentState.errorMessage.isNotEmpty)
          _ErrorText(message: currentState.errorMessage),
        _Button(isLoading: currentState.isLoading, onPressed: onPressed),
      ],
    );
  },
)
```

## TODO Ekle

- `// TODO: Code gen ile localization`
- `// TODO: Code gen ile asset path`
- `// TODO: Code gen ile cache key'leri`
- `// TODO: AppSizes'a {name} eklenecek` (hard-coded size varsa)

## Tema & Size Kullanımı

### AppSizes
```dart
AppSizes.spacingXs/S/M/L/Xl/XXl  // 8, 10, 16, 20, 24, 32
AppSizes.iconSmall/Medium/Large  // 16, 24, 32
AppSizes.buttonHeightSmall/Medium/Large  // 36, 48, 56
AppSizes.avatarSmall/Medium/Large  // 32, 48, 64
```

### ColorScheme
```dart
context.colorScheme.primary/surface/error/onPrimary/onSurface
context.appTheme.brandPrimary
```
