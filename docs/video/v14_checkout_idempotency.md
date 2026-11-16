# 🎬 v14 — Checkout Retry & Idempotency Key (Video İçeriği)

> Flutter Refactoring Masterclass serisinin 14. bölümü için taslak: başlık, özet, anlatım akışı ve
> bilinen sınırlamalar. Issue: [#21](https://github.com/VB10/flight_booking/issues/21)

---

## 📌 Başlık (Title)

**Flutter Refactoring Masterclass: 14- Çift Ödemeyi Önle: Idempotency Key ile Güvenli Checkout Retry**

---

## 📝 Kısa Açıklama

Ağ koptuğunda sunucu siparişi oluşturmuş ama uygulama hata görmüş olabilir. Kullanıcı "Tekrar dene"ye
basınca **ikinci bir sipariş** oluşur. Bu bölümde sorunu önce **kırmızı bir testle** gösteriyoruz, sonra
`Idempotency-Key` ile çözüyoruz: aynı ödeme niyeti kaç kez denenirse denensin tek sipariş.

---

## 🧭 Anlatım Akışı

1. **Sorunu göster (demo paneli).** Ekranı ikiye böl: solda simülatör, sağda
   `http://localhost:8080/debug`. Panelde Idempotency **OFF**, "Drop next payment"e bas, uygulamada öde:
   uygulama hata gösterir, panelde 1 sipariş durur. "Tekrar dene"ye bas: panelde ikinci sipariş
   **DOUBLE BOOKING** etiketiyle çıkar. Aynı uygulama, aynı kod; sadece sunucudaki anahtar kapalı.
   Aynı şey `backend/test/checkout_idempotency_test.dart` içinde de test olarak duruyor.
   **Çözümü göster:** Reset, Idempotency **ON**, aynı senaryo: retry sonrası sipariş sayısı 1 kalır,
   "Recent requests" satırında ♻ replayed görünür.
2. **Key kimin?** Sayfa cubit'inin değil, sepetin. `CheckoutCubit` sayfa ömürlüdür: kullanıcı hatadan sonra
   geri çıkıp sepeti yeniden açarsa yeni cubit = yeni key = yine çift sipariş. Bu yüzden key
   `CartCubit.ensureCheckoutKey()` içinde, sepet içeriğine bağlı yaşar; `add`, `removeAt`, `restore`,
   `clear` (yani her sepet değişimi) key'i sıfırlar.
3. **Neden `CartState` içinde değil?** `CartState` Equatable. Lazy set edilen key, "aynı state" diye
   emit edilmez ve düşer. Rozet ve liste de key için yeniden çizilmemeli. Private alan yeterli.
4. **Key üretimi.** `Random.secure()` ile 128-bit hex. `uuid` paketi gerekmiyor.
5. **Header'ı taşı.** `IProductNetworkManager.sendRequest` artık istek başına `headers` alıyor
   (`Options(headers:)`). `addBaseHeader` ile eklemek singleton üzerinde diğer isteklerle yarışırdı.
   `IFlightService.checkout` zorunlu `idempotencyKey` alır ve `Idempotency-Key` olarak gönderir.
6. **Sunucu tarafı.** `key → order` eşlemesi `orders.add` ile aynı anda yazılır (1 sn'lik gecikmeden önce).
   Aynı key tekrar gelirse `200` + `Idempotent-Replayed: true` ve ilk `bookingReference` döner. Sadece
   commit edilmiş siparişler saklanır; hata cevapları saklanmaz. Böylece "ilk istek hâlâ sürerken gelen
   ikinci istek" için ayrıca 409 dalına gerek kalmaz.
7. **İstemci replay'i ayırt etmez.** Başarı başarıdır: sepet temizlenir, onay ekranı ilk referansı gösterir.
   `clear()` yalnızca onaylı başarıdan sonra çağrılır.

---

## 🧪 Testler

| Katman | Dosya | Ne doğruluyor |
|---|---|---|
| Cubit | `test/feature/auth/cart/cart_checkout_cubit_test.dart` | Hata → retry aynı key; sayfa yeniden açılınca (yeni cubit) aynı key; başarı veya sepet değişiminde yeni key |
| Cubit | `test/product/application/cart_cubit_test.dart` | Key sepet değişene kadar sabit; her mutasyonda sıfırlanır |
| Servis | `test/product/service/flight_service_idempotency_test.dart` | Header sunucuya gerçekten gidiyor (sahte network manager, sunucu gerekmez) |
| Backend | `backend/test/checkout_idempotency_test.dart` | Key'siz retry = 2 sipariş (hata), key'li retry = 1 sipariş + aynı referans |

Backend testi: `cd backend && dart test`.

---

## ⚠️ Bilinen Sınırlamalar (videoda söyle)

- Key **bellekte** yaşar. Sepet de bellekte olduğu için uygulama yeniden başlarsa tekrar edilecek bir sepet
  yok, çift sipariş riski de yok. Sipariş durumunu sonradan sorgulama (reconcile) ayrı bir konu.
- Key için TTL yok. Gerçek serviste süreli saklanır.
- Aynı key + farklı gövde için sunucu `422` döndürmeli. Uygulama key'i sepete bağladığı için bu durum
  uygulamadan oluşamaz, o yüzden uygulanmadı (tek cümleyle anlat).
- **Otomatik retry / backoff bu bölümde yok.** Key sayesinde artık *güvenli*; bir sonraki bölümün konusu.

---

## ✅ Yayın Sonrası

- README "Sıradaki bölüm" satırını güncelle.
