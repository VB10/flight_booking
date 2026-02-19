# Flight Booking — Tema ve Design System

Tek referans: tüm tema özellikleri ve kullanımlar. Kodda aramaya gerek yok.

**Cursor skill:** Tema ile ilgili işleri hızlıca çözmek için `.cursor/skills/theme/` skill’i kullanılır (tema, renk, padding, radius, text style, extension).

**Import (tek satır):**
```dart
import 'package:flight_booking/core/theme/theme.dart';
```

---

## 1. Ana Tema (AppTheme)

| Özellik | Açıklama |
|--------|----------|
| **AppTheme.lightTheme** | Material 3 light ThemeData |
| **AppTheme.darkTheme** | Material 3 dark ThemeData |

**Kullanım (MaterialApp):**
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  // ...
);
```

- `useMaterial3: true`, `fontFamily: 'Roboto'`
- Renkler: `AppColorScheme`, metin: `AppTextStyles`, extension: `AppThemeExtension`

---

## 2. Custom Extension (context.appTheme)

BuildContext üzerinden erişim: **`context.appTheme`**

| Alan | Açıklama | Light | Dark |
|------|----------|--------|------|
| **brandPrimary** | Marka birincil | primary | primary |
| **brandSecondary** | Marka ikincil | secondary | secondary |
| **success** | Başarı (yeşil) | tertiary | tertiary |
| **warning** | Uyarı (turuncu) | #FF9800 | #FFB74D |
| **info** | Bilgi | secondary | secondary |
| **cardBackground** | Kart arka plan | surface | surfaceContainerHighest |
| **divider** | Ayırıcı çizgi | outlineVariant | outlineVariant |
| **shimmerBase** | Shimmer base | #E0E0E0 | #424242 |
| **shimmerHighlight** | Shimmer vurgu | #F5F5F5 | #616161 |

**Kullanım:**
```dart
// Renk
Container(color: context.appTheme.brandPrimary)
Icon(Icons.check_circle, color: context.appTheme.success)
Divider(color: context.appTheme.divider)

// Shimmer
Shimmer.fromColors(
  baseColor: context.appTheme.shimmerBase,
  highlightColor: context.appTheme.shimmerHighlight,
  child: child,
)

// Card
Card(color: context.appTheme.cardBackground, ...)
```

---

## 3. Renk Paleti (AppColors)

Doğrudan kullanım yerine önce **Theme.of(context).colorScheme** veya **context.appTheme** tercih edin. Palet referans için:

| Palet | Erişim |
|-------|--------|
| Light | `AppColors.light` → primary, onPrimary, surface, error, outline, ... |
| Dark | `AppColors.dark` → aynı alanlar |

M3 semantic alanlar: primary, onPrimary, primaryContainer, onPrimaryContainer, secondary, onSecondary, tertiary, onTertiary, error, onError, surface, onSurface, surfaceContainerHighest, onSurfaceVariant, outline, outlineVariant.

---

## 4. ColorScheme (AppColorScheme)

Tema tarafından kullanılır; doğrudan widget’ta **Theme.of(context).colorScheme** kullanın.

```dart
Theme.of(context).colorScheme.primary
Theme.of(context).colorScheme.surface
Theme.of(context).colorScheme.error
Theme.of(context).colorScheme.onSurface
```

---

## 5. TextTheme Context Extension (context.appTextTheme)

Tema metin stillerine hızlı erişim: **`context.appTextTheme`** (Theme.of(context).textTheme ile aynı).

```dart
context.appTextTheme.displayLarge
context.appTextTheme.headlineMedium
context.appTextTheme.titleLarge
context.appTextTheme.bodyMedium
context.appTextTheme.labelSmall
```

---

## 6. ProductText (Theme-backed Text widget)

`Text` extend eder; context alıp tema stilini uygular. Alt kırılımlar: **h1, h2, h3, h4**, **titleLarge/Medium/Small**, **bodyLarge/Medium/Small**, **labelLarge/Medium/Small**.

**Kullanım:**
```dart
ProductText.h1(context, 'Başlık')
ProductText.h2(context, 'Alt başlık')
ProductText.h3(context, 'Bölüm')
ProductText.h4(context, 'Küçük başlık')

ProductText.titleLarge(context, 'Başlık')
ProductText.bodyMedium(context, 'Açıklama metni')
ProductText.labelSmall(context, 'Etiket')

// Opsiyonel: style override, textAlign, maxLines, overflow
ProductText.bodyMedium(context, 'Metin', style: TextStyle(color: Colors.red), maxLines: 2)
```

| Constructor | Tema stili |
|-------------|------------|
| **h1** | displayLarge |
| **h2** | headlineLarge |
| **h3** | headlineMedium |
| **h4** | headlineSmall |
| **titleLarge / titleMedium / titleSmall** | titleLarge / titleMedium / titleSmall |
| **bodyLarge / bodyMedium / bodySmall** | bodyLarge / bodyMedium / bodySmall |
| **labelLarge / labelMedium / labelSmall** | labelLarge / labelMedium / labelSmall |

---

## 7. Typography (AppTextStyles)

**Context ile (renk tema ile gelir):**
```dart
context.appTextTheme.titleLarge
Theme.of(context).textTheme.bodyMedium
```

**Context olmadan (sadece font/size):**
```dart
AppTextStyles.displayLarge
AppTextStyles.headlineMedium
AppTextStyles.titleLarge
AppTextStyles.bodyMedium
AppTextStyles.labelSmall
```

| Stil | fontSize | Ağırlık |
|------|----------|---------|
| displayLarge / Medium / Small | 57, 45, 36 | w400 |
| headlineLarge / Medium / Small | 32, 28, 24 | w400 |
| titleLarge / Medium / Small | 22, 16, 14 | w500 |
| bodyLarge / Medium / Small | 16, 14, 12 | w400 |
| labelLarge / Medium / Small | 14, 12, 11 | w500 |

Font: **Roboto**.

---

## 8. Boşluklar (AppPadding)

Tümü `EdgeInsets` döner.

| Sabit | Değer |
|-------|--------|
| **p4, p8, p12, p16, p20, p24, p32** | EdgeInsets.all(4..32) |
| **all8, all16, ...** | p8, p16 ile aynı |
| **horizontal4..32** | symmetric(horizontal: n) |
| **vertical4..32** | symmetric(vertical: n) |

**Kullanım:**
```dart
padding: AppPadding.p16
padding: AppPadding.horizontal16
padding: AppPadding.vertical8
```

---

## 9. Page boşlukları (AppPagePadding)

Sayfa kenarı ve liste/kart boşlukları için. **EdgeInsets’i extend eder**; const constructor kullanır (getter yok, performans kaybı yok).

| Constructor | Açıklama |
|-------------|----------|
| **AppPagePadding.all10(), all15(), all16(), all20(), all24(), all32()** | super.all(n) |
| **horizontalSymmetric(), horizontalSymmetricMedium(), horizontalSymmetricLarge()** | symmetric(horizontal: 20 / 16 / 24) |
| **horizontalSymmetricFree(double)** | symmetric(horizontal: değişken) |
| **verticalSymmetric(), verticalSymmetricSmall(), verticalSymmetricMedium(), verticalSymmetricLarge()** | symmetric(vertical: 20 / 8 / 16 / 24) |
| **verticalSymmetricFree(double)** | symmetric(vertical: değişken) |
| **marginBottom8(), marginBottom10(), marginBottom12(), marginBottom15(), marginBottom16()** | only(bottom: n) |

**Kullanım:**
```dart
padding: AppPagePadding.all20()
padding: AppPagePadding.horizontalSymmetric()
padding: AppPagePadding.horizontalSymmetricFree(24)
margin: AppPagePadding.marginBottom15()
padding: AppPagePadding.verticalSymmetricSmall()
```

---

## 10. Border Radius (AppRadius)

Tümü `BorderRadius` döner.

| Sabit | Açıklama |
|-------|----------|
| **circular4, circular8, circular12, circular16, circular20, circular24, circular32** | BorderRadius.circular(n) |
| **top8, top16** | Sadece üst köşeler |
| **bottom8, bottom16** | Sadece alt köşeler |

**Kullanım:**
```dart
borderRadius: AppRadius.circular12
borderRadius: AppRadius.top16
```

---

## 11. Boyutlar (AppSizes)

| Sabit | Değer (px) |
|-------|------------|
| **iconSmall / iconMedium / iconLarge** | 16, 24, 32 |
| **buttonHeightSmall / Medium / Large** | 36, 48, 56 |
| **appBarHeight** | 56 |
| **avatarSmall / Medium / Large** | 32, 48, 64 |

**Kullanım:**
```dart
Icon(Icons.add, size: AppSizes.iconMedium)
SizedBox(height: AppSizes.buttonHeightMedium)
```

---

## Hızlı Referans

| İhtiyaç | Kullan |
|---------|--------|
| Tema rengi (primary, surface, error) | `Theme.of(context).colorScheme.*` |
| Marka / success / warning / card / divider / shimmer | `context.appTheme.*` |
| Metin stili (context ile) | `context.appTextTheme.*` veya `Theme.of(context).textTheme.*` |
| Metin widget (başlık/gövde) | `ProductText.h1(context, '...')`, `ProductText.bodyMedium(context, '...')` |
| Metin stili (context yok) | `AppTextStyles.*` |
| Padding | `AppPadding.p16`, `horizontal16`, `vertical8` |
| Sayfa padding/margin | `AppPagePadding.all20()`, `AppPagePadding.marginBottom15()` |
| Radius | `AppRadius.circular12`, `top8` |
| İkon/buton yüksekliği | `AppSizes.iconMedium`, `buttonHeightMedium` |

---

## Dosya Yapısı

```
lib/core/theme/
├── theme.dart                 # Barrel export — tek import
├── app_theme.dart             # AppTheme.lightTheme / darkTheme
├── app_theme_extension.dart   # context.appTheme + context.appTextTheme
├── app_colors.dart            # AppColors.light / dark
├── app_color_scheme.dart      # AppColorScheme.light / dark
├── app_text_styles.dart       # AppTextStyles + textTheme
├── app_page_padding.dart      # AppPagePadding (sayfa boşlukları)
├── app_padding.dart           # AppPadding
├── app_radius.dart            # AppRadius
├── app_sizes.dart             # AppSizes
├── product_text.dart          # ProductText (h1, bodyMedium, ...)
└── theme.md                   # Bu dosya (docs/theme.md)
```
