@echo off
echo 🚀 Flight Booking Server'ı başlatılıyor...
echo 📁 Dizin: %cd%

REM Port kontrolü
if "%1"=="" (
    set PORT=8080
) else (
    set PORT=%1
)
echo 🌐 Port: %PORT%

REM Dependency kontrolü
if not exist "bin" (
    echo ❌ Hata: bin klasörü bulunamadı! Doğru dizinde olduğunuzdan emin olun.
    pause
    exit /b 1
)

if not exist "pubspec.yaml" (
    echo ❌ Hata: pubspec.yaml dosyası bulunamadı!
    pause
    exit /b 1
)

echo 📦 Dependencies kontrol ediliyor...
call dart pub get

if %errorlevel% neq 0 (
    echo ❌ Dependencies yüklenemedi!
    pause
    exit /b 1
)

echo ✅ Dependencies başarıyla yüklendi

REM Server'ı başlat
echo 🚀 Server başlatılıyor...
echo 📡 Endpoints:
echo    POST http://localhost:%PORT%/login
echo    GET  http://localhost:%PORT%/flights
echo    POST http://localhost:%PORT%/checkout
echo    GET  http://localhost:%PORT%/profile
echo    GET  http://localhost:%PORT%/health
echo.
echo ⚠️  Server'ı durdurmak için Ctrl+C'ye basın
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set PORT=%PORT%
dart run bin/server.dart