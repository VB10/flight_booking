#!/bin/bash

# Flight Booking Backend Starter Script
echo "🚀 Flight Booking Backend Server'ı başlatılıyor..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Ana proje dizinini belirle
MAIN_PROJECT_DIR=$(pwd)
BACKEND_DIR="./backend"

# Port kontrolü
PORT=${1:-8080}
echo "🌐 Port: $PORT"

# Port doluysa (eski bir server açık kalmışsa) kapat, sonra yeniden aç
free_port() {
    local pids
    pids=$(lsof -ti tcp:"$PORT" 2>/dev/null)
    [ -z "$pids" ] && return 0
    echo "♻️  Port $PORT kullanımda (PID: $(echo $pids | tr '\n' ' ')) — kapatılıyor..."
    kill $pids 2>/dev/null
    for _ in 1 2 3 4 5 6 7 8 9 10; do
        lsof -ti tcp:"$PORT" >/dev/null 2>&1 || { echo "✅ Port $PORT boşaltıldı"; return 0; }
        sleep 0.5
    done
    echo "⚠️  Kapanmadı, zorla kapatılıyor (kill -9)"
    kill -9 $(lsof -ti tcp:"$PORT") 2>/dev/null
}
free_port

# Sadece portu boşalt (VS Code launch'tan önce çağrılır)
if [ "$2" = "--free-only" ]; then
    exit 0
fi
echo "📁 Ana proje dizini: $MAIN_PROJECT_DIR"
echo "📁 Backend dizini: $BACKEND_DIR"

# Backend dizininin var olup olmadığını kontrol et
if [ ! -d "$BACKEND_DIR" ]; then
    echo "❌ Hata: Backend dizini bulunamadı!"
    echo "   Beklenen konum: $BACKEND_DIR"
    echo "   Lütfen backend projesinin doğru konumda olduğundan emin olun."
    exit 1
fi

# Backend dizinine git
cd "$BACKEND_DIR"

# Backend dosyalarını kontrol et
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Hata: Backend pubspec.yaml dosyası bulunamadı!"
    exit 1
fi

if [ ! -f "bin/server.dart" ]; then
    echo "❌ Hata: server.dart dosyası bulunamadı!"
    exit 1
fi

echo "✅ Backend dosyları bulundu"

# Dependencies kontrol et ve yükle
echo "📦 Backend dependencies kontrol ediliyor..."
dart pub get

if [ $? -ne 0 ]; then
    echo "❌ Backend dependencies yüklenemedi!"
    cd "$MAIN_PROJECT_DIR"
    exit 1
fi

echo "✅ Backend dependencies başarıyla yüklendi"

# Server'ı başlat
echo "🚀 Backend server başlatılıyor..."
echo ""
echo "📡 Kullanılabilir Endpoints:"
echo "   POST http://localhost:$PORT/login"
echo "   GET  http://localhost:$PORT/flights"
echo "   POST http://localhost:$PORT/checkout"
echo "   GET  http://localhost:$PORT/profile"
echo "   GET  http://localhost:$PORT/health"
echo ""
echo "👤 Test Login Bilgileri:"
echo "   Email: user@test.com"
echo "   Password: 123456"
echo ""
echo "⚠️  Backend server'ı durdurmak için Ctrl+C'ye basın"
echo "📱 Flutter uygulamasını başka bir terminalde çalıştırabilirsiniz:"
echo "   cd $MAIN_PROJECT_DIR && flutter run"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Server'ı başlat
PORT=$PORT dart run bin/server.dart