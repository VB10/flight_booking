# Code Generation & Localization (v12)

> Bu bölümün amacı tek cümlede: **string ile erişilen her şeyi derleyicinin
> kontrol ettiği bir API'ye çevirmek.** Asset yolları ve UI metinleri, tıpkı
> v11'de storage backend'ini package'a gömdüğümüz gibi, tek bir üretim kaynağının
> arkasına alınır.

## Neden?

v11 sonrası projede üç somut problem vardı:

1. **Sessizce kırık asset'ler.** Kod `assets/undraw_connected-world_anke.svg`
   istiyordu, dosya `assets/icon/svg/ic_connected_world.svg` idi. Derleme
   başarılı, ekran boş. `SvgPicture.asset('...')` bir string alır — yazım hatası
   runtime'a kadar saklanır.
2. **Karışık dil.** `'Sepete Ekle'`, `'Login'`, `'Profil yenilenemedi'`,
   `'Password'` aynı uygulamada yan yana; hiçbiri değiştirilebilir değil.
3. **Belirsiz codegen.** `scripts/build_runner.sh` ve `scripts/generate_models.sh`
   neredeyse aynı işi yapıyordu; ikincisinin açıklaması artık üretilmeyen Hive
   adapter'larından bahsediyordu.

## Mimari

```
lib/product/gen/                     # ÜRETİLİR — elle düzenlenmez
  assets.gen.dart                    # Assets.icon.svg.icAircraft
  fonts.gen.dart                     # FontFamily.roboto
  locale_keys.g.dart                 # LocaleKeys.login_submit

lib/product/localization/            # easy_localization'ın izin verildiği TEK yer
  locales.dart                       # enum Locales { tr, en } — dil kaydı
  product_localization.dart          # EasyLocalization wrapper (facade)
  localization_extension.dart        # String.translate + context.productDelegates

assets/translations/{tr,en}.json     # her Locales girdisi için bir dosya
scripts/generate.sh                  # tek codegen giriş noktası
build.yaml                           # hangi builder neyi üretiyor
```

### 1. Asset & font üretimi — flutter_gen

`pubspec.yaml` içindeki `flutter_gen:` bloğu çıktıyı `lib/product/gen/` altına
yazar. Klasör yapısı doğrudan API'ye dönüşür:

| Dosya | Erişim |
|-------|--------|
| `assets/icon/svg/ic_aircraft.svg` | `Assets.icon.svg.icAircraft.svg(...)` |
| `assets/animation/lottie/lottie_loading.json` | `Assets.animation.lottie.lottieLoading.lottie(...)` |
| `assets/fonts/Roboto-*.ttf` | `FontFamily.roboto` |

Font ailesi bu bölümde tamamlandı: `assets/fonts/` altındaki 18 varyantın 6'sı
tanımlıydı; şimdi hepsi `weight` + `style` ile kayıtlı.

Yeni asset eklemek: **`/masterflutter-asset-add`**

### 2. Localization — easy_localization, facade arkasında

Kural: **`package:easy_localization` sadece `lib/product/localization/` içinde
import edilir.** Uygulamanın geri kalanı şunları görür:

```dart
ProductText.labelLarge(context, LocaleKeys.flight_add_to_cart.translate)
LocaleKeys.flight_duration.translateArgs([flight.duration])   // "Süre: {}"
```

`MaterialApp.router` bile paketi görmez:

```dart
localizationsDelegates: context.productDelegates,
supportedLocales: context.productSupportedLocales,
locale: context.productLocale,
```

Bu, v11'deki cache yaklaşımının aynısıdır: paket bir implementation detail'dir,
değiştirilmesi tek klasörü etkiler.

**Dil kalıcılığı uygulamanın elindedir.** `saveLocale: false` verilir; seçilen
dil `ICacheManager` üzerinden `ProductCacheKeys.locale` anahtarına yazılır ve
`main.dart` açılışta `startLocale` olarak geri verir. Böylece v11 cache katmanı
ilk gerçek tüketicisini kazanır ve tek bir "kaynak of truth" kalır.

Dil değişimi `ApplicationCubit` üzerinden:

```dart
context.read<ApplicationCubit>().toggleLocale(context);   // tr <-> en
```

#### Parametrik kullanım

| JSON | Çağrı |
|------|-------|
| `"Süre: {}"` | `LocaleKeys.flight_duration.translateArgs([flight.duration])` |
| `"Test hesabı: {email} / {password}"` | `LocaleKeys.login_test_account_info.translateNamed({'email': ..., 'password': ...})` |
| `{"one": "...1 bilet var.", "other": "...{} bilet var."}` | `LocaleKeys.flight_added_to_cart.translatePlural(cartSize)` |

Üç kural:

1. **Sayıyı elle cümleye yapıştırma.** Hangi çoğul dalının seçileceği dilin
   kuralıdır (`zero`/`one`/`two`/`few`/`many`/`other`), Dart'ın değil.
2. **Veriyi çeviri dosyasına gömme.** Test hesabının e-postası bir dil değil,
   veri — kodda sabit, anahtara `translateNamed` ile enjekte edilir
   ([_login_test_account_info.dart](../lib/feature/unauth/login/view/widget/_login_test_account_info.dart)).
3. **Çeviriyi `MaterialApp`'in altında oku.** Üstünde okursan çeviri assetleri
   henüz yüklenmemiş olur: `translate` "key not found" uyarısı basar,
   `translatePlural` `LateInitializationError` atar. `MainApp` bu yüzden
   `title:` değil **`onGenerateTitle:`** kullanıyor.

Bu üç davranış testle sabitlendi:
[test/product/localization/product_localization_test.dart](../test/product/localization/product_localization_test.dart)

#### Log seviyesi

Paket her yaşam döngüsü adımını DEBUG olarak basıyor (`Start`, `Build`,
`Init provider`, …). `ProductLocalization.init()` bunu kısıyor:

```dart
EasyLocalization.logger.enableLevels = <LevelMessages>[
  LevelMessages.error,
  LevelMessages.warning,
];
```

DEBUG/INFO gürültüsü gider, sinyal kalır: **eksik anahtar WARNING**, yükleme
hatası ERROR. Release build'de paket zaten sessiz (`enableBuildModes` varsayılanı
`[debug, profile]`).

Yeni anahtar / yeni dil: **`/masterflutter-localization-add-key`**

### 3. Tek codegen giriş noktası

`./scripts/generate.sh` sırasıyla easy_localization CLI'ını (LocaleKeys bir
build_runner builder'ı **değildir**) ve `build_runner build`'i çalıştırır.
Flag'ler: `--watch`, `--clean`, `--localization`, `--assets`. `.vscode/tasks.json`
içinden de aynı script çağrılır.

## Bu bölümde değişen call site'lar

| Dosya | Değişiklik |
|-------|-----------|
| `splash_page.dart` | Lottie path → `Assets.animation.lottie.lottieLoading`, başlık + slogan → LocaleKeys |
| `login_page.dart` + `view/widget/*` | kırık SVG → `Assets.icon.svg.icAircraft`, tüm form metinleri → LocaleKeys |
| `login_cubit.dart` | hata mesajı fallback'i → `LocaleKeys.login_failed` |
| `_login_test_account_info.dart` | kimlik bilgileri kod sabiti + `translateNamed` |
| `flight_list_page.dart` | 2 kırık SVG + 14 metin → generated erişim, app bar'a dil butonu |
| `app_theme.dart`, `app_text_styles.dart` | `'Roboto'` → `FontFamily.roboto` |
| `main_app.dart`, `main.dart`, `app_initializer.dart` | localization bootstrap |
| `application_cubit.dart` | `locale` state + cache'e yazan `changeLocale` |

Kalan ekranlar (cart, profile, flight detail) bilinçli olarak dışarıda bırakıldı;
`/masterflutter-localization-add-key` ile aynı desende taşınacaklar.

## Kurallar

- `'assets/...'` string'i widget içinde yazılmaz.
- `lib/product/gen/` elle düzenlenmez — `./scripts/generate.sh` ile üretilir.
- `package:easy_localization` `lib/product/localization/` dışında import edilmez.
- Bir dil sadece JSON dosyasıyla eklenmez; `enum Locales` tek kayıt yeridir.
- Çeviri anahtarı tüm dil dosyalarına aynı `{}` sayısıyla eklenir.
- Analytics/event/cache key gibi teknik string'ler çevrilmez.

## İlgili

| | |
|---|---|
| Issue | https://github.com/VB10/flight_booking/issues/17 |
| Skill/command | `/masterflutter-codegen-setup`, `/masterflutter-asset-add`, `/masterflutter-localization-add-key` |
| Önceki bölüm | [cache_architecture.md](cache_architecture.md) (v11) |
