# Notlar

> Geliştiricinin yapacakları / kontrol edecekleri. `vb-create-notes` ile eklenir, `vb-show-notes` ile gösterilir (script: `~/.claude/scripts/vb-notes.py`). Açık: `- [ ]`, bitti: `- [x]`. Elle düzenlenebilir, satır biçimini koru.

- [ ] #1 · 2026-11-06 · sonra · Booking history ekranını tasarla ve bağla
  - Tasarımda çizilmedi; Profile'daki satır ve onay ekranındaki 'View Bookings' bunu bekliyor
  - Backend'e bookings[] endpoint'i, modele NEW DATA; sonra /masterflutter-design-screen
- [ ] #2 · 2026-11-06 · sonra · Update butonunun mağazayı açmasını ekle
  - Store URL + url_launcher gerekli; şimdilik forced update dialog'u tekrar açılıyor (splash_page_mixin.dart)
- [ ] #3 · 2026-11-06 · sonra · Backend'den gelen görünen metinleri TR'ye çevir
  - seatClass, duration, membershipLevel, şehir adları TR arayüzde İngilizce
  - Öneri: enum + LocaleKeys; süre dakika olarak gelsin, ProductFormat formatlasın
- [ ] #4 · 2026-11-06 · sonra · Güncelleme mesajını dile göre seç
  - Remote Config update_message_tr her dilde gösteriliyor (app_update_service_impl.dart)
- [ ] #5 · 2026-11-06 · sonra · Checkout retry için idempotency anahtarı ekle
  - Ağ hatasında sunucu siparişi işlemişse 'Tekrar dene' ikinci sipariş açar (backend her çağrıda yeni orderId)
- [ ] #6 · 2026-11-06 · karar · TR çevirilerde hitabı tek tipe çek (sen/siz)
  - login + profile 'sen', flight + cart 'siz' kullanıyor; hangisi olacağına karar ver
- [ ] #7 · 2026-11-06 · sonra · Login doğrulama mesajlarını widget'ta çevir
  - login_cubit.dart çeviriyi state'e yazıyor; dil değişince eski dilde kalıyor → state'te key/enum tut
