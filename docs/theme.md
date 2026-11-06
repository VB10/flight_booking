# Flight Booking — Tema ve Design System

> v13'ten beri tema ve tüm temel bileşenler yerel bir pakette: [module/ui_kit](../module/ui_kit/).
> Değerlerin kaynağı Claude Design kit'i ([docs/design/claude_design](design/claude_design/)).
> Tasarımdaki bir sınıfın koddaki karşılığı için: [docs/design/kit_mapping.md](design/kit_mapping.md).

**Import (tek satır):**

```dart
import 'package:flight_booking/core/theme/theme.dart'; // ui_kit + AppTheme
```

**Galeri** (her bileşen, her durum, light/dark):

```bash
cd module/ui_kit/example && flutter run -d chrome
```

---

## 1. Katmanlar

| Katman | Yer | İçerik |
|---|---|---|
| Kit (domain bilmez) | `module/ui_kit/lib/src/theme/` | `AppColors` (paletler), `AppColorScheme`, `AppThemeExtension`, `AppTextStyles`, `AppSizes`, `AppRadius`, `AppPagePadding`, `ProductText`, `UiKitTheme` |
| Kit bileşenleri | `module/ui_kit/lib/src/widget/` | `AppButton`, `AppTextField`, `AppTopBar`, `AppDialog`, `AppSnackbar`, `EmptyState`… |
| App teması | `lib/core/theme/app_theme.dart` | `AppTheme.lightTheme / darkTheme` = `UiKitTheme` + `FontFamily.roboto` |
| Ürün bileşenleri | `lib/product/widget/flight/` | `FlightCard`, `RouteVisual`, `RouteLine`, `AirlineMark` |

Paket asset ve çeviri içermez. Fontu app verir (`UiKitTheme.light(fontFamily: …)`), metinleri
widget'lara app geçirir.

## 2. Renkler

Widget'larda **asla** `AppColors` ya da hex kullanılmaz; rol üzerinden okunur:

```dart
context.colorScheme.primary              // Material 3 rolleri
context.appTheme.successContainer        // M3'te olmayan roller
```

| `context.colorScheme` | `context.appTheme` |
|---|---|
| primary, onPrimary, primaryContainer, onPrimaryContainer, secondary…, tertiary…, error…, surface, onSurface, surfaceContainerHighest, onSurfaceVariant, outline, outlineVariant, scrim | brandPrimary, brandSecondary, success / onSuccess / successContainer / onSuccessContainer, warning / onWarning / warningContainer / onWarningContainer, info / infoContainer / onInfoContainer, cardBackground, divider, shimmerBase, shimmerHighlight |

Tonal kutular (`StatusBadge`, `AppSnackbar`, `InfoBanner`, durum ikonları) `AppTone` ile seçilir:
`neutral · success · warning · info · error · brand`.

## 3. Tipografi

Material 3 ölçeği, satır yükseklikleriyle (`AppTextStyles`). Metin `ProductText` ile yazılır; renk
varsayılan olarak temadan gelir:

```dart
ProductText.h1(context, 'Başlık')            // headlineMedium
ProductText.h2(context, '…')                 // headlineSmall
ProductText.h3(context, '…')                 // titleLarge
ProductText.h4(context, '…')                 // titleMedium
ProductText.bodyMedium(context, '…', color: context.colorScheme.onSurfaceVariant)
```

Tek izinli ağırlık override'ı `PriceTag` (700).

## 4. Boşluk, radius, boyut

| Token | Değer | Kullanım |
|---|---|---|
| `AppSizes.spacingXs` | 8 | ikon–etiket, buton–buton |
| `AppSizes.spacingS` | 10 | kart içi satırlar |
| `AppSizes.spacingM` | 16 | kart padding, kartlar arası |
| `AppSizes.spacingL` / `pagePadding` | 20 | sayfa yatay padding |
| `AppSizes.spacingXl` | 24 | dialog padding, bölüm arası |
| `AppSizes.spacingXXl` | 32 | durum illüstrasyonu, hero |
| `AppRadius.small / medium / large` | 8 / 12 / 24 | badge-chip-snackbar / buton-alan-kart / dialog-hero |
| `AppSizes.touchTarget` · `buttonHeightMedium` · `textFieldHeight` · `appBarHeight` · `avatarLarge` | 44 · 48 · 56 · 64 · 72 | |

Eski API'ler (`AppRadius.circular12`, `AppPagePadding.all16`…) geçiş için duruyor; yeni kodda
semantik isimler kullanılır.

## 5. Bileşenler

Tam liste ve parametreler: [kit_mapping.md › Bileşenler](design/kit_mapping.md#2-bileşenler).
Ekranlarda ham Material karşılıkları (`ElevatedButton`, `TextField`, `AlertDialog`, `SnackBar`,
`Card`, `Shimmer`, `AppBar`) kullanılmaz.

## 6. Yeni bir şey eklemek

- **Yeni ekran (tasarımdan):** `/masterflutter-design-screen` — kit'e dokunmaz, eksik varsa
  KIT GAP der.
- **Yeni token / bileşen ya da baştan yeni tasarım:** `/masterflutter-design-system-setup` —
  paketi, galeriyi, testleri ve `kit_mapping.md`'yi birlikte günceller.
