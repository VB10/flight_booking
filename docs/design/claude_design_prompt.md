# Claude Design ile Yeni Tasarım (v13)

> Bu bölümde amaç, uygulamanın tüm ekranlarını **mevcut design system'e bağlı**
> şekilde Claude Design'da yeniden tasarlamak ve çıkan tasarımı tahmin yürütmeden
> koda taşıyabilmek. Aşağıdaki prompt bu repo için yazıldı, ama yapısı her
> Flutter projesine uyarlanabilir.

## Neden bu yöntem?

AI tasarım araçlarına "bana güzel bir uçuş ekranı yap" dediğinizde güzel ama
**koda karşılığı olmayan** bir sonuç alırsınız: rastgele renkler, her ekranda
farklı bir buton, sizin uygulamanızda olmayan veriler. Sonra bu tasarımı
uygulamaya geçirmek yeniden tasarlamak kadar sürer.

Bu prompt üç şeyi garanti altına alır:

1. **Tek kit.** Önce design system sayfası kurulur, her ekran aynı token ve
   bileşenleri tekrar kullanır. Tasarım dağılmaz.
2. **Koddaki isimler.** Renk rolleri (`brandPrimary`, `cardBackground`…),
   boşluk ölçeği (8 / 10 / 16 / 20 / 24 / 32) ve bileşen adları (`AppButton`,
   `FlightCard`…) projedeki karşılıklarıyla birebir aynı. Tasarımdaki her parça
   doğrudan bir widget'a eşlenir.
3. **Etiketli değişiklik.** Tasarım yeni bir alan ya da özellik eklerse
   `NEW DATA` / `NEW FEATURE` olarak işaretlenir. Sonunda backend'e ve modellere
   ne ekleneceği tek bir listede çıkar.

## Nasıl kullanılır?

1. Claude Design'da yeni bir proje açın.
2. **(Önerilir)** Repoyu ya da sadece `lib/core/theme/` klasörünü bağlayın.
   Prompt renkleri hex yerine rol adıyla verir; kesin değerleri tema
   dosyalarından okur.
3. Aşağıdaki prompt'u **tek seferde** yapıştırın.
4. Çıktıyı (export, ekran görüntüleri, en sondaki handoff notları) repoda
   `docs/design/` altına koyun.
5. Handoff notlarındaki iki liste sonraki adımın girdisidir:
   - **Component inventory:** widget paketi ve `/masterflutter-design-implement`
     skill'i bunun üzerine kurulur.
   - **NEW DATA / NEW FEATURE listesi:** backend endpoint'leri ve modeller buna
     göre güncellenir.

## Kendi projenize uyarlamak

Prompt'un iskeleti sabit; değiştirmeniz gerekenler:

| Bölüm | Ne koymalısınız |
|---|---|
| Giriş paragrafı | Uygulamanızın adı ve kategorisi |
| PAGE 0 — color roles | `ColorScheme` + varsa `ThemeExtension` alanlarınızın **adları** |
| Spacing / radius / typography | Kendi padding sınıfınızdaki değerler, fontunuz |
| Base components | Widget'larınıza vermek istediğiniz isimler |
| Her ekranın "Existing data" satırı | O ekranın modelindeki alanlar ve mevcut aksiyonlar |
| States | Ekranın gerçekten girebildiği durumlar (loading, empty, error…) |

İki kural değişmesin:

- **Gerçek marka, logo ve havayolu adı yok.** Kurgusal isimler ve sentetik veri
  kullanılır.
- **Her ekranda "reuse the same tokens and components" vurgusu kalsın.** Kit
  tutarlılığını sağlayan cümle bu.

## Prompt

Tamamını tek seferde Claude Design'a yapıştırın:

```text
I'm redesigning an existing Flutter app called "Flight Booking" — a flight ticket booking app. Mobile-first, Material 3, light AND dark mode for every screen. Design it as ONE coherent kit: first a design system page, then every screen, then a component-states page. Every screen must reuse the same tokens and components — no one-off styles.

The backend is ours, so you may improve the screens and add fields or small features where they clearly help the booking flow. But label every addition so I can map it back to code:
- "NEW DATA: <field>" for any data the app does not have today
- "NEW FEATURE: <feature>" for any new interaction or screen
Data the app already has is listed per screen below as "Existing data".

Content rules: no real airline names, logos or brands — use fictional airlines (e.g. "Skyline Air", "Nordwind", "Azure Jet"). Fictional people and synthetic data only. Currency is Turkish lira (₺). The UI language is English; Turkish must also fit, so leave room for ~30% longer labels.

────────────────────────────────
PAGE 0 — DESIGN SYSTEM (kit page)
────────────────────────────────
It must mirror the app's existing tokens so it maps 1:1 to code. Use these exact names in the labels.

COLOR ROLES (Material 3 semantic, light + dark): primary (blue family), secondary (light-blue family), tertiary (green), error, surface, onSurface, surfaceContainerHighest, onSurfaceVariant, outline, outlineVariant.
Extra semantic roles: brandPrimary, brandSecondary, success (green), warning (orange), info, cardBackground, divider, shimmerBase, shimmerHighlight.

SPACING SCALE: 8, 10, 16, 20, 24, 32. Page horizontal padding = 20.
TYPOGRAPHY: Roboto, Material 3 type scale — display, headline, title (L/M/S), body (L/M/S), label (L/M/S). App headings h1–h4 map onto headline/title.
CORNER RADIUS: small / medium / large, consistent across cards, buttons, fields, dialogs and sheets.

BASE COMPONENTS (name each exactly like this — they become Flutter widgets):
- AppButton: primary / secondary / text, with default, pressed, loading, disabled
- AppTextField: default, focused, filled, error; optional leading icon and trailing action (e.g. Show/Hide)
- AppTopBar: title, back, action icons
- BadgeIconButton: icon with a count badge (0 / 1 / 9+)
- FlightCard: full and compact variants — airline, from → to, departure/arrival time, duration, date, price, actions
- PriceTag, InfoRow (icon + label + value), StatTile, StatusBadge (e.g. membership level)
- AppDialog: title, message, cancel + confirm; a warning variant
- AppSnackbar: success / error / info
- LoadingState (shimmer skeleton), EmptyState (icon + message + optional action), ErrorState (message + "Try Again")
- Add any other component you need, but name it and put it on this page.

────────────────────────────────
SCREEN 1 — SPLASH
────────────────────────────────
Existing behaviour: shows the app mark while the app starts and checks whether a forced update is required.
Existing data: app name "Flight Booking", tagline "Flight Ticket Booking App".
Design: centered abstract aircraft mark (no real logo), app name, tagline, subtle loading indicator.
States: loading; "Update Required" — warning-variant AppDialog over the splash, message "A new version is available! Please update the app.", actions "Later" / "Update".

────────────────────────────────
SCREEN 2 — LOGIN
────────────────────────────────
Existing data: email, password. A demo-account helper shows "Test account: {email} / {password}".
Design: illustration area (abstract travel/world theme), title, AppTextField "Email", AppTextField "Password" with Show/Hide, primary AppButton "Login", text toggle "Show test account" / "Hide test account" revealing an info box.
States: default, filled, field validation error, submitting (button loading), failed (AppSnackbar error "Login failed").

────────────────────────────────
SCREEN 3 — FLIGHTS (home)
────────────────────────────────
Existing data per flight: id, airline, from, to, departureTime, arrivalTime, duration, date, price.
Existing actions: open details, add to cart, open cart (badge with ticket count), toggle theme (light/dark), switch language (EN/TR), open profile, log out.
Design: AppTopBar "Flights" with actions; a list of FlightCard, each with "Details" (secondary) and "Add to Cart" (primary); a cart BadgeIconButton (floating or in the top bar — pick one and say why). You may move theme/language into Profile if that reads better — label it.
States: LoadingState (shimmer cards), EmptyState, ErrorState, content.
Feedback: add to cart → AppSnackbar success "Ticket added. You have 2 tickets in your cart."; log out → AppDialog "Are you sure you want to log out?" with "Cancel" / "Log Out".
Search, date or route filters and sorting are welcome as NEW FEATURE.

────────────────────────────────
SCREEN 4 — FLIGHT DETAIL
────────────────────────────────
Existing data: same flight fields as above.
Design: AppTopBar with back; hero showing from → to with a route visual (two airports joined by a flight path), airline; InfoRow list — departure, arrival, duration, date; prominent PriceTag; bottom-pinned primary AppButton "Add to Cart".
States: loading, ErrorState, content.
Things like baggage allowance, flight number, aircraft type or seat class are welcome — label them NEW DATA.

────────────────────────────────
SCREEN 5 — MY CART
────────────────────────────────
Existing data: list of tickets added (same flight fields), total price.
Existing actions: remove a ticket, pay for all.
Design: AppTopBar "My Cart"; compact FlightCard list with a remove action (swipe or trailing icon); bottom summary bar with "Total:" + PriceTag + primary AppButton "Pay".
States: EmptyState "Your cart is empty" (with an action back to Flights); removed → AppSnackbar "Ticket removed from cart!"; pay with empty cart → AppSnackbar warning "Your cart is empty!"; Pay → AppDialog "Payment Confirmation" / "Are you sure you want to pay a total of 1.250 ₺?" with "Cancel" / "Confirm"; processing → blocking overlay "Processing payment..."; ErrorState "Connection error".
A payment success / booking confirmation screen is welcome as NEW FEATURE.

────────────────────────────────
SCREEN 6 — PROFILE
────────────────────────────────
Existing data: id, name, email, joinDate, totalBookings, membershipLevel.
Existing actions: refresh, log out.
Design: AppTopBar with refresh and log out; header with an initials avatar (no photo), name, email, StatusBadge for membership level (e.g. Gold); stats row — StatTile "Total bookings", StatTile "Member since"; InfoRow list for account details.
States: LoadingState (shimmer header + tiles), ErrorState, content.
If you moved theme/language here, add a settings section. Booking history is welcome as NEW FEATURE.

────────────────────────────────
PAGE 7 — COMPONENT STATES (handoff)
────────────────────────────────
Show every kit component in all its states side by side, light and dark, each labeled with its exact component name: AppButton (all variants × states), AppTextField (all states), AppDialog (confirm + warning), AppSnackbar (success / error / info / warning), LoadingState, EmptyState, ErrorState, FlightCard (full + compact), BadgeIconButton (0 / 1 / 9+), StatusBadge, plus any component you added.

────────────────────────────────
HANDOFF NOTES (end of the file)
────────────────────────────────
1. Component inventory per screen: component name, variant, state, and the tokens it uses (color role, spacing value, radius, text style).
2. A single list of every "NEW DATA" and "NEW FEATURE" label, grouped by screen.
3. Navigation map: which screen leads to which.
```

## Sonraki adım

Tasarım geldikten sonra akış şöyle:

1. **Widget paketi:** handoff'taki bileşen listesi `module/` altında bir pakete
   dönüşür. `module/cache_manager` (v11) aynı yapıya örnektir.
2. **`/masterflutter-design-implement` skill'i:** tasarımdaki bileşenleri bu
   reponun mimarisine bağlar. Renk ve stil için `context.appTheme`, boşluk için
   `AppPagePadding`, metin için `ProductText` ve `LocaleKeys`, ekran mantığı için
   Cubit + mixin kullanır. Kitte karşılığı olmayan bir şey çıkarsa `KIT GAP`
   diye işaretleyip sorar.
3. **Pilot ekran:** önce Cart ya da Profile entegre edilir, sonra kalanlar.

İlgili dokümanlar: [theme.md](../theme.md) ·
[codegen_and_localization.md](../codegen_and_localization.md) ·
[cache_architecture.md](../cache_architecture.md)
