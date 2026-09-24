---
name: masterflutter-asset-add
description: >-
  Adds a new asset (SVG icon, PNG image, Lottie animation, font) to the project
  the generated way: correct folder + naming convention, pubspec registration if
  the folder is new, `./scripts/generate.sh`, then usage through the generated
  `Assets` / `FontFamily` classes instead of a string path. Use when the user
  runs /masterflutter-asset-add or asks to add an icon, image, animation or font.
---

# Add an Asset (flutter_gen)

## When to apply

- User invokes **`/masterflutter-asset-add`** or drops a new icon/image/
  animation/font into the project.
- Prerequisite: `lib/product/gen/assets.gen.dart` exists. If not, run
  **`/masterflutter-codegen-setup`** first.

## Folder & naming convention

`flutter_gen` derives the Dart getter from the path, so the path *is* the API.

| Kind | Folder | File name | Generated accessor |
|------|--------|-----------|--------------------|
| SVG icon | `assets/icon/svg/` | `ic_<name>.svg` | `Assets.icon.svg.ic<Name>` |
| PNG image | `assets/image/png/` | `img_<name>.png` | `Assets.image.png.img<Name>` |
| Lottie | `assets/animation/lottie/` | `lottie_<name>.json` | `Assets.animation.lottie.lottie<Name>` |
| Font | `assets/fonts/` | `<Family>-<Weight>.ttf` | `FontFamily.<family>` |

`snake_case` files only — a space or a dash produces an awkward getter.

## Checklist

1. **Place the file** in the folder from the table. Ask the user for the kind if
   the extension is ambiguous.
2. **pubspec.yaml** — only if the *directory* is new: add it under
   `flutter: assets:` (directory entry with a trailing slash, not the file).
   A new font needs a full `fonts:` entry with `weight:` (+ `style: italic`).
3. **Generate**: `./scripts/generate.sh --assets`
   (or `./scripts/generate.sh` when translations changed too).
4. **Verify** the accessor exists in `lib/product/gen/assets.gen.dart`.
5. **Use it** — never the raw path:
   - SVG → `Assets.icon.svg.icAircraft.svg(width: 120, height: 120)`
   - PNG → `Assets.image.png.imgBanner.image(fit: BoxFit.cover)`
   - Lottie → `Assets.animation.lottie.lottieLoading.lottie(width: 200)`
   - Font → `TextStyle(fontFamily: FontFamily.roboto)`
   Remove the direct `flutter_svg` / `lottie` import if it became unused
   (`unused_import` is an **error** in this project).
6. `flutter analyze` → 0 errors.

## Do not

- Write `'assets/...'` in a widget — that is exactly the bug class this replaces
  (a typo compiles fine and fails silently at runtime).
- Register a single file in pubspec when the directory is already listed.
- Hand-edit `lib/product/gen/assets.gen.dart`.
- Ship a font file that has no `pubspec.yaml` entry.

## Invocation

- **`/masterflutter-asset-add {file_path}`** — or just describe the task; the
  description above triggers this skill automatically.
