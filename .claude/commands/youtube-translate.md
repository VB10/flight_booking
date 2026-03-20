# /youtube-translate

Download YouTube video transcript & metadata, translate everything to English for upload.

## Usage

```
/youtube-translate [youtube-url]
```

## Example

```
/youtube-translate https://youtu.be/Uyp0rWupYJc
```

## Process

### Step 1: Download Video Metadata
```bash
yt-dlp --dump-json [URL]
```

Extract these fields:
- `id` - Video ID
- `title` - Original title
- `description` - Original description
- `tags` - Tags array
- `categories` - Categories
- `duration` - Duration in seconds
- `channel` - Channel name
- `upload_date` - Upload date

### Step 2: Download Transcript
```bash
yt-dlp --write-auto-sub --sub-lang tr --skip-download -o "articles/transcripts/%(id)s" [URL]
```

This creates: `articles/transcripts/[video-id].tr.vtt`

### Step 3: Clean VTT Transcript (Timestamped)
Parse the VTT file and:
- Remove WEBVTT header
- Remove alignment/position tags
- Remove `<c>` timing tags
- Remove duplicate lines
- **Group text by 30-second intervals**
- Format as: `**[MM:SS]** text content`

Example output:
```
**[00:00]** Hello dear friends. I hope you're doing well...
**[00:30]** In this video we'll discuss the architecture...
**[01:00]** Let me show you the code structure...
```

### Step 4: Translate to English
Translate all content:
- Title
- Description
- Tags
- Full transcript

Use natural, professional English suitable for YouTube.

### Step 5: Generate Output

## Output Template

```markdown
# [English Title]

> Translated from Turkish YouTube video

## Video Metadata

| Field | Value |
|-------|-------|
| **Original Title** | [Turkish title] |
| **Channel** | [channel name] |
| **Duration** | [MM:SS] |
| **Category** | [category] |
| **Upload Date** | [YYYY-MM-DD] |
| **Video ID** | [id] |

---

## Description (English)

[Translated description - keep formatting, links, and structure]

---

## Tags (English)

`tag1`, `tag2`, `tag3`, `tag4`, `tag5`

---

## Full Transcript (English) - Timestamped

**[00:00]** [Translated content for first 30 seconds...]

**[00:30]** [Translated content for next 30 seconds...]

**[01:00]** [Continues in 30-second intervals...]

---

## Copy-Paste Section

### YouTube Title
```
[English title - max 100 chars]
```

### YouTube Description
```
[Ready to paste description with links preserved]
```

### YouTube Tags
```
tag1, tag2, tag3, tag4, tag5
```
```

## Rules

- **Language**: Output everything in English
- **Preserve Links**: Keep all URLs from original description
- **Timestamped Transcript**: Group by 30-second intervals with `**[MM:SS]**` format
- **Natural Translation**: Professional, YouTube-appropriate English
- **Tags**: Translate and expand tags if needed for English audience
- **Duration Format**: Convert seconds to MM:SS or HH:MM:SS

## Output

Save to `articles/youtube/[video-id]-en.md`, then print:

```
Done: articles/youtube/[video-id]-en.md

Original: [Turkish title]
Translated: [English title]
Duration: [duration]
Tags: [tag count]
Transcript: [word count] words
```
