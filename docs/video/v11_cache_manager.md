# 🎬 v11 — Cache Manager (Video İçeriği)

> Flutter Refactoring Masterclass serisinin 11. bölümü için hazır video metni:
> başlık, açıklama, bölümler ve yayın sonrası README satırı.

---

## 📌 Başlık (Title)

**Flutter Refactoring Masterclass: 11- Cache Manager — hive_ce + Strategy Pattern + Fallback (Prompt & AI Skills)**

Alternatifler:
- `11- Cache Manager: Hive'ı Package'a Gömdük, Ana Proje Storage'ı Bilmiyor (Strategy + DTO)`
- `11- Flutter Cache Mimarisi: hive_ce + Strategy Pattern + SharedPreferences Fallback`

---

## 📝 Kısa Açıklama (Pinned / Özet)

Bu bölümde dağınık `SharedPreferences` kullanımını tek bir soyutlamanın arkasına
alıyoruz. `hive_ce` tabanlı, **model-capable** bir cache kuruyoruz — ama Hive'ı
ayrı bir local package'a **gömüyoruz**, öyle ki ana proje storage backend'inin ne
olduğunu bilmiyor. Strategy Pattern + DTO (CacheModel/JSON) + strategy dışında
bağımsız bir fallback store ile "istediğimiz an backend'i değiştirebiliriz"
noktasına geliyoruz. Bonus: iki AI Skill + model üretim scripti.

---

## 📄 Uzun Açıklama (YouTube Description)

Refactoring Masterclass serimizin bu bölümünde uygulamanın hafızasını kuruyoruz:
Cache mimarisi. Dağınık, hard-coded `SharedPreferences` çağrılarını bir kenara
bırakıp; soyutlanmış, backend'i istediğimiz an değiştirebildiğimiz ve tamamen test
edilebilir bir persistence katmanı inşa ediyoruz.

hive_ce, Strategy Pattern, DTO/JSON contract ve bağımsız Fallback store dörtlüsüyle
"Ana proje storage backend'ini bilmiyor" felsefesini projemize entegre ediyor;
büyük ölçekli Flutter projelerinin olmazsa olmazı olan profesyonel cache katmanını
en ince detayına kadar inşa ediyoruz.

🛠 Bu Bölümde Neler İnşa Ettik?

Strategy Pattern (ICacheStrategy): Backend'e bağımlı, dağınık cache çağrılarını
tarihe gömdük. `ICacheStrategy` + `HiveCacheStrategy` ile storage backend'ini
soyutladık; yeni bir backend = yeni bir strategy, ana projede sıfır kırılma.

Gömülü Hive (Local Package): Hive'ı `module/cache_manager` local package'ına
gömdük. Ana proje tek bir `package:hive` bile import etmiyor; `initFlutter` dahil
her şey package'ın `init()` metodunun içinde kapsüllenmiş durumda.

DTO Pattern + CacheModel Contract: Cache modellerini saf Dart'a çevirdik
(Equatable + immutable + json_serializable). `CacheModel` contract'ı `toJson`'ı
zorluyor, `readModel` `fromJson` alıyor; böylece Hive adapter'ı, typeId derdi yok.
Domain/State (AuthState) storage'dan tamamen bağımsız.

IFallbackStore ile Güvenlik Ağı: Strategy'nin dışında, bağımsız bir
`IFallbackStore` (SharedPreferences) kurduk. Sadece auth token gibi kritik key'leri
tutuyor; Hive çökse ya da temizlense bile oturum kaybolmuyor.

AuthCubit Refactor: Dağınık 4 ayrı key'i tek bir `AuthSessionCacheModel` DTO'suna
+ token yedeğine indirdik. `restoreSession` artık önce cache'ten, o yoksa
fallback'ten okuyor. Hiçbir ekranda manuel key yönetimi yok.

AI-Native Geliştirme: `/cache-setup` ve `/cache-add-model` komutlarım ile bu tüm
altyapıyı ve yeni modelleri saniyeler içinde otomatik kurabilirsiniz. Bir de
`generate_models.sh` scriptiyle model üretimini tek komuta indirdik.

🧩 İzleyeceğiniz Teknik Detaylar:

Local Package: `module/cache_manager` neden ayrı bir package, path dependency nasıl
çalışıyor?

ICacheManager: primitive get/set + `writeModel`/`readModel` API'sinin tasarımı.

CacheModel: `toJson` contract'ı ve `fromJson` factory ile adapter'sız model saklama.

IFallbackStore: Fallback'i neden strategy pipeline'ının dışında, bağımsız tuttuk?

ProductCache (get_it): Cache'in DI'a kaydı, `AppInitializer` bootstrap sırası.

Login/Logout Refactor: Merkezi cache + DTO ile dağınık storage mantığının temizlenmesi.

Test: Mock kütüphanesi olmadan `FakeCacheStrategy`, Hive tempDir ve fallback testi.

⏱ Bölümler:

00:00 - Giriş & Bu bölümde ne yapacağız?
01:30 - Problem: dağınık SharedPreferences & hard-coded key'ler
03:15 - Tasarım kararı: neden iki ayrı store (separation of concerns)?
04:45 - Strategy Pattern: ICacheStrategy + HiveCacheStrategy
06:30 - Local package: Hive'ı module/cache_manager'a gömmek
08:15 - CacheModel contract & DTO: writeModel/readModel + fromJson
10:30 - IFallbackStore: strategy dışında bağımsız güvenlik ağı
12:15 - Entegrasyon: ProductCache, DI kaydı & bootstrap sırası
14:00 - AuthCubit refactor: 4 key → 1 DTO + token yedeği
15:45 - Test: FakeCacheStrategy, Hive tempDir & fallback testi
17:00 - /cache-setup & /cache-add-model AI Skill demosu
18:30 - Özet & bir sonraki bölüm: ne geliyor?

📂 Proje Linkleri ve Kaynaklar:
Videoda bahsettiğim tüm mimari dökümanlara, Mermaid diyagramlarına ve AI promptlarına
GitHub reposu üzerinden ulaşabilirsiniz.
🔗 Kaynak kod: https://github.com/VB10/flight_booking
🔗 Issue #14: https://github.com/VB10/flight_booking/issues/14
🔗 Mimari doküman: docs/cache_architecture.md
🔗 Tüm Playlist: https://www.youtube.com/playlist?list=PL1k5oWAuBhgUh7_hMrTDxZHsGOPGSP9La

Umarım bu yapı projelerinizde hem güvenli hem de ölçeklenebilir bir cache temeli
oluşturur. Sorularınızı yorumlarda bekliyorum!

Kendinize çok iyi bakın, bir sonraki içerikte görüşmek üzere!

#flutter #hive #cache #flutterbloc #cubit #refactoring #dart #cleanarchitecture #strategypattern #softwarearchitecture #flutterdev

---

## ⏱️ Bölümler (Chapters / Timestamps)

> Süreleri kayıt sonrası doldur; sıra ve içerik hazır.

```
00:00  Giriş — bu bölümde ne yapacağız
00:00  Problem: dağınık SharedPreferences (AuthCubit + ProfilePage), hard-coded key'ler
00:00  Tasarım kararı: neden iki ayrı store (separation of concerns)
00:00  Strategy Pattern: ICacheStrategy + HiveCacheStrategy
00:00  Local package: module/cache_manager neden ayrı, path dependency
00:00  Hive'ı package'a gömmek: app'te sıfır hive import (init() içinde initFlutter)
00:00  CacheModel contract: writeModel toJson'ı zorlar, readModel fromJson alır (neden?)
00:00  DTO pattern: AuthSessionCacheModel (Equatable + immutable + json_serializable)
00:00  Fallback store: IFallbackStore neden strategy'nin dışında
00:00  Entegrasyon: ProductCache, DI kaydı, AppInitializer bootstrap sırası
00:00  AuthCubit refactor: 4 key → 1 DTO + token yedeği, restoreSession fallback
00:00  Test: mock'suz FakeCacheStrategy, Hive tempDir, fallback testi
00:00  AI Skills: /cache-setup + /cache-add-model + generate_models.sh
00:00  "Backend'i istediğimiz an değiştirebiliriz" — tek satırlık swap
00:00  Kapanış & sıradaki bölüm (v12)
```

---

## 🧠 Ne Öğrendik (Ekranda gösterilecek özet)

- Strategy Pattern ile cache backend'ini soyutlamak
- Local package ile bağımlılığı gizlemek (Hive app'e sızmıyor)
- DTO + JSON contract ile domain'i storage'dan ayırmak
- Fallback'i ana pipeline'ın dışında bağımsız tutmak
- Mock kütüphanesi olmadan hand-rolled fake ile test
- AI Skill'lerle mimariyi tekrar üretilebilir kılmak

---

## 🏷️ Etiketler (Tags / Hashtags)

`#Flutter #Dart #Hive #hive_ce #CleanArchitecture #StrategyPattern #Cache
#SharedPreferences #Refactoring #MobileDevelopment #FlutterTurkiye #get_it #DTO`

---

## 📋 Yayın Sonrası — README'ye Eklenecek Satır

Video yayınlanınca `README.md` içindeki video tablosuna (`{VIDEO_ID}` yerine
gerçek YouTube ID) şu hücreyi ekle:

```markdown
[![Flutter Refactoring Masterclass: 11- Cache Manager - hive_ce + Strategy Pattern + Fallback](https://img.youtube.com/vi/{VIDEO_ID}/hqdefault.jpg) <br> 11- Cache Manager - hive_ce + Strategy Pattern + Fallback](https://youtu.be/{VIDEO_ID})
```

Ayrıca `todo.md`'de v11 zaten işaretli; "Son Güncelleme" satırını v11 olarak güncelle.
