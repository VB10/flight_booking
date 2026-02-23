---
name: flight-booking-theme
description: Resolves theme-related tasks in the Flight Booking Flutter app. Use when changing colors, padding, radius, text styles, theme extension, or when the user asks about theme, design system, AppTheme, AppColors, AppPadding, AppRadius, context.appTheme, or MaterialApp theme.
---

# Flight Booking — Tema Skill

Tema ile ilgili her noktada hızlıca doğru API kullan. Tek referans: [theme.md](../../../theme.md) (proje kökü).

## Ne Zaman Kullan

- Renk ekleme/değiştirme (primary, success, warning, card, shimmer)
- Padding/radius/size sabiti kullanma veya ekleme
- Text style kullanma veya tema ile uyumlu metin
- ThemeExtension veya MaterialApp theme değişikliği
- "Tema", "design system", "AppTheme", "AppColors", "AppPadding", "AppRadius", "appTheme" geçen istekler

## Kurallar (Kısa)

1. **Import:** Sadece `import 'package:flight_booking/core/theme/theme.dart';`
2. **Renk (widget içinde):** `Theme.of(context).colorScheme.primary` veya `context.appTheme.success` — asla `Colors.blue` gibi ham renk kullanma (tema renkleri kullan).
3. **Padding:** `AppPadding.p16`, `AppPadding.horizontal16`, `AppPadding.vertical8` — sabit sayı yerine AppPadding.
4. **Sayfa padding/margin:** `AppPagePadding` extends `EdgeInsets`; const constructor kullan (getter yok). Örn: `AppPagePadding.all20()`, `AppPagePadding.horizontalSymmetric()`, `AppPagePadding.marginBottom15()`, `AppPagePadding.horizontalSymmetricFree(24)`.
5. **Radius:** `AppRadius.circular12`, `AppRadius.top8` — sabit sayı yerine AppRadius.
6. **Metin:** `Theme.of(context).textTheme.titleLarge` veya `AppTextStyles.bodyMedium`.
7. **Boyut:** `AppSizes.iconMedium`, `AppSizes.buttonHeightMedium`.
8. **Custom renk (success, warning, card, divider, shimmer):** `context.appTheme.success`, `context.appTheme.cardBackground`, `context.appTheme.shimmerBase` / `shimmerHighlight`.
9. **TextTheme (hızlı erişim):** `context.appTextTheme.displayLarge`, `context.appTextTheme.bodyMedium` vb.
10. **Metin widget:** `ProductText.h1(context, 'Başlık')`, `ProductText.bodyMedium(context, 'Metin')` — context + metin, tema stili otomatik.

## Hızlı Eşleme

| İstek / Bağlam | Kullan |
|----------------|--------|
| Primary/error/surface rengi | `Theme.of(context).colorScheme.*` |
| Başarı/uyarı/bilgi/kart/divider/shimmer | `context.appTheme.*` |
| Boşluk | `AppPadding.*` |
| Sayfa boşluk / margin | `AppPagePadding.all20()`, `AppPagePadding.marginBottom15()` |
| Köşe yuvarlama | `AppRadius.*` |
| İkon/buton yüksekliği | `AppSizes.*` |
| Metin stili | `context.appTextTheme.*` veya `Theme.of(context).textTheme.*` |
| Metin widget (başlık/gövde) | `ProductText.h1(context, '...')`, `ProductText.bodyMedium(context, '...')` |

## Yeni Renk/Sabit Ekleme

- **Extension’a yeni renk:** `lib/core/theme/app_theme_extension.dart` — alan ekle, `light`/`dark` static’lere değer ver, `copyWith` ve `lerp` güncelle.
- **Yeni padding/radius:** `app_padding.dart` / `app_radius.dart` — static getter ekle.
- **Sayfa padding/margin:** `app_page_padding.dart` — const constructor ekle (EdgeInsets extend), getter kullanma.
- **Yeni size:** `app_sizes.dart` — static const double ekle.
- **Yeni text style:** `app_text_styles.dart` — getter ekle ve `textTheme`’e ekle.

Değişiklikten sonra `theme.md` ve gerekirse bu skill’i güncelle.

## Dosya Konumları

- Tüm tema: `lib/core/theme/`
- Tek import: `lib/core/theme/theme.dart`
- Dokümantasyon: proje kökünde `theme.md`

Detaylı liste ve tüm sabitler için her zaman [theme.md](../../../theme.md) dosyasına bak.
