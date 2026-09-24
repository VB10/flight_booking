#!/bin/bash

# Single entry point for every code generator in this project.
#
#   LocaleKeys  -> lib/product/gen/locale_keys.g.dart   (easy_localization CLI)
#   Assets/Font -> lib/product/gen/{assets,fonts}.gen.dart (flutter_gen_runner)
#   Models      -> **/*.g.dart                          (json_serializable)
#   Routes      -> app_routes.g.dart                    (go_router_builder)
#
# Usage:
#   ./scripts/generate.sh                 # everything, once
#   ./scripts/generate.sh --watch         # build_runner in watch mode
#   ./scripts/generate.sh --clean         # clean generated output, then build
#   ./scripts/generate.sh --localization  # only LocaleKeys (fastest loop)
#   ./scripts/generate.sh --assets        # only assets/fonts + models + routes

set -e

cd "$(dirname "$0")/.."

TRANSLATIONS_DIR="assets/translations"
GEN_DIR="lib/product/gen"

MODE="all"
CLEAN=0
for arg in "$@"; do
    case "$arg" in
        --watch) MODE="watch" ;;
        --localization) MODE="localization" ;;
        --assets) MODE="assets" ;;
        --clean) CLEAN=1 ;;
        *) echo "Unknown flag: $arg" && exit 1 ;;
    esac
done

generate_locale_keys() {
    echo "🌍 Generating LocaleKeys from $TRANSLATIONS_DIR ..."
    dart run easy_localization:generate \
        -S "$TRANSLATIONS_DIR" \
        -f keys \
        -o locale_keys.g.dart \
        -O "$GEN_DIR"
}

run_build_runner() {
    echo "🧩 Running build_runner ($1) ..."
    dart run build_runner "$1"
}

if [ "$CLEAN" == "1" ]; then
    echo "🧹 Cleaning previous generated output ..."
    dart run build_runner clean
fi

case "$MODE" in
    localization)
        generate_locale_keys
        ;;
    assets)
        run_build_runner build
        ;;
    watch)
        generate_locale_keys
        echo "👀 Watching for changes (Ctrl+C to stop) ..."
        run_build_runner watch
        exit 0
        ;;
    all)
        generate_locale_keys
        run_build_runner build
        ;;
esac

echo ""
echo "✅ Generation completed. Output:"
find "$GEN_DIR" -type f -name "*.dart" 2>/dev/null | sed 's/^/  /' || true
find lib -name "*.g.dart" -type f 2>/dev/null | grep -v "$GEN_DIR" | sed 's/^/  /' || true
