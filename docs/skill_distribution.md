# Skill Dağıtımı — Homebrew Paketi ve Otomatik Release

Bu repodaki Claude Code skill'leri (`.claude/skills/masterflutter-*`) Homebrew
paketi olarak dağıtılır. Repo **aynı zamanda tap'in kendisidir** — formula ve
kaynak aynı yerde durur, senkron tutulacak ikinci bir repo yoktur.

Kısa kurulum özeti README'de: [Skill Paketi (Homebrew)](../README.md#-skill-paketi-homebrew)

---

## Paket ne taşır

| Kaynak (repo) | Pakette | İçerik |
|---|---|---|
| `.claude/skills/masterflutter-*` | `skills/` | Skill'ler — cache, route, cubit, codegen, localization, asset, network, view refactor |
| `docs/prompt/*` | `prompt/` | Skill'lerin aksiyondan önce okuduğu spesifikasyonlar |
| `bin/masterflutter-skill` | `bin/` | Etkinleştirme CLI'ı |

Slash komut dosyası yoktur; Claude Code skill'i doğrudan `/<skill-adı>` olarak
çağırır.

`brew install` hiçbir şeyi home dizinine yazmaz — her şey
`$(brew --prefix)/share/masterflutter-skill/` altına iner. `~/.claude`'a kopyalama
ayrı ve bilinçli bir adımdır: `masterflutter-skill init`.

---

## CLI komutları

| Komut | Ne yapar |
|---|---|
| `masterflutter-skill init` | Skill'leri `~/.claude/skills` altına kopyalar; prompt'ları `~/.claude/reference/masterflutter/prompt` altına global fallback olarak bırakır |
| `masterflutter-skill project [dir]` | Skill'leri `<dir>/.claude/skills`, prompt'ları `<dir>/docs/prompt` altına kopyalar (repoya commit edilebilir) |
| `masterflutter-skill status [dir]` | Global + proje durumu; kopya bayatsa uyarır |
| `masterflutter-skill remove` | Kopyalanan `masterflutter-*` skill'lerini ve global prompt kopyasını siler |

### init ile project farkı

- **`init` globaldir.** Skill'ler her projede listelenir. Tek seferlik, makine başına.
- **`project` proje bazlıdır.** `SKILL.md` dosyaları spesifikasyonlarını
  `../../../docs/prompt/...` ile okur; bu relatif yol ancak skill `<proje>/.claude/skills`
  altında dururken çözülür. Flutter projesinde çalışacaksan bunu da çalıştır.

Her iki komuttan sonra Claude Code yeniden başlatılmalıdır.

### Kopyalar snapshot'tır

`init` ve `project` dosyaları **kopyalar**, symlink atmaz. `brew upgrade` sonrası
kopyalar eski kalır; `masterflutter-skill status` bunu söyler:

```
Paket surumu  : 0.4.0
Kurulu surum  : 0.3.0
Kurulu skill  : 10
...
! Kopya guncel degil (0.3.0 → 0.4.0). 'masterflutter-skill init' ile yenile.
```

Tam güncelleme:

```bash
brew update && brew upgrade masterflutter-skill && masterflutter-skill init
cd <flutter-projesi> && masterflutter-skill project
```

### Kaynak repo koruması

`.claude/.masterflutter-source` dosyası bu repoyu işaretler. `masterflutter-skill project`
bu işareti gördüğü dizine yazmayı reddeder — aksi halde paketin eski bir sürümü,
üzerinde çalıştığın kaynak skill'leri ezerdi.

---

## Yeni skill eklemek

1. `.claude/skills/masterflutter-<ad>/SKILL.md` yaz (frontmatter: `name`, `description`).
2. Skill bir spesifikasyon okuyorsa onu `docs/prompt/` altına koy ve `SKILL.md` içinden
   `../../../docs/prompt/<dosya>.md` ile linkle.
3. Conventional commit ile PR aç: `feat(skill): add masterflutter-<ad>`.
4. PR `main`'e merge olur → release otomatik çıkar. Elle tag atmak, formula
   güncellemek, release yazmak gerekmez.

---

## Otomatik release akışı

[.github/workflows/release.yml](../.github/workflows/release.yml) `main`'e push'ta çalışır:

| Adım | Yaptığı |
|---|---|
| 1. Sürüm hesapla | Son `skills-v*` tag'inden bu yana conventional commit'lere bakar |
| 2. Tag | `skills-vX.Y.Z` oluşturup push eder |
| 3. Formula'yı sabitle | `Formula/masterflutter-skill.rb` içindeki `version` + `tag` + `revision` alanlarını yazar, `ruby -c` ile doğrular |
| 4. Commit | `chore(brew): pin formula to skills-vX.Y.Z [skip ci]` → `main` |
| 5. Release | GitHub Release açar, notları önceki tag'den üretir |
| 6. Slack | `MASTERFLUTTER_RELEASE_WEBHOOK` secret'ı tanımlıysa bildirir; tanımsızsa adım sessizce atlanır |

### Sürüm artışı

| Commit | Artış |
|---|---|
| `feat!:` ya da gövdede `BREAKING CHANGE` | major |
| `feat:` | minor |
| diğer (`fix:`, `chore:`, `docs:` …) | patch |

Elle sürüm çıkarmak için: **Actions → Release → Run workflow**, `bump` değerini seç
(`auto`, `patch`, `minor`, `major`).

### Ne zaman tetiklenmez

Workflow yalnızca şu yollar değiştiğinde çalışır:

```
.claude/skills/**
docs/prompt/**
bin/masterflutter-skill
```

Uygulama kodundaki (`lib/`, `ios/`, `android/`) commit'ler release çıkarmaz.
`Formula/**` bilinçli olarak listede değildir — workflow'un kendi formula commit'i
onu tekrar tetiklemez. (Ayrıca `GITHUB_TOKEN` ile atılan push'lar GitHub tarafında
zaten yeni workflow tetiklemez.)

### Neden `skills-v` prefix'i

Bu repo aynı zamanda masterclass uygulamasının kendisidir; kendi sürüm tag'leri
(`v1.0.0`) ve `pubspec.yaml` sürümü var. Skill paketi ayrı bir seriden gider, iki
sürüm birbirine karışmaz. Homebrew prefix'li tag'den sürüm çıkaramadığı için
formula'da `version` alanı açıkça yazılır ve workflow onu da günceller.

### Tag'e ek olarak revision neden pinli

Formula git kaynağı kullanır, tarball değil — `sha256` yoktur. Onun yerine `tag`
sürümü adlandırır, `revision` (40 karakter commit SHA) ise içeriğin değişmediğinin
kanıtıdır: tag sonradan başka bir commit'e taşınsa bile Homebrew farkı görür.

---

## Bakım notları

- **Branch protection:** `main` korumalıysa `github-actions[bot]`'a push izni
  verilmelidir; 4. adım aksi halde düşer. Workflow üç kez `pull --rebase` + `push`
  dener, araya başka bir merge girerse kendini kurtarır.
- **İlk release:** formula'daki `revision` ilk release'e kadar placeholder'dır
  (sıfırlar), yani `brew install` ancak ilk release çıktıktan sonra çalışır.
- **Formula'yı doğrulama:** `brew style Formula/masterflutter-skill.rb` ve
  `brew install --build-from-source ./Formula/masterflutter-skill.rb` + `brew test`.
  Formula'nın `test do` bloğu `CLAUDE_CONFIG_DIR`'ı test kumuna yönlendirir, gerçek
  `~/.claude`'a dokunmaz.
- **CLI'ı repodan çalıştırma:** `./bin/masterflutter-skill status` — Homebrew
  yer tutucuları (`@@PKGSHARE@@`) çözülmemişse script yolları repo kökünden çözer ve
  sürümü `dev` olarak raporlar.
