# /write-article

Generate a Medium article by fusing YouTube transcript + GitHub PR diffs.

## Usage

```
/write-article
todo:    [todo.md items for this article]
prs:     [PR number(s)]
youtube: [YouTube video URL(s)]
part:    [part number]
```

## Example

```
/write-article
todo:
  - v6: Theme yapısı (light/dark theme)
  - v7: View - ViewModel - Mixin yapısı
prs: 8, 9
youtube: https://youtu.be/2-Q91EDSiTg
part: 2
```

## Source Roles

| Source | Role in Article |
|--------|-----------------|
| YouTube Transcript | Problem statement, reasoning, "why this matters" explanations |
| PR Diff | Before/after code blocks with real file names |
| `articles/transcripts/` | Pre-downloaded VTT files for reference |

## Article Template

```markdown
# [Descriptive Title]

[One-line description of what this article covers]

## Flutter Refactoring Masterclass — Part [N]

https://github.com/VB10/flight_booking

> **PRs:** #[numbers]

📺 **Video Series:** [1-Name](url) · [2-Name](url) · [3-Name](url)

🤖 *Want to apply these changes to your project? See the [AI prompt](#-apply-this-to-your-project) at the end.*

---

## What is Flutter Refactoring Masterclass? (Part 1 only)

[For Part 1 only - explain the series purpose]

---

## The Problem

[2–3 paragraphs from transcript - what breaks down without this refactor?]

---

## What We Changed

- **file1.dart** — [what changed]
- **file2.dart** — [what changed]

---

## [H2 per major change]

[Narrative from transcript]

**Before:**
```dart
// ❌ Before — filename.dart
[real code from PR diff]
```

**After:**
```dart
// ✅ After — filename.dart
[real code from PR diff]
```

> **Why this matters:** [from transcript reasoning]

---

## Key Takeaways

1. **[Insight]** — [explanation]
2. **[Insight]** — [explanation]

---

## What's Next

In **Part [N+1]**, we'll tackle **[topic]**—[brief description].

---

*This article is part of the **Flutter Refactoring Masterclass** series.*

---

## 📺 Watch the Full Series

[YouTube URLs on separate lines for Medium embed]

---

## 🤖 Apply This to Your Project

Use this prompt with Claude or your AI assistant:

```
[Actionable prompt based on article content]
```

---

## 📋 Full Series Roadmap

This is Part [N] of a 20-part series. Here's the complete roadmap:

https://gist.github.com/VB10/1e38a0b9cb95104de24b756787026357

**Completed:** [completed items]

**Coming Next:** [upcoming items]

---

*⭐ [github.com/VB10/flight_booking](https://github.com/VB10/flight_booking)*
```

## Rules

- **Language**: English (translate Turkish transcripts)
- **Code**: Only use real code from PR diffs
- **Trim diffs**: Use `// ...` for irrelevant sections
- **Word count**: 800–1200 for config topics, 1200–2000 for architecture
- **Comments**: `// ❌ Before` / `// ✅ After` on every code block
- **URLs**: GitHub and Gist URLs on separate lines for Medium auto-embed
- **Prompt section**: Include actionable prompt readers can use

## Output

Save to `articles/drafts/part-[N]-[slug].md`, then print:

```
✅ articles/drafts/[filename].md
📊 ~[N] words
🔀 PRs: [numbers]
📋 Covered: [todo items]
```
