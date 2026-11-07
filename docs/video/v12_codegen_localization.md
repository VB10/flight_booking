# 🎬 v12 — Code Generation & Localization (Video İçeriği)

> Flutter Refactoring Masterclass serisinin 12. bölümü için hazır video metni:
> başlık, açıklama, bölümler, kapak fotoğrafı notu ve yayın sonrası README satırı.

---

## 📌 Başlık (Title)

**Flutter Refactoring Masterclass: 12- Asset & Localization (flutter_gen + easy_localization)**

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

> Video süresi 14:58. Düz metin (YouTube markdown göstermez), 5000 karakter sınırının altında.
> Olduğu gibi kopyala-yapıştır.

```
Refactoring Masterclass serimizin bu bölümünde projedeki en sinsi hata kaynağını temizliyoruz: string'ler. Bir asset yolunu yanlış yazarsanız derleyici susar, ekran boş gelir; UI metinleri koda gömülüyse uygulamanız asla ikinci bir dile açılamaz.

flutter_gen, easy_localization, facade pattern ve tek bir codegen giriş noktasıyla; asset'i de metni de derleme zamanında garanti altına alınmış, çok dilli ve tekrar üretilebilir bir yapıya taşıyoruz.

🛠 Bu Bölümde Neler İnşa Ettik?

✅ Type-Safe Asset & Font (flutter_gen): SvgPicture.asset('assets/...') çağrıları tarihe karıştı. Klasör yapısı doğrudan API oluyor: Assets.icon.svg.icAircraft. Bu sayede projede sessizce kırık olan 3 SVG'yi yakaladık. 18 Roboto varyantının tamamı pubspec'te, tema artık FontFamily.roboto kullanıyor.

✅ Facade Arkasında easy_localization: v11'de Hive'ı nasıl gizlediysek burada da aynısını yapıyoruz. Paket sadece lib/product/localization/ içinde import ediliyor; sayfalar yalnızca LocaleKeys.login_submit.translate görüyor.

✅ Dil Kalıcılığı Bizim Elimizde: saveLocale: false. Seçilen dil v11'deki ICacheManager ile saklanıyor, açılışta geri yükleniyor. Tek bir source of truth.

✅ Parametre & Çoğul: translateArgs, translateNamed, translatePlural ve üç kural: sayıyı cümleye elle yapıştırma, veriyi çeviri dosyasına gömme, çeviriyi MaterialApp'in altında oku (onGenerateTitle). Hepsi testle sabitlendi.

✅ Tek Codegen Girişi: İki script yerine tek ./scripts/generate.sh; --watch, --clean, --localization, --assets flag'leriyle.

✅ Bağımlılık Çatışması: flutter_gen eklerken archive v3/v4 çatışmasını canlı okuyup lottie'yi 3.x'e çıkarıyoruz.

✅ AI Katmanı: /masterflutter-codegen-setup, /masterflutter-asset-add, /masterflutter-localization-add-key skill'leri. Command katmanını sildik (10 skill, 0 command). İki agent: masterflutter-reviewer (diff'i bu reponun kurallarına göre denetler) ve masterflutter-refactor-scout (bir sayfada ne kaldığını sırayla raporlar).

✅ Tek Komutla Ortam: ./scripts/setup.sh — araç kontrolü, bağımlılıklar, codegen, VS Code eklentileri ve Claude Code plugin'leri.

⏱ Bölümler:
00:00 Giriş & bu bölümde ne yapacağız?
00:45 Problem: kırık asset'ler, koda gömülü metinler, dağınık codegen
01:50 flutter_gen kurulumu & archive/lottie bağımlılık çatışması
03:00 Assets.* ile kırık SVG'leri yakalamak & FontFamily.roboto
04:10 easy_localization neden facade arkasına alınıyor?
05:00 ProductLocalization + Locales enum + translate extension
06:10 LocaleKeys üretimi: neden build_runner değil?
06:50 Dil kalıcılığı: saveLocale false + ICacheManager + ApplicationCubit
08:00 Parametre & çoğul + üç kural
09:15 Test: facade davranışını sabitlemek
09:50 scripts/generate.sh: tek giriş, dört flag
10:35 AI Skills: codegen-setup, asset-add, localization-add-key
11:30 Command katmanını silmek: 10 skill, 0 command
12:15 Agent'lar: reviewer & refactor-scout
13:10 setup.sh: klonla, tek komutla çalıştır
14:10 Özet & sıradaki bölüm: v13 Custom Package & Widget Library

📂 Kaynaklar:
🔗 Kaynak kod: https://github.com/VB10/flight_booking
🔗 Issue #17 (asset + localization + codegen): https://github.com/VB10/flight_booking/issues/17
🔗 Issue #18 (AI katmanı): https://github.com/VB10/flight_booking/issues/18
🔗 Mimari doküman: https://github.com/VB10/flight_booking/blob/main/docs/codegen_and_localization.md
🔗 Tüm Playlist: https://www.youtube.com/playlist?list=PL1k5oWAuBhgUh7_hMrTDxZHsGOPGSP9La

Projenizde hâlâ Text('Sepete Ekle') yazan bir satır varsa bu bölüm tam size göre. Sorularınızı yorumlarda bekliyorum!

Kendinize çok iyi bakın, bir sonraki içerikte görüşmek üzere!

#flutter #localization #fluttergen #easylocalization #codegen #dart #refactoring #flutterdev
```

---

## ⏱️ Bölümler (Chapters / Timestamps)

> 14:58 süreye göre dağıtıldı. Kurgudaki gerçek geçişlere göre ±10 sn kaydırman gerekebilir;
> YouTube için ilk satır 00:00 olmalı ve her bölüm en az 10 sn sürmeli.

```
00:00 Giriş & bu bölümde ne yapacağız?
00:45 Problem: kırık asset'ler, koda gömülü metinler, dağınık codegen
01:50 flutter_gen kurulumu & archive/lottie bağımlılık çatışması
03:00 Assets.* ile kırık SVG'leri yakalamak & FontFamily.roboto
04:10 easy_localization neden facade arkasına alınıyor?
05:00 ProductLocalization + Locales enum + translate extension
06:10 LocaleKeys üretimi: neden build_runner değil?
06:50 Dil kalıcılığı: saveLocale false + ICacheManager + ApplicationCubit
08:00 Parametre & çoğul + üç kural
09:15 Test: facade davranışını sabitlemek
09:50 scripts/generate.sh: tek giriş, dört flag
10:35 AI Skills: codegen-setup, asset-add, localization-add-key
11:30 Command katmanını silmek: 10 skill, 0 command
12:15 Agent'lar: reviewer & refactor-scout
13:10 setup.sh: klonla, tek komutla çalıştır
14:10 Özet & sıradaki bölüm: v13 Custom Package & Widget Library
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
