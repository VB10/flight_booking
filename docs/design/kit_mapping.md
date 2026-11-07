# Kit Mapping — Claude Design → Flutter

> Bu dosya `/masterflutter-design-system-setup` skill'inin **çıktısı**, `/masterflutter-design-screen`
> skill'inin **girdisidir**. Tasarım board'larında (`docs/design/claude_design/design/*.dc.html`)
> görülen her sınıf ve token'ın kodda neye karşılık geldiğini söyler. Ekran bağlarken tahmin
> yapılmaz: board'daki sınıf buradan bakılır, karşılığı kullanılır. Burada olmayan bir şey
> **KIT GAP**'tir.

Import (tek satır, her ekranda):

```dart
import 'package:flight_booking/core/theme/theme.dart'; // ui_kit + AppTheme
```

Kodlar:
- Kit (genel, domain bilmez): [module/ui_kit/lib/](../../module/ui_kit/lib/)
- Ürün bileşenleri (uçuş domain'i): [lib/product/widget/flight/](../../lib/product/widget/flight/)
- Galeri (tüm durumlar, light/dark): `cd module/ui_kit/example && flutter run -d chrome`

---

## 1. Token'lar

| Board (CSS) | Kod |
|---|---|
| `var(--primary)`, `--onPrimary`, `--primaryContainer`, `--secondary*`, `--tertiary*`, `--error*`, `--surface`, `--onSurface`, `--surfaceContainerHighest`, `--onSurfaceVariant`, `--outline`, `--outlineVariant`, `--scrim` | `context.colorScheme.<ad>` |
| `--brandPrimary`, `--brandSecondary`, `--success`, `--onSuccess`, `--successContainer`, `--onSuccessContainer`, `--warning`, `--onWarning`, `--warningContainer`, `--onWarningContainer`, `--info`, `--infoContainer`, `--onInfoContainer`, `--cardBackground`, `--divider`, `--shimmerBase`, `--shimmerHighlight` | `context.appTheme.<ad>` |
| `.g8` `.g10` `.g16` `.g20` `.g24` `.g32` (gap / padding) | `AppSizes.spacingXs` (8) · `spacingS` (10) · `spacingM` (16) · `spacingL` (20) · `spacingXl` (24) · `spacingXXl` (32) |
| sayfa yatay padding 20 | `AppSizes.pagePadding` / `AppPagePadding.horizontalSymmetric()` |
| `border-radius: 8 / 12 / 24` | `AppRadius.small` / `AppRadius.medium` / `AppRadius.large` |
| yükseklikler 44 / 48 / 56 / 64 / 72 / 96 | `AppSizes.touchTarget` / `buttonHeightMedium` / `textFieldHeight` / `appBarHeight` / `avatarLarge` / `stateIllustration` |

Tipografi sınıfları → `ProductText.<rol>(context, text, color: …)`:

| Board | Rol | | Board | Rol |
|---|---|---|---|---|
| `.dl` `.dm` `.ds` | `displayLarge/Medium/Small` (theme) | | `.bl` | `ProductText.bodyLarge` |
| `.hl` | `headlineLarge` (theme) | | `.bm` | `ProductText.bodyMedium` |
| `.hm` | `ProductText.h1` (headlineMedium) | | `.bs` | `ProductText.bodySmall` |
| `.hs` | `ProductText.h2` (headlineSmall) | | `.ll` | `ProductText.labelLarge` |
| `.tl` | `ProductText.titleLarge` / `h3` | | `.lm` | `ProductText.labelMedium` |
| `.tm` | `ProductText.titleMedium` / `h4` | | `.ls` | `ProductText.labelSmall` |
| `.ts` | `ProductText.titleSmall` | | `.ov` | `color: context.colorScheme.onSurfaceVariant` |
| `.w5` | `style: TextStyle(fontWeight: FontWeight.w500)` | | `.upper` | metni `toUpperCase()` |

`ProductText`'in rengi varsayılan olarak temadan (`onSurface`) gelir; sadece semantik bir
override için `color:` verilir.

## 2. Bileşenler

| Board (sınıf / ad) | Widget | Not |
|---|---|---|
| `.btn.b-p` | `AppButton.primary` | `isLoading`, `onPressed: null` = disabled, `expand: true` = `.fw` / `.hf` |
| `.btn.b-s` | `AppButton.secondary` | |
| `.btn.b-t` | `AppButton.text` | |
| `.btn.b-w` | `AppButton.warning` | sadece Update Required |
| `.ib` (ikon butonu) | `AppIconButton` | `tooltip` zorunlu (semantics) |
| `.ib` + `.bdg` | `BadgeIconButton` | `count` 0 → rozet yok, >9 → "9+" |
| `.bar` / `.bar.bk` | `AppTopBar` | geri butonu için `onBack:` |
| `.tf` | `AppTextField` | `label`, `leadingIcon`, `trailingActionLabel` (Show/Hide), `errorText`, `enabled` |
| `.tf` + arama ikonu | `AppSearchField` | `clearTooltip` zorunlu |
| `.chip` / `.chip.on` | `AppChip` | `selected` |
| `.sbd.s-warn/.s-ok/.s-info/.s-err/.s-n` | `StatusBadge(tone: AppTone.warning/success/info/error/neutral)` | |
| `.pt` / `.pt.sm` / `.pt.lg` | `PriceTag` / `PriceTag.small` / `PriceTag.large` | metin app'te formatlanır: `LocaleKeys.flight_price.translateArgs([...])` |
| `.ic` + label + value + `.dv` | `InfoRow` | `showDivider: false` son satırda |
| StatTile | `StatTile` | |
| `.av` | `AppAvatar(initials: AppAvatar.initialsOf(name))` | |
| InfoBanner | `InfoBanner` | `tone` varsayılan info |
| `.cd` | `AppCard` | `onTap` opsiyonel |
| `.dlg` | `AppDialog.show(context, …)` → `Future<bool?>` | `variant: AppDialogVariant.warning` |
| `.snk.k-ok/.k-er/.k-in/.k-wn` | `AppSnackbar.show(context, message:, tone: AppTone.success/error/info/warning, actionLabel:, onAction:)` | Undo = `actionLabel` |
| `.stt` + `.big.bg-sec` | `EmptyState` | `actionLabel` + `onAction` |
| `.stt` + `.big.bg-er` | `ErrorState` | `retryLabel` + `onRetry` |
| `.stt` + başarı ikonu | `StateMessage(tone: AppTone.success, …)` / `StateIcon` | booking confirmation |
| `.sh` (shimmer) | `LoadingState(skeleton: …)` / `LoadingState.custom(child: …)` + `ShimmerBox` | |
| `.sum` | `SummaryBar(label:, price:, action:)` | |
| sabit alt bar (Detail) | `BottomActionBar(child: …)` | |
| `.scrim` + spinner + metin | `LoadingOverlay(visible:, message:, child: page)` | |
| `.sw` / `.sw.o` | `AppSwitch` | `semanticLabel` zorunlu |
| `.seg` | `SegmentedToggle<T>` | |
| SettingsRow | `SettingsRow(icon:, title:, trailing:)` | |
| splash progress (linear 120×4) | `LinearProgressIndicator` (temalı) | ham widget serbest: tema renkleri verir |

### Ürün bileşenleri (`lib/product/widget/flight/`)

| Board | Widget | Not |
|---|---|---|
| FlightCard full | `FlightCard.full(…)` | model değil hazır değer alır; `isAdding` |
| FlightCard compact | `FlightCard.compact(…, onRemove:)` | |
| FlightCard skeleton | `FlightCardSkeleton` | `LoadingState(skeleton: FlightCardSkeleton())` |
| `.rt` (rota çizgisi) | `RouteLine` | |
| RouteVisual (Detail hero) | `RouteVisual(fromCity:, toCity:, fromCode:, toCode:, caption:)` | kod yoksa şehir öne çıkar |
| AirlineMark | `AirlineMark` | gerçek logo yok |

## 3. Uygulama sözleşmeleri (ekranlar bunları kullanır)

| İhtiyaç | Kod |
|---|---|
| Sepet (ekle, sil, geri al, temizle, rozet, toplam) | `ProductContainer.instance.get<CartCubit>()` — `add`, `removeAt` → silineni döner, `restore(index, flight)`, `clear()`; state: `items`, `count`, `totalPrice`, `isEmpty` |
| Tema / dil | `ProductContainer.instance.get<ApplicationCubit>()` — `toggleTheme()`, `changeLocale(...)`, `toggleLocale(context)`; state: `themeMode`, `locale` |
| Oturum | `ProductContainer.instance.get<AuthCubit>()` — çıkışta `CartCubit.clear()` de çağrılır |
| Uçuş verisi | `FlightModel` — NEW DATA alanları nullable: `fromCode`, `toCode`, `flightNumber`, `aircraftType`, `seatClass`, `baggageAllowance` |
| Ödeme sonucu | `CheckoutResponseModel.bookingReference` (nullable, NEW DATA) |
| Fiyat / tarih gösterimi | `ProductFormat.price(650, locale: …)` → "650 ₺" · `ProductFormat.date('2026-12-12', locale: …)` → "12 Dec 2026" · `shortDate` → "12 Dec" — `locale: context.productLocale.toLanguageTag()`. Ekranda elle format yazılmaz. |

## 4. KIT GAP kuralı

Board'da yukarıdaki tablolarda olmayan bir görsel parça varsa:

1. Kit'e **eklenmez** (kit'i değiştirmek design-system skill'inin işi).
2. Sadece kit parçalarından oluşuyorsa ekranın `view/widget/` klasöründe ekrana özel widget olur.
3. Kit'te karşılığı olmayan yeni bir görsel dil gerekiyorsa durulur; raporda `KIT GAP: <ne>` olarak
   yazılır, kullanıcıya sorulur.
