#!/bin/bash

# Flight Booking Server Starter Script
echo "🚀 Flight Booking Server'ı başlatılıyor..."
echo "📁 Dizin: $(pwd)"

# Port kontrolü
PORT=${1:-8080}
echo "🌐 Port: $PORT"

# Dependency kontrolü
if [ ! -d "bin" ]; then
    echo "❌ Hata: bin klasörü bulunamadı! Doğru dizinde olduğunuzdan emin olun."
    exit 1
fi

if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Hata: pubspec.yaml dosyası bulunamadı!"
    exit 1
fi

echo "📦 Dependencies kontrol ediliyor..."
dart pub get

if [ $? -ne 0 ]; then
    echo "❌ Dependencies yüklenemedi!"
    exit 1
fi

echo "✅ Dependencies başarıyla yüklendi"

# Server'ı başlat
echo "🚀 Server başlatılıyor..."
echo "📡 Endpoints:"
echo "   POST http://localhost:$PORT/login"
echo "   GET  http://localhost:$PORT/flights"
echo "   POST http://localhost:$PORT/checkout"
echo "   GET  http://localhost:$PORT/profile"
echo "   GET  http://localhost:$PORT/health"
echo ""
echo "⚠️  Server'ı durdurmak için Ctrl+C'ye basın"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

PORT=$PORT dart run bin/server.dart