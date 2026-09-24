#!/bin/bash

# One-command environment setup for this repo.
#
# Installs and verifies everything needed to work on the project:
#   1. required tooling            (flutter, dart, git — hard requirements)
#   2. Dart/Flutter dependencies   (app + local packages + backend)
#   3. generated code              (./scripts/generate.sh)
#   4. editor extensions           (.vscode/extensions.json, needs `code`)
#   5. Claude Code plugins         (.claude/settings.json, needs `claude`)
#   6. verification                (flutter analyze + flutter test)
#
# Optional tools (code, claude, gh) are reported but never fail the run.
#
# Usage:
#   ./scripts/setup.sh                 # full setup
#   ./scripts/setup.sh --check         # verify only, install nothing
#   ./scripts/setup.sh --skip-extensions
#   ./scripts/setup.sh --skip-plugins
#   ./scripts/setup.sh --skip-verify

set -e

cd "$(dirname "$0")/.."

CHECK_ONLY=0
SKIP_EXTENSIONS=0
SKIP_PLUGINS=0
SKIP_VERIFY=0

for arg in "$@"; do
    case "$arg" in
        --check) CHECK_ONLY=1 ;;
        --skip-extensions) SKIP_EXTENSIONS=1 ;;
        --skip-plugins) SKIP_PLUGINS=1 ;;
        --skip-verify) SKIP_VERIFY=1 ;;
        *) echo "Unknown flag: $arg" && exit 1 ;;
    esac
done

MISSING_REQUIRED=0
WARNINGS=()

section() { echo ""; echo "━━ $1"; }
ok()      { echo "  ✅ $1"; }
warn()    { echo "  ⚠️  $1"; WARNINGS+=("$1"); }
fail()    { echo "  ❌ $1"; MISSING_REQUIRED=1; }

# ─────────────────────────────────────────────── 1. tooling

section "Gerekli araçlar"

if command -v flutter >/dev/null 2>&1; then
    ok "flutter — $(flutter --version 2>/dev/null | head -1)"
else
    fail "flutter bulunamadı → https://docs.flutter.dev/get-started/install"
fi

if command -v dart >/dev/null 2>&1; then
    ok "dart — $(dart --version 2>&1 | head -1)"
else
    fail "dart bulunamadı (normalde Flutter SDK ile gelir)"
fi

command -v git >/dev/null 2>&1 && ok "git" || fail "git bulunamadı"

section "İsteğe bağlı araçlar"
command -v code >/dev/null 2>&1   && ok "code (VS Code CLI)"   || warn "code yok → editör eklentileri kurulamaz (VS Code: Shell Command: Install 'code' command in PATH)"
command -v claude >/dev/null 2>&1 && ok "claude (Claude Code)" || warn "claude yok → AI plugin'leri kurulamaz"
command -v gh >/dev/null 2>&1     && ok "gh (GitHub CLI)"      || warn "gh yok → issue/PR akışı elle yapılır"

if [ "$MISSING_REQUIRED" == "1" ]; then
    echo ""
    echo "❌ Zorunlu araçlar eksik, kurulum durduruldu."
    exit 1
fi

if [ "$CHECK_ONLY" == "1" ]; then
    section "Kontrol modu"
    echo "  Kurulum yapılmadı (--check)."
    [ ${#WARNINGS[@]} -gt 0 ] && printf '  Uyarı: %s\n' "${WARNINGS[@]}"
    exit 0
fi

# ─────────────────────────────────────────────── 2. dependencies

section "Bağımlılıklar"

flutter pub get >/dev/null && ok "flight_booking"

for pkg in module/*/; do
    [ -f "$pkg/pubspec.yaml" ] || continue
    (cd "$pkg" && flutter pub get >/dev/null) && ok "$pkg"
done

if [ -f backend/pubspec.yaml ]; then
    (cd backend && dart pub get >/dev/null) && ok "backend"
fi

# ─────────────────────────────────────────────── 3. codegen

section "Kod üretimi"
./scripts/generate.sh >/dev/null && ok "LocaleKeys + Assets/Fonts + model & route kodu"

# ─────────────────────────────────────────────── 4. editor extensions

if [ "$SKIP_EXTENSIONS" == "0" ] && command -v code >/dev/null 2>&1; then
    section "VS Code eklentileri"
    INSTALLED=$(code --list-extensions 2>/dev/null || true)
    while read -r ext; do
        [ -z "$ext" ] && continue
        if echo "$INSTALLED" | grep -qix "$ext"; then
            ok "$ext (zaten kurulu)"
        else
            code --install-extension "$ext" >/dev/null 2>&1 && ok "$ext kuruldu" || warn "$ext kurulamadı"
        fi
    done < <(python3 -c "
import json
print('\n'.join(json.load(open('.vscode/extensions.json'))['recommendations']))
")
fi

# ─────────────────────────────────────────────── 5. Claude Code plugins

if [ "$SKIP_PLUGINS" == "0" ] && command -v claude >/dev/null 2>&1; then
    section "Claude Code plugin'leri"
    # Kaynaklar .claude/settings.json'da tanımlı; burada indirilip kuruluyor.
    while read -r name repo plugin; do
        if claude plugin marketplace list 2>/dev/null | grep -q "$name"; then
            ok "marketplace $name (zaten ekli)"
        else
            claude plugin marketplace add "$repo" >/dev/null 2>&1 && ok "marketplace $name eklendi" || warn "marketplace $name eklenemedi"
        fi
        if claude plugin list 2>/dev/null | grep -q "$plugin"; then
            ok "$plugin (zaten kurulu)"
        else
            claude plugin install "$plugin@$name" >/dev/null 2>&1 && ok "$plugin kuruldu" || warn "$plugin kurulamadı"
        fi
    done < <(python3 -c "
import json
cfg = json.load(open('.claude/settings.json'))
for name, entry in cfg.get('extraKnownMarketplaces', {}).items():
    repo = entry['source'].get('repo') or entry['source'].get('url', '')
    plugins = [p.split('@')[0] for p, on in cfg.get('enabledPlugins', {}).items()
               if on and p.endswith('@' + name)]
    for plugin in plugins:
        print(name, repo, plugin)
")
fi

# ─────────────────────────────────────────────── 6. verification

if [ "$SKIP_VERIFY" == "0" ]; then
    section "Doğrulama"
    # `flutter analyze` info seviyesinde uyarı varsa da non-zero döner —
    # exit code değil, gerçek error sayısı bakılır.
    flutter analyze >/tmp/mf_analyze.log 2>&1 || true
    ERROR_COUNT=$(grep -c "error •" /tmp/mf_analyze.log || true)
    INFO_COUNT=$(grep -c "info •" /tmp/mf_analyze.log || true)
    if [ "$ERROR_COUNT" == "0" ]; then
        ok "flutter analyze — 0 error ($INFO_COUNT info, refactor bekleyen eski sayfalar)"
    else
        echo "  ❌ flutter analyze — $ERROR_COUNT error (detay: /tmp/mf_analyze.log)"
        grep "error •" /tmp/mf_analyze.log | head -5 | sed 's/^/     /'
        exit 1
    fi
    flutter test test/product >/dev/null 2>&1 && ok "flutter test (unit/widget)" \
        || warn "flutter test başarısız — backend'e ihtiyaç duyan entegrasyon testleri için ./start_backend.sh"
fi

# ─────────────────────────────────────────────── özet

section "Hazır"
[ ${#WARNINGS[@]} -gt 0 ] && printf '  ⚠️  %s\n' "${WARNINGS[@]}"
cat <<'NEXT'

  Sıradaki adımlar:
    ./start_backend.sh            # API sunucusu (localhost:8080)
    flutter run                   # uygulama
    ./scripts/generate.sh --watch # kod üretimini izle

  AI yetenekleri: /masterflutter-  yazıp listeye bak (10 skill, 2 agent)
NEXT
