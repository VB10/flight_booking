#!/bin/bash

# Build Runner Script for Flight Booking App
# Generates JSON serialization code for model classes

set -e

echo "🔧 Running build_runner for code generation..."

cd "$(dirname "$0")/.."

# Clean previous generated files (optional)
if [ "$1" == "--clean" ]; then
    echo "🧹 Cleaning previous generated files..."
    flutter pub run build_runner clean
fi

# Run build_runner with delete-conflicting-outputs flag
echo "📦 Generating code..."
flutter pub run build_runner build --delete-conflicting-outputs

echo "✅ Code generation completed successfully!"
echo ""
echo "Generated files:"
find lib -name "*.g.dart" -type f 2>/dev/null | head -20 || echo "No .g.dart files found"
