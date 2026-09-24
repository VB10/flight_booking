---
name: masterflutter-env-setup
description: >-
  Sets up or audits the full working environment for this repo — required
  tooling, Dart/Flutter dependencies, generated code, VS Code extensions, Claude
  Code plugins (claude-mem, i-have-adhd), the project's skills and agents — and
  drives it all through `./scripts/setup.sh`. Use when the user runs
  /masterflutter-env-setup, clones the repo for the first time, asks "what do I
  need installed", or something in the AI/editor setup stops working.
---

# Environment Setup (tooling, plugins, agents, skills)

## When to apply

- **`/masterflutter-env-setup`**, a fresh clone, a new machine, or a viewer of
  the series asking what they need installed.
- A skill or agent that "used to work" no longer appears → run the audit.

## The requirements list

Everything the repo needs, and what breaks without it.

### Hard requirements

| What | Check | Without it |
|------|-------|-----------|
| Flutter SDK (3.47+) | `flutter --version` | nothing runs |
| Dart SDK (3.8+) | `dart --version` | ships with Flutter |
| Git | `git --version` | no branch/PR flow |

### Optional, but this repo assumes them

| What | Check | Without it |
|------|-------|-----------|
| VS Code + `code` CLI | `code --version` | extensions must be installed by hand |
| Claude Code | `claude --version` | no skills, agents or plugins |
| GitHub CLI | `gh auth status` | issues/PRs by hand (the series uses issues per episode) |

If `code` is missing on macOS: VS Code → Cmd+Shift+P → *Shell Command: Install
'code' command in PATH*.

### Project dependencies

- `flutter pub get` at the root **and** in every `module/*` local package
  (`cache_manager`, `utils`) — they are `path:` dependencies, so a missing
  `pub get` there breaks the app build, not just the package.
- `dart pub get` in `backend/` — the sample API server.
- `./scripts/generate.sh` — nothing under `lib/product/gen/` is committed as
  hand-written code; without it `Assets`, `FontFamily` and `LocaleKeys` do not
  exist and the app will not compile.

### Editor extensions

Declared in `.vscode/extensions.json`, so VS Code offers them on open. The list
is deliberately narrow — what this repo actually uses, not a personal setup:
Dart/Flutter, bloc, Claude Code, Error Lens, GitLens, EditorConfig,
pubspec-assist, flutter-i18n-json, indent-rainbow, trailing-spaces.

`.vscode/settings.json` (line length 80, format on save) and
`.vscode/tasks.json` (the Codegen tasks) are already committed — they need no
installation, only that the repo is opened as the workspace root.

### Claude Code plugins

Declared in `.claude/settings.json` via `extraKnownMarketplaces` +
`enabledPlugins`, so they travel with the repo:

| Plugin | Marketplace | Why |
|--------|-------------|-----|
| `claude-mem` | `thedotmack` (thedotmack/claude-mem) | cross-session memory of past work |
| `i-have-adhd` | `i-have-adhd` (ayghri/i-have-adhd) | focus/session helpers |

Declaring them is not installing them — `./scripts/setup.sh` runs
`claude plugin marketplace add` + `claude plugin install`. A teammate who does
not want one sets it to `false` in `.claude/settings.local.json` (local
overrides project).

### The repo's own AI layer

Ships in git, needs no installation — but verify it is visible:

- **10 skills** in `.claude/skills/masterflutter-*` — type `/masterflutter-` to list.
- **2 agents** in `.claude/agents/`:
  `masterflutter-reviewer` (diff vs. this repo's conventions) and
  `masterflutter-refactor-scout` (what is left on a page, in which order).

If they do not appear, the session was started outside the repo root — Claude
Code reads `.claude/` relative to the working directory.

## How to run it

```bash
./scripts/setup.sh              # full setup, idempotent
./scripts/setup.sh --check      # audit only, installs nothing
./scripts/setup.sh --skip-extensions --skip-plugins --skip-verify
```

The script is the source of truth; this skill explains *why* each step exists.
When a step fails, read the step's own section above before improvising.

## Known, expected results

- `flutter analyze` reports **0 error** plus ~80 `info` lints. Those are in the
  not-yet-refactored pages (cart, profile, flight detail) and are tracked in
  `todo.md` — do not "fix" them here.
- `flutter test` fails the `test/product/service/*` **integration** tests unless
  `./start_backend.sh` is running. That is expected; they hit a real API.
- Extensions and plugins already present are reported as "zaten kurulu" — the
  script never reinstalls.

## Do not

- Add a personal extension (theme, Python, markdown tooling) to
  `.vscode/extensions.json` — it is a repo recommendation list, not a dotfile.
- Enable a plugin only in `~/.claude/settings.json` and call it done — a
  teammate cloning the repo would not get it; declare it in
  `.claude/settings.json`.
- Hand-install what `setup.sh` can do — if a step is missing from the script,
  add it there instead of documenting a manual workaround.
- Commit anything under `lib/product/gen/` as hand-written code.

## Invocation

- **`/masterflutter-env-setup`** — or just describe the task; the description
  above triggers this skill automatically.
