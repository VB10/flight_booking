# Flight Booking App

Flutter ile geliştirilmiş uçak bileti rezervasyon uygulaması. Bu proje refactor videosu için kasıtlı olarak kötü kodlama pratikleri içerir.

## 🚀 Hızlı Başlangıç

### 1. Backend Server'ı Başlat

**Ana Flutter projesi içinden:**

```bash
# macOS/Linux
./start_backend.sh

# Farklı port ile
./start_backend.sh 9000
```

### 2. Flutter Uygulamasını Çalıştır

```bash
flutter pub get
flutter run
```

## 📱 Uygulama Özellikleri

- 🌟 **Splash Sayfası** - Cache kontrolü ile otomatik yönlendirme
- 🔐 **Login Sayfası** - API entegrasyonu ile kullanıcı girişi
- ✈️ **Uçak Biletleri** - API'den gelen biletleri listele
- 📋 **Bilet Detayları** - Seçilen biletin detay bilgileri
- 🛒 **Sepet Yönetimi** - Bilet ekleme ve checkout
- 👤 **Profil Sayfası** - Kullanıcı bilgileri ve çıkış
- 💾 **Cache Yönetimi** - SharedPreferences ile oturum yönetimi

## 🔧 Test Bilgileri

**Giriş Bilgileri:**
- Email: `user@test.com`
- Password: `123456`

## 📡 Backend API Endpoints

Backend varsayılan olarak `http://localhost:8080` adresinde çalışır:

| Method | Endpoint | Açıklama |
|--------|----------|----------|
| POST | `/login` | Kullanıcı girişi |
| GET | `/flights` | Uçak biletleri listesi |
| POST | `/checkout` | Sepet onaylama |
| GET | `/profile` | Kullanıcı profili |
| GET | `/health` | Server durumu |

## 📂 Proje Yapısı

```
flight_booking/
├── lib/
│   ├── main.dart              # Ana uygulama
│   ├── splash_page.dart       # Splash sayfası
│   ├── login_page.dart        # Giriş sayfası
│   ├── flight_list_page.dart  # Uçak listesi
│   ├── flight_detail_page.dart# Bilet detayları
│   ├── cart_page.dart         # Sepet sayfası
│   ├── profile_page.dart      # Profil sayfası
│   └── *_response_model.dart  # Response modelleri
├── backend/
│   ├── bin/server.dart        # Dart backend server
│   ├── pubspec.yaml           # Backend dependencies
│   └── test_endpoints.dart    # API test dosyası
└── start_backend.sh           # Backend başlatma scripti
```

## ⚠️ Refactor İçin Kasıtlı "Kötü" Pratikler

**Flutter Tarafında:**
- ❌ Her sayfada API kodlarının tekrarı
- ❌ Hard coded URL'ler ve string'ler  
- ❌ Cache logic sayfaların içinde gömülü
- ❌ Response model kullanım karışıklığı
- ❌ Error handling kod tekrarları
- ❌ Context kullanım hataları
- ❌ StatefulWidget gereksiz kullanımı
- ❌ setState() her yerde

**Backend Tarafında:**
- ❌ Hard coded veriler ve kullanıcılar
- ❌ Authentication/güvenlik kontrolsüz
- ❌ Global değişkenler
- ❌ In-memory data storage
- ❌ Error handling eksikliği

## 🎯 Geliştirilmesi Gerekenler (Refactor Hedefleri)

1. **API Service Layer** oluşturmak
2. **Cache Manager** sınıfı yapmak
3. **State Management** (Provider/Bloc) eklemek
4. **Model sınıfları** düzenlemek
5. **Error Handling** sistemi kurmak
6. **Constants** dosyaları oluşturmak
7. **Dependency Injection** eklemek
8. **Authentication Service** yapmak

## 📋 Gereksinimler

- Flutter SDK 3.8.1+
- Dart SDK 2.17.0+
- Android Studio / VS Code
- iOS Simulator / Android Emulator

## 🔍 Test Senaryoları

1. Uygulamayı başlat → Splash görünür
2. Login ol (user@test.com / 123456)
3. Uçak biletlerini görüntüle
4. Bilet detaylarına bak
5. Sepete bilet ekle
6. Checkout yap
7. Profile git ve çıkış yap

## 📝 Notlar

- Bu proje eğitim amaçlı hazırlanmıştır
- Production'da kullanılmamalıdır
- Refactor videosu için tasarlanmıştır
- Güvenlik kontrolü yapılmamıştır
