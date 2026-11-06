# Claude Design ile Yeni Tasarım + Widget Kütüphanesi (v13)

> Bu bölümün amacı tek cümlede: **AI ile üretilen bir tasarımı, tahmin yürütmeden ve
> mimariyi bozmadan uygulamaya bağlamak.** Önce tasarımın dili (token'lar + bileşenler) bir
> pakete dönüşür, sonra her ekran o dili kullanarak koda bağlanır. İşin pahalı ve karar
> gerektiren kısmını Opus, tekrar eden kısmını Sonnet yapar.

## Neden?

v12 sonrası projede üç problem vardı:

1. **Tasarım yoktu.** Ekranlar "çalışsın yeter" mantığıyla yazılmıştı; her sayfada farklı bir
   buton, farklı bir boşluk vardı.
2. **Ortak widget katmanı yoktu.** `ElevatedButton` 16 yerde, `SnackBar` 14 yerde, `Card` 14
   yerde elle kurulmuştu. Flight list sayfası tek dosyada 713 satırdı.
3. **AI tasarım araçları koda uymuyor.** "Güzel bir ekran yap" denince rastgele renkler,
   uygulamada olmayan veriler ve her ekranda başka bir stil çıkıyor. Bunu koda geçirmek
   baştan tasarlamak kadar sürüyor.

## Akış — 5 adım

```
 ① Prompt            ② Claude Design         ③ Design system (Opus)      ④ Ekranlar (Sonnet)       ⑤ Review
 ─────────           ───────────────         ──────────────────────      ──────────────────        ────────
 Projenin token       Kit sayfası +           module/ui_kit paketi         Her ekran ayrı bir         masterflutter-
 isimleri ve          6 ekran + durumlar      + ürün bileşenleri           agent, sırayla:            reviewer tüm
 veri alanlarıyla     + handoff notları       + ortak state / veri         board → kit_mapping →      diff'i denetler,
 yazılmış prompt      (export klasörü)        + kit_mapping.md             feature klasörü            bulgular düzeltilir
```

| Adım | Çıktı | Nerede |
|---|---|---|
| ① Prompt | Claude Design'a verilen tek prompt | [docs/design/claude_design_prompt.md](design/claude_design_prompt.md) |
| ② Export | Board'lar (`*.dc.html`), handoff, FLUTTER_PROMPT | [docs/design/claude_design/](design/claude_design/) |
| ③ Design system | Paket, galeri, testler, sözlük | [module/ui_kit](../module/ui_kit/), [docs/design/kit_mapping.md](design/kit_mapping.md) |
| ④ Ekranlar | 6 feature klasörü | `lib/feature/**` |
| ⑤ Review | Bulgular + düzeltmeler + testler | bu doküman › "Review'dan çıkanlar" |

## ① Prompt — tasarımı koda uyumlu üretmek

Prompt üç şeyi garanti eder:

- **Tek kit:** önce design system sayfası, sonra her ekran aynı bileşenleri kullanır.
- **Koddaki isimler:** renk rolleri (`brandPrimary`, `cardBackground`…), boşluk ölçeği
  (8/10/16/20/24/32) ve bileşen adları (`AppButton`, `FlightCard`…) projedekiyle aynı.
- **Etiketli değişiklik:** tasarım yeni bir alan ya da özellik eklerse `NEW DATA` /
  `NEW FEATURE` diye işaretler. Backend'e ne ekleneceği tek listede çıkar.

## ② Claude Design export'u

Export bir klasör: her board düz HTML/CSS. Token'lar `<style>` içinde CSS değişkeni, örnek veri
ve durum listesi `<script>` içinde. `Handoff.dc.html` her ekranın bileşen envanterini,
NEW DATA / FEATURE listesini ve navigasyon haritasını veriyor.

Export'un önerdiği mimariyi (**Riverpod, Freezed, Clean Architecture**) almadık. Bizim mimari
(Cubit + mixin, GetIt, typed go_router, LocaleKeys) kaldı; tasarımdan sadece görsel dil alındı.

## ③ Design system — Opus

### Katmanlar

```
lib/core/theme/theme.dart          ← ekranların tek import'u (re-export + AppTheme)
        │
        ├── module/ui_kit           ← GENEL: domain bilmez, asset ve çeviri içermez
        │     src/theme/            AppColors · AppColorScheme · AppThemeExtension ·
        │                           AppTextStyles · AppSizes · AppRadius · ProductText · UiKitTheme
        │     src/widget/           button · input · navigation · display · feedback · state · layout
        │     example/              web galerisi (tüm bileşenler × durumlar, light/dark)
        │
        └── lib/product/widget/flight/   ← DOMAIN: kit parçalarından kurulur
                                    FlightCard (full/compact) · RouteVisual · RouteLine · AirlineMark
```

### Kararlar

| Karar | Neden |
|---|---|
| Kit ayrı bir paket (`module/ui_kit`), boş `module/utils` silindi | v11'deki `cache_manager` gibi: sınırı derleyici korur, tek başına test edilir, galerisi olur |
| Tema dosyaları `git mv` ile pakete taşındı | History korunur; eski API'ler (`AppRadius.circular12`…) ekranlar bağlanana kadar derlenmeye devam etti |
| Font paketin içinde değil, app veriyor (`UiKitTheme.light(fontFamily:)`) | Paket asset'siz kalır; font `FontFamily.roboto` (v12 codegen) üzerinden gelir |
| Widget'lar hazır string alır | Çeviri app'te (`LocaleKeys`), paket dil bilmez |
| `FlightCard` pakette değil, `lib/product`'ta | "Uçuş" bir domain kavramı; kit genel kalmalı |
| Dialog ve snackbar `show` helper'ı | Ekranlar `showDialog` / `SnackBar`'a hiç dokunmaz |

### Ekranların paylaştığı sözleşmeler

Bunları ekranlardan **önce** Opus kurdu; aksi halde paralel çalışan agent'lar aynı şeyi farklı
şekilde yazardı:

| Sözleşme | Neden gerekti |
|---|---|
| **`CartCubit`** (app geneli) | Sepet eskiden Flights sayfasının içindeki bir `ValueNotifier`'dı. Tasarımda Detail'den sepete ekleme, top bar rozeti, Cart ve onay ekranı aynı sepeti kullanıyor |
| **`ProductFormat`** | "12 Dec 2026" ve "1.250 ₺" üç ekranda aynı görünmeli; locale'e göre (EN/TR) |
| **`IAppUpdateService`** | Zorunlu güncelleme kontrolü Flights'tan Splash'e taşındı |
| **NEW DATA** | `FlightModel`: `fromCode`, `toCode`, `flightNumber`, `aircraftType`, `seatClass`, `baggageAllowance` · `CheckoutResponseModel.bookingReference` — hepsi nullable (eski backend'le de çalışır). Backend mock'u güncellendi, gerçek havayolu isimleri kurgusal olanlarla değişti |

### `kit_mapping.md` — iki fazın sözleşmesi

Board'daki her CSS sınıfının ve token'ın koddaki karşılığı: `.btn.b-p` → `AppButton.primary`,
`var(--warningContainer)` → `context.appTheme.warningContainer`, `.g16` →
`AppSizes.spacingM`… Ekran bağlayan agent tahmin yapmaz, buradan bakar. Burada olmayan şey
**KIT GAP**'tir: kit'e eklenmez, raporlanır.

## ④ Ekranlar — Sonnet

Her ekran `masterflutter-screen-binder` agent'ına (Sonnet) tek tek verildi. **Sırayla**,
paralel değil: hepsi aynı çeviri dosyalarına, route'lara ve üretilen koda yazıyor.

| Ekran | Önce | Sonra |
|---|---|---|
| Splash | Lottie + "Yükleniyor..." (sabit metin) | Marka işareti + progress; zorunlu güncelleme kontrolü buraya taşındı |
| Login | Primary AppBar, ham `TextField` | İllüstrasyon, kit alanları, istemci doğrulaması, test hesabını tek dokunuşla doldurma |
| Flights | 713 satır tek dosya, sayfa içi sepet | Arama, tarih filtresi, sıralama; tema/dil Profile'a taşındı; app geneli sepet |
| Detail | Route'tan gelen Map | Rota hero'su, NEW DATA kutuları, deep link'te yükleme/hata |
| Cart | 436 satır, `$extra` ile gelen liste | Undo, kaydırarak silme, ödeme overlay'i, rezervasyon onay ekranı |
| Profile | 382 satır | Avatar, istatistikler, **Settings** (tema switch + EN/TR) |

Her ekran board'daki **tüm durumlarıyla** bağlandı: loading (shimmer), empty, error + retry,
içerik, dialog'lar, snackbar'lar.

## ⑤ Review'dan çıkanlar

`masterflutter-reviewer` tüm diff'i denetledi. Kural ihlali çıkmadı ama 4 ciddi hata çıktı;
dördü de düzeltildi ve teste bağlandı:

| Hata | Çözüm |
|---|---|
| Ödeme sürerken geri basılınca sipariş oluşuyor ama sepet temizlenmiyordu → **çift ödeme** | Sepet her durumda önce temizleniyor; ödeme sırasında geri kapalı (`PopScope`) |
| 401 ile oturum düşünce sepet sonraki kullanıcıya kalıyordu | `ProductContainer` oturumu dinliyor: her çıkışta sepet tek yerden temizleniyor |
| Aynı uçuş iki kez eklenip kaydırılınca liste bozuluyordu | Her sepet kalemi ayrı instance + `ObjectKey` |
| Sayfa kapandıktan sonra cubit'e emit → `StateError` | Her `await` sonrası `isClosed` kontrolü |

Agent'ların raporlarından da bir ders çıktı: iki agent doğrulama sırasında `git stash` /
`git checkout` kullandı. İş kaybolmadı ama ekran skill'ine **"git durumunu değiştirme"**
kuralı eklendi.

## Rakamlar

| | Önce | Sonra |
|---|---|---|
| `flutter analyze` bulgusu | 84 | 1 (eski kod, info) |
| Uygulama testi (backend açık) | 17 | 26, hepsi yeşil |
| Kit testi | — | 15 |
| En büyük sayfa | 713 satır | sayfa + mixin + parçalar |
| Ekranlardaki ham `ElevatedButton` / `SnackBar` / `Card` | 16 / 14 / 14 | 0 |

## AI katmanı — bundan sonra nasıl kullanılır

| | Model | Ne zaman |
|---|---|---|
| [`/masterflutter-design-system-setup`](../.claude/skills/masterflutter-design-system-setup/SKILL.md) | **Opus** | Sıfırdan bir projeye tasarım export'u geldiğinde: paket, galeri, sözleşmeler, `kit_mapping.md`; sonra ekranları Sonnet'e dağıtır |
| [`/masterflutter-design-screen`](../.claude/skills/masterflutter-design-screen/SKILL.md) | **Sonnet** | Yeni bir ekran tasarımdan geldiğinde — tek ekran, kit'e dokunmaz |
| [`masterflutter-screen-binder`](../.claude/agents/masterflutter-screen-binder.md) agent | Sonnet | Ekran skill'ini çalıştırır |
| [`masterflutter-reviewer`](../.claude/agents/masterflutter-reviewer.md) agent | — | §8 Design kit kuralı eklendi |

**Neden iki model?** Design system karar işi: neyin token, neyin bileşen olduğu, paket sınırı,
ekranların paylaşacağı state. Ekran bağlamak ise sözlük işi: `kit_mapping.md` hazırsa her ekran
bir kontrol listesi. Pahalı model bir kez, ucuz model ekran sayısı kadar çalışır.

## Çalıştırmak

```bash
# Uygulama + backend (VS Code › Run and Debug › "App + Backend")
# 8080 doluysa eski server'ı kapatıp yenisini açar
./start_backend.sh            # sadece backend
flutter run                   # sadece uygulama

# Kit galerisi — backend gerekmez
cd module/ui_kit/example && flutter run -d chrome
```

Dark tema ve dil: **Profile › Settings**.

## Ertelenenler

Küçük ve önceliksiz işler [NOTES.md](../NOTES.md)'de: booking history ekranı, "Update"
butonunun mağazayı açması, backend'den gelen metinlerin Türkçesi, çevirilerde sen/siz birliği…
