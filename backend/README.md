# Flight Booking Server

Flutter uçak rezervasyon uygulaması için basit Dart backend serveri.

## Hızlı Başlangıç

### Otomatik Başlatma (Önerilen)

**macOS/Linux:**
```bash
./start_server.sh
```

**Windows:**
```bash
start_server.bat
```

**Farklı port ile çalıştırma:**
```bash
./start_server.sh 9000    # macOS/Linux
start_server.bat 9000     # Windows
```

### Manuel Başlatma

```bash
cd flight_booking_server
dart pub get
dart run bin/server.dart
```

## API Endpoints

Server varsayılan olarak `http://localhost:8080` adresinde çalışır.

| Method | Endpoint | Açıklama |
|--------|----------|----------|
| POST | `/login` | Kullanıcı girişi |
| GET | `/flights` | Uçak biletleri listesi |
| POST | `/checkout` | Sepet onaylama. `Idempotency-Key` header'ı ile aynı key tekrar gelirse ilk sipariş döner (`Idempotent-Replayed: true`) |
| GET | `/debug` | Demo paneli (v14): canlı sipariş listesi, son istekler, Idempotency ON/OFF ve "sonraki ödemeyi düşür" düğmeleri |
| GET | `/debug/state` | Panelin okuduğu JSON (siparişler, `duplicate` işareti, son 20 istek, anahtar durumları) |
| POST | `/debug/drop-next` | Demo: bir sonraki checkout siparişi kaydeder ama 503 döner |
| POST | `/debug/idempotency` | `{"enabled": false}` ile sunucu key'i yok sayar (çift sipariş demosu) |
| POST | `/debug/reset` | Siparişleri, key'leri ve istek kaydını temizler (anahtar durumu korunur) |
| GET | `/profile` | Kullanıcı profili (fake) |
| GET | `/health` | Server durum kontrolü |

## Test Bilgileri

**Giriş Bilgileri:**
- Email: `user@test.com`
- Password: `123456`

## Örnek Kullanım

```bash
# Health check
curl http://localhost:8080/health

# Login
curl -X POST http://localhost:8080/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@test.com","password":"123456"}'

# Flights listesi
curl http://localhost:8080/flights

# Profile
curl http://localhost:8080/profile
```

## Geliştirme Notları

⚠️ **Bu server refactor videosu için kasıtlı olarak kötü pratikler içerir:**

- Hard coded veriler
- Authentication yok
- Global değişkenler
- Güvenlik kontrolü yok
- In-memory data storage

Gerçek projelerde kullanılmamalıdır!