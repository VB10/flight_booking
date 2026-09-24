# 🎬 v12 — Code Generation & Localization (Video İçeriği)

> Flutter Refactoring Masterclass serisinin 12. bölümü için hazır video metni:
> başlık, açıklama, bölümler, kapak fotoğrafı notu ve yayın sonrası README satırı.

---

## 📌 Başlık (Title)

**Flutter Refactoring Masterclass: 12- Asset & Localization — flutter_gen + easy_localization (Prompt & AI Skills)**

Alternatifler:
- `12- String'e Elveda: flutter_gen + easy_localization ile Type-Safe Asset ve Çeviri`
- `12- Flutter Localization & Asset Generation: Facade Arkasında easy_localization (AI Skills)`

---

## 📝 Kısa Açıklama (Pinned / Özet)

Bu bölümde projedeki **string ile erişilen her şeyi derleyicinin kontrol ettiği bir
API'ye** çeviriyoruz. `flutter_gen` ile asset ve font'lar `Assets.icon.svg.icAircraft`
/ `FontFamily.roboto` olur; `easy_localization`'ı ise v11'deki cache felsefesinin
aynısıyla bir **facade arkasına gizliyoruz** — sayfalar paketi hiç görmüyor, sadece
`LocaleKeys.login_submit.translate` görüyor. Seçilen dil v11'de kurduğumuz
`ICacheManager` ile kalıcı hale geliyor. Bonus: tek `generate.sh` girişi ve üç yeni
AI Skill.

---

## 📄 Uzun Açıklama (YouTube Description)

Refactoring Masterclass serimizin bu bölümünde projedeki en sinsi hata kaynağını
temizliyoruz: **string'ler.** Bir asset yolunu yanlış yazarsanız derleyici susar,
ekran boş gelir; UI metinleri koda gömülüyse uygulamanız asla ikinci bir dile
açılamaz.

flutter_gen, easy_localization, facade pattern ve tek bir codegen giriş noktasıyla;
asset'i de metni de derleme zamanında garanti altına alınmış, çok dilli ve tekrar
üretilebilir bir yapıya taşıyoruz.

🛠 Bu Bölümde Neler İnşa Ettik?

Type-Safe Asset & Font Erişimi (flutter_gen): `SvgPicture.asset('assets/...')`
çağrılarını tarihe gömdük. Klasör yapısı doğrudan API'ye dönüşüyor:
`Assets.icon.svg.icAircraft`, `Assets.animation.lottie.lottieLoading`. Projede
sessizce kırık olan 3 SVG yolunu da bu sayede yakaladık — biri isim değişmiş,
dosya duruyor ama ekran boştu.

Eksiksiz Font Ailesi: `assets/fonts/` altındaki 18 Roboto varyantının sadece 6'sı
pubspec'te tanımlıydı. Hepsini `weight` + `style` ile kaydettik; tema artık
`'Roboto'` string'i değil `FontFamily.roboto` kullanıyor.

Facade Arkasında easy_localization: v11'de Hive'ı package'a gömmüştük; burada da
aynısını yapıyoruz. `package:easy_localization` **sadece**
`lib/product/localization/` içinde import ediliyor. Uygulamanın geri kalanı
`LocaleKeys.flight_add_to_cart.translate` görüyor — `MaterialApp.router` bile
paketi görmüyor, `context.productDelegates` üzerinden besleniyor.

Dil Kalıcılığı Uygulamanın Elinde: Pakete `saveLocale: false` diyoruz; seçilen dil
v11'de kurduğumuz `ICacheManager` ile `ProductCacheKeys.locale` anahtarına yazılıyor
ve açılışta `startLocale` olarak geri veriliyor. Cache katmanımız ilk gerçek
tüketicisini kazanıyor, tek bir "source of truth" kalıyor.

Parametrik ve Çoğullu Çeviri: `translate`, `translateArgs`, `translateNamed`,
`translatePlural`. Sayıyı cümleye elle yapıştırmanın neden bug olduğunu, test
hesabı gibi **verinin** neden çeviri dosyasına girmemesi gerektiğini ve çevirinin
neden `MaterialApp`'in altında okunması gerektiğini (`title:` değil
`onGenerateTitle:`) tek tek konuşuyoruz. Üçü de testle sabitlendi.

Tek Codegen Girişi: `build_runner.sh` + `generate_models.sh` ikilisini tek bir
`./scripts/generate.sh`'a indirdik. `--watch`, `--clean`, `--localization`, `--assets`
flag'leri var; LocaleKeys bir build_runner builder'ı olmadığı için easy_localization
CLI'ı da aynı script içinden sırayla çalışıyor.

AI-Native Geliştirme: `/masterflutter-codegen-setup` ile tüm bu altyapıyı,
`/masterflutter-asset-add` ile yeni bir ikonu, `/masterflutter-localization-add-key` ile
yeni bir çeviri anahtarını (ya da komple yeni bir dili) saniyeler içinde
kurabiliyorsunuz. Tüm skill'ler bu bölümde `masterflutter-` prefix'ine taşındı.

Bağımlılık Çatışmasını Canlı Çözmek: `flutter_gen_runner` eklerken pub çözümü
kilitlendi — `flutter_gen_core` → `image` → `archive ^4` isterken projedeki
`lottie 2.x` `archive ^3`'e bağlıydı. Hata mesajını birlikte okuyup lottie'yi
3.x'e çıkarıyoruz; bu tür bir çatışmayı okumak tek başına bir ders.

Tek Kaynak: Command Katmanını Sildik: Bu bölüme kadar her yetenek iki dosyaydı —
`.claude/commands/x.md` ve `.claude/skills/x/SKILL.md`. Command'ın yaptığı tek iş
"şu skill'i oku" demekti; içindeki özet ise skill'den bağımsız eskiyordu. Command
katmanını tamamen kaldırdık: **10 skill, 0 command**. Skill'ler hem
`/masterflutter-...` ile elle çağrılıyor, hem de iş tarif edilince kendiliğinden
tetikleniyor.

İki Agent: `masterflutter-reviewer` diff'i **bu reponun kendi kurallarına** göre
denetliyor (ham asset string'i, feature'da easy_localization import'u, theme
token'ı yerine hardcoded renk, `Navigator.push`, doğrudan `SharedPreferences`) ve
her bulguda hangi skill'in düzelteceğini söylüyor. `masterflutter-refactor-scout`
ise bir sayfayı tarayıp ne kaldığını **sırayla** raporluyor: önce yapı, sonra
state, en son localization/asset.

Tek Komutla Ortam: `./scripts/setup.sh` — araç kontrolü, bağımlılıklar, kod
üretimi, VS Code eklentileri (`.vscode/extensions.json`) ve Claude Code
plugin'leri. `claude-mem` ile `i-have-adhd` artık `.claude/settings.json` ile
repo'ya bağlı; repoyu klonlayan tek komutla çalışır hâle geliyor.

🧩 İzleyeceğiniz Teknik Detaylar:

flutter_gen: pubspec `flutter_gen:` bloğu, çıktının `lib/product/gen/` altına
alınması, klasör → API dönüşümü.

Facade Pattern: `ProductLocalization`, `Locales` enum'u, `localization_extension`
ve paketin tek klasöre hapsedilmesi.

Cache Entegrasyonu: `saveLocale: false` + `ICacheManager` + `ApplicationCubit`
ile dil state'i ve kalıcılığı.

Çoğul & Parametre: `{}`, `{named}` ve `one/other` dallarının doğru kullanımı.

Bootstrap Sırası: `main.dart`, `AppInitializer`, `MainApp` — çeviri asset'leri ne
zaman hazır olur?

Log Gürültüsü: `EasyLocalization.logger.enableLevels` ile DEBUG'ı kısıp sinyali
bırakmak.

Test: Facade'ın üç davranışının widget test ile sabitlenmesi.

⏱ Bölümler:

00:00 - Giriş & Bu bölümde ne yapacağız?
01:20 - Problem: sessizce kırık asset'ler ve koda gömülü metinler
03:00 - flutter_gen kurulumu: pubspec bloğu & klasör düzeni
05:00 - Assets.* ile kırık SVG'leri yakalamak
06:45 - Font ailesi: 18 varyant, FontFamily.roboto
08:15 - easy_localization neden doğrudan kullanılmaz? Facade kararı
10:00 - ProductLocalization + Locales enum + translate extension
12:00 - LocaleKeys üretimi: easy_localization CLI neden build_runner değil?
13:30 - Dil kalıcılığı: saveLocale false + ICacheManager (v11 bağlantısı)
15:15 - ApplicationCubit ile dil değiştirme
16:45 - Parametre & çoğul: translateArgs, translateNamed, translatePlural
19:00 - Üç kural: sayıyı yapıştırma, veriyi gömme, MaterialApp'in altında oku
21:00 - Test: facade davranışını sabitlemek
22:30 - scripts/generate.sh: tek giriş, dört flag
24:00 - AI Skills: /masterflutter-codegen-setup, -asset-add, -localization-add-key
26:00 - Command katmanını silmek: neden tek kaynak (skill) yeterli
27:30 - Agent'lar: reviewer (kural denetimi) + refactor-scout (ne kaldı?)
29:00 - setup.sh: klonla, tek komutla çalışır hâle getir
30:30 - Özet & bir sonraki bölüm: v13 Custom Package & Widget Library

📂 Proje Linkleri ve Kaynaklar:
Videoda bahsettiğim tüm mimari dökümanlara ve AI promptlarına GitHub reposu
üzerinden ulaşabilirsiniz.
🔗 Kaynak kod: https://github.com/VB10/flight_booking
🔗 Issue #17 (asset + localization + codegen): https://github.com/VB10/flight_booking/issues/17
🔗 Issue #18 (AI katmanı: prefix, agent'lar, setup): https://github.com/VB10/flight_booking/issues/18
🔗 Mimari doküman: docs/codegen_and_localization.md
🔗 Önceki bölüm (v11 Cache): docs/cache_architecture.md
🔗 Tüm Playlist: https://www.youtube.com/playlist?list=PL1k5oWAuBhgUh7_hMrTDxZHsGOPGSP9La

Projenizde hâlâ `Text('Sepete Ekle')` yazan bir satır varsa bu bölüm tam size göre.
Sorularınızı yorumlarda bekliyorum!

Kendinize çok iyi bakın, bir sonraki içerikte görüşmek üzere!

#flutter #localization #i18n #fluttergen #easylocalization #codegen #dart #refactoring #cleanarchitecture #flutterdev

---

## ⏱️ Bölümler (Chapters / Timestamps)

> Süreleri kayıt sonrası doldur; sıra ve içerik hazır.

```
00:00  Giriş — bu bölümde ne yapacağız
00:00  Problem 1: sessizce kırık asset (kod bir yolu, dosya başka yerde)
00:00  Problem 2: karışık dil — 'Sepete Ekle' ve 'Login' aynı ekranda
00:00  Problem 3: belirsiz codegen — iki script neredeyse aynı işi yapıyor
00:00  flutter_gen: pubspec bloğu, çıktı lib/product/gen altına
00:00  Bağımlılık çatışması: archive v3 vs v4 — lottie'yi 3.x'e çıkarmak
00:00  Klasör yapısı API oluyor: Assets.icon.svg.icAircraft
00:00  Kırık 3 SVG'yi generated referansla değiştirmek
00:00  Font: 18 varyantın tamamı pubspec'e, tema FontFamily.roboto'ya
00:00  Karar: easy_localization neden facade arkasına alınıyor (v11 felsefesi)
00:00  ProductLocalization + Locales enum — dil kaydının tek yeri
00:00  translate extension: sayfalar paketi görmüyor
00:00  MaterialApp.router: context.productDelegates / productLocale
00:00  LocaleKeys üretimi: easy_localization CLI, build_runner değil
00:00  saveLocale: false — dili ICacheManager'a biz yazıyoruz
00:00  ApplicationCubit: locale state + changeLocale + app bar butonu
00:00  translateArgs / translateNamed / translatePlural
00:00  Kural 1: sayıyı elle cümleye yapıştırma (çoğul dili ilgilendirir)
00:00  Kural 2: veriyi çeviri dosyasına gömme (test hesabı örneği)
00:00  Kural 3: çeviriyi MaterialApp'in altında oku (onGenerateTitle)
00:00  Log seviyesi: DEBUG gürültüsünü kısmak
00:00  Test: facade'ın üç davranışını sabitlemek
00:00  scripts/generate.sh: tek giriş noktası, --watch/--clean/--localization/--assets
00:00  AI Skills: codegen-setup, asset-add, localization-add-key (+ masterflutter- prefix)
00:00  Command katmanını silmek: aynı bilgi iki dosyada durmasın (10 skill, 0 command)
00:00  Agent'lar: masterflutter-reviewer & masterflutter-refactor-scout
00:00  Plugin'leri repo'ya bağlamak: .claude/settings.json (claude-mem, i-have-adhd)
00:00  setup.sh: araç kontrolü → bağımlılık → codegen → eklenti → doğrulama
00:00  Pilot migrasyon nerede durdu, kalan ekranlar nasıl taşınacak
00:00  Kapanış & sıradaki bölüm (v13 Custom Package & Widget Library)
```

### Opsiyonel bonus bölüm

Skill'lerin Homebrew paketi olarak dağıtımı ve merge sonrası otomatik release
akışı bu branch'te hazır ([docs/skill_distribution.md](../skill_distribution.md)).
Videoyu uzatmak istemiyorsan ayrı bir kısa içerik olarak da durabilir; anlatacaksan
kapanıştan önce ~2 dakika:

```
00:00  Bonus: skill'leri brew install ile dağıtmak, PR merge → otomatik release
```

---

## 🧠 Ne Öğrendik (Ekranda gösterilecek özet)

- String tabanlı erişimi derleyicinin kontrol ettiği API'ye çevirmek
- Klasör yapısını API'ye dönüştürmek (flutter_gen)
- Paketi facade arkasına almak — easy_localization sayfalara sızmıyor
- Dil kalıcılığını pakete değil kendi cache katmanımıza bağlamak
- Çoğul ve parametreyi dilin kurallarına bırakmak
- Codegen'i tek bir çalıştırılabilir giriş noktasına indirmek
- Aynı bilgiyi iki dosyada tutmamak (command + skill): biri mutlaka eskir
- Ortam kurulumunu dokümana değil çalıştırılabilir bir script'e yazmak
- Kuralları agent'a öğretmek: "review" genel tavsiye değil, bu reponun kuralları

---

## 🏷️ Etiketler (Tags / Hashtags)

`#Flutter #Dart #Localization #i18n #flutter_gen #easy_localization #CodeGeneration
#build_runner #CleanArchitecture #FacadePattern #Refactoring #MobileDevelopment
#FlutterTurkiye #AISkills`

---

## 🖼️ Kapak Fotoğrafı (Thumbnail)

**Karar: mevcut şablon aynen kullanılır, yeni kapak üretilmez.**

Seride v6'dan v10'a kadar kapak birebir aynı: koyu lacivert arka plan + mor dalga
deseni, sol üstte `HARDWAREANDRO`, ortada üç satır beyaz **FLUTTER REFACTORING
MASTERCLASS**, sağda dairesel portre, sol altta sarı kutu. Bölümler arasında
**yalnızca sarı kutudaki metin** değişiyor. Bu tanınırlık serinin en güçlü tarafı;
bozmaya değmez.

Sarı kutu metni (v10'daki 4 satır sıkışık duruyordu, bunu 2 satırda tut):

```
12 - ASSET & LOCALIZATION
(CODEGEN + AI SKILLS)
```

Alternatifler:
- `12 - FLUTTER_GEN + EASY_LOCALIZATION` / `(PROMPT & AI SKILLS)`
- `12 - TYPE-SAFE ASSET & ÇEVİRİ` / `(CODEGEN + AI SKILLS)`
- `12 - ASSET, ÇEVİRİ & AI KATMANI` / `(SKILLS + AGENTS)`

Yeni kapak ancak seri genelinde bir yenileme yapılacaksa üretilmeli — o zaman da
tek bölümde değil, playlist'in tamamında değişmeli.

---

## 📋 Yayın Sonrası

1. **README video tablosu.** v11 satırı eklendi (`V8fA71Q-CRE`); sıra v12'de
   (`{V12_ID}` yerine gerçek ID):

```markdown
[![Flutter Refactoring Masterclass: 12- Asset & Localization - flutter_gen + easy_localization](https://img.youtube.com/vi/{V12_ID}/hqdefault.jpg) <br> 12- Asset & Localization - flutter_gen + easy_localization](https://youtu.be/{V12_ID})
```

2. **todo.md.** `v12` satırını "✅ Yayınlanan Bölümler" listesine taşı; "Son
   Güncelleme" → `v12 yayınlandı`, "Sıradaki Bölüm" zaten v13.

3. **Issue #17 ve #18** kapat, açıklamalarına video linkini bırak.

4. **Sabitlenmiş yorum.** Kısa açıklama + `docs/codegen_and_localization.md` linki.
