# Flight Booking App

Flutter ile geliştirilmiş uçak bileti rezervasyon uygulaması. Bu proje refactor videosu için kasıtlı olarak kötü kodlama pratikleri içerir.

## 📺 Video Serisi - Flutter Refactoring Masterclass

|   |   |   |
|---|---|---|
| [![Flutter Refactoring Masterclass: 1- Proje inceleme, analiz ve yapılacaklar](https://img.youtube.com/vi/Lz9TJJPqi1o/hqdefault.jpg) <br> 1- Proje inceleme, analiz ve yapılacaklar](https://youtu.be/Lz9TJJPqi1o) | [![Flutter Refactoring Masterclass: 2 - Pubspec.yaml](https://img.youtube.com/vi/A8RQupxiv5A/hqdefault.jpg) <br> 2- Pubspec.yaml](https://youtu.be/A8RQupxiv5A) | [![Flutter Refactoring Masterclass: 3- Kod Standartları, Linter, Editor ayarları](https://img.youtube.com/vi/fMlJAy3pr0k/hqdefault.jpg) <br> 3- Kod Standartları, Linter, Editor ayarları](https://youtu.be/fMlJAy3pr0k) |
| [![Flutter Refactoring Masterclass: 4- Paket mimarisi ve klasör yapısı](https://img.youtube.com/vi/fSDYS5Lr59g/hqdefault.jpg) <br> 4- Paket mimarisi ve klasör yapısı](https://youtu.be/fSDYS5Lr59g) | [![Flutter Refactoring Masterclass: 5- Proje başlangıç noktası, Environment yönetimi](https://img.youtube.com/vi/JAzdG1_MKWw/hqdefault.jpg) <br> 5- Proje başlangıç noktası, Environment yönetimi](https://youtu.be/JAzdG1_MKWw) | [![Flutter Refactoring Masterclass: 6- Theme & Design System (prompt + Skill)](https://img.youtube.com/vi/2-Q91EDSiTg/hqdefault.jpg) <br> 6- Theme & Design System (prompt + Skill)](https://youtu.be/2-Q91EDSiTg) |
| [![Flutter Refactoring Masterclass: 7.1- View-ViewModel-Mixin Architecture (Prompt + Skill)](https://img.youtube.com/vi/Uyp0rWupYJc/hqdefault.jpg) <br> 7.1- View-ViewModel-Mixin Architecture (Prompt + Skill)](https://youtu.be/Uyp0rWupYJc) | [![Flutter Refactoring Masterclass: 8- Network & Service Layer Mimarisi (Prompt + Skill)](https://img.youtube.com/vi/YvZtk_6mV2s/hqdefault.jpg) <br> 8- Network & Service Layer Mimarisi (Prompt + Skill)](https://youtu.be/YvZtk_6mV2s) | [![Flutter Refactoring Masterclass: 9- State Management - V.Notifier Cubit (Prompt & AI Skills)](https://img.youtube.com/vi/P5hpxaFRJNw/hqdefault.jpg) <br> 9- State Management - V.Notifier Cubit (Prompt & AI Skills)](https://youtu.be/P5hpxaFRJNw) |
| [![Flutter Refactoring Masterclass: 10- Navigation - go_router + AuthCubit (Typed Routes & AI Skills)](https://img.youtube.com/vi/kaqIas6nXZc/hqdefault.jpg) <br> 10- Navigation - go_router + AuthCubit (Typed Routes & AI Skills)](https://youtu.be/kaqIas6nXZc) | [![Flutter Refactoring Masterclass: 11- Cache Manager - hive_ce + Strategy Pattern + Fallback (Prompt & AI Skills)](https://img.youtube.com/vi/V8fA71Q-CRE/hqdefault.jpg) <br> 11- Cache Manager - hive_ce + Strategy Pattern + Fallback (Prompt & AI Skills)](https://youtu.be/V8fA71Q-CRE) | |

> 🎬 [Tüm Playlist'i İzle](https://www.youtube.com/playlist?list=PL1k5oWAuBhgUh7_hMrTDxZHsGOPGSP9La)

## 🤖 AI Katmanı (Claude Code)

Repo, her bölümde kurulan mimariyi tekrar uygulayabilen yetenekleri kendi içinde taşır:

| | |
|---|---|
| **11 skill** (`.claude/skills/masterflutter-*`) | `/masterflutter-` yazıp listeye bak — cache, route, cubit, codegen, localization, asset, network, view refactor, ortam kurulumu |
| **2 agent** (`.claude/agents/`) | `masterflutter-reviewer` — diff'i bu reponun kurallarına göre denetler · `masterflutter-refactor-scout` — bir sayfada ne kaldığını, hangi sırayla yapılacağını raporlar |
| **Plugin'ler** (`.claude/settings.json`) | `claude-mem`, `i-have-adhd` — repo ile birlikte gelir, `./scripts/setup.sh` kurar |

## 🚀 Hızlı Başlangıç

### 0. Ortamı Kur (tek komut)

```bash
./scripts/setup.sh          # bağımlılıklar + kod üretimi + editör eklentileri + AI plugin'leri
./scripts/setup.sh --check  # sadece neyin eksik olduğunu söyler, hiçbir şey kurmaz
```

Neyin neden gerektiği: [.claude/skills/masterflutter-env-setup/SKILL.md](.claude/skills/masterflutter-env-setup/SKILL.md)
(ya da Claude Code içinde `/masterflutter-env-setup`).

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

### 3. Kod Üretimi (Code Generation)

Tüm generator'lar tek bir giriş noktasından çalışır:

```bash
./scripts/generate.sh            # LocaleKeys + Assets/Fonts + model & route kodu
./scripts/generate.sh --watch    # değişiklikte otomatik üret
./scripts/generate.sh --localization     # sadece çeviri anahtarları (en hızlı döngü)
./scripts/generate.sh --assets   # sadece asset/font + model + route
./scripts/generate.sh --clean    # üretilmiş çıktıyı temizleyip yeniden üret
```

| Üretilen | Dosya | Üreten |
|----------|-------|--------|
| Asset erişimi | `lib/product/gen/assets.gen.dart` | flutter_gen |
| Font ailesi | `lib/product/gen/fonts.gen.dart` | flutter_gen |
| Çeviri anahtarları | `lib/product/gen/locale_keys.g.dart` | easy_localization CLI |
| Model JSON | `**/*_model.g.dart` | json_serializable |
| Typed route | `lib/product/navigation/app_routes.g.dart` | go_router_builder |

> Asset ve metinlere **asla** string ile erişilmez: `Assets.icon.svg.icAircraft`,
> `LocaleKeys.login_submit.translate`. Detay: [docs/codegen_and_localization.md](docs/codegen_and_localization.md)

## 🍺 Skill Paketi (Homebrew)

Bu repodaki `masterflutter-*` Claude Code skill'leri Homebrew ile kurulur.

```bash
# Kurulum — makine başına bir kez
brew trust --tap vb10/masterflutter
brew trust --formula vb10/masterflutter/masterflutter-skill
brew tap vb10/masterflutter https://github.com/VB10/flight_booking.git
brew install vb10/masterflutter/masterflutter-skill

# Etkinleştirme
masterflutter-skill init                              # her projede geçerli
cd <flutter-projesi> && masterflutter-skill project   # + proje kopyası

# Güncelleme
brew upgrade masterflutter-skill && masterflutter-skill init
```

Ardından Claude Code'u yeniden başlat — skill'ler `/masterflutter-cache-setup`,
`/masterflutter-route-add` gibi çağrılır. Durumu `masterflutter-skill status` gösterir.

> Paket içeriği, tüm komutlar ve merge sonrası otomatik release akışı:
> [docs/skill_distribution.md](docs/skill_distribution.md)

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


┌─────────────────────────────────────────────────────────┐
│  ProductContainer (Global DI — get_it)                  │
│  main.dart'ta setup() → IAuthService, INetworkManager…  │
└──────────────┬──────────────────────────────────────────┘
               │ .get<IService>()
               ▼
┌─────────────────────────────────────────────────────────┐
│  BlocProvider(create: (_) => Cubit(services...))        │
│  ┌────────────────────────────────────────────────────┐ │
│  │  Cubit + State (Equatable + copyWith)              │ │
│  │  state.copyWith(isLoading, errorMessage, isSuccess)│ │
│  └──────────┬─────────────────────┬───────────────────┘ │
│             │ emit                │ emit                 │
│             ▼                     ▼                      │
│  ┌──────────────────┐  ┌──────────────────────┐         │
│  │  BlocBuilder     │  │  BlocListener        │         │
│  │  isLoading→Spin  │  │  isSuccess→Navigate  │         │
│  │  error→Text      │  │  SnackBar, yan etki  │         │
│  └──────────────────┘  └──────────────────────┘         │
│                                                          │
│  ┌────────────────────────────────────────────────────┐ │
│  │  PageMixin (controller + ValueNotifier lifecycle)  │ │
│  │  context.read<Cubit>() ile erişim                  │ │
│  └──────────┬─────────────────────────────────────────┘ │
│             │ ValueNotifier                              │
│             ▼                                            │
│  ┌──────────────────────────────────────────────────┐   │
│  │  ValueListenableBuilder (setState YOK)           │   │
│  │  • obscurePassword → şifre göster/gizle          │   │
│  │  • testAccountExpanded → panel aç/kapa            │   │
│  │  • selectedChip, tabIndex → küçük UI toggle       │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘