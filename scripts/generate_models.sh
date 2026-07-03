#!/bin/bash

# Model Generation Script for Flight Booking App
# Generates model code: JSON serialization (json_serializable) for models —
# including cache DTOs that implement CacheModel (see /cache-add-model) — and
# go_router typed routes. Wraps `flutter pub run build_runner`.
#
# Note: cache models are stored as JSON (no Hive adapters/typeId); Hive is
# fully encapsulated inside the cache_manager package.
#
# Usage:
#   ./scripts/generate_models.sh            # build once
#   ./scripts/generate_models.sh --watch    # regenerate on file changes
#   ./scripts/generate_models.sh --clean    # clean then build

set -e

cd "$(dirname "$0")/.."

MODE="build"
for arg in "$@"; do
    case "$arg" in
        --watch) MODE="watch" ;;
        --clean) CLEAN=1 ;;
    esac
done

echo "🧩 Generating models (Hive adapters + registrar + JSON)..."

if [ "$CLEAN" == "1" ]; then
    echo "🧹 Cleaning previous generated files..."
    flutter pub run build_runner clean
fi

if [ "$MODE" == "watch" ]; then
    echo "👀 Watching for changes (Ctrl+C to stop)..."
    flutter pub run build_runner watch --delete-conflicting-outputs
    exit 0
fi

flutter pub run build_runner build --delete-conflicting-outputs

echo "✅ Model generation completed!"
echo ""
echo "Generated model code (*.g.dart):"
find lib -name "*.g.dart" -type f 2>/dev/null | grep -Ei "model|error_model" || echo "  (none yet)"
