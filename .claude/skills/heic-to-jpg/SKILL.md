---
name: heic-to-jpg
description: Convert .HEIC images to sibling .jpg files in place, recursively. Use when the user asks to "convert HEIC to JPG", "make jpg copies of HEIC photos", or points at a directory of iPhone photos that downstream tools can't read. Originals are preserved by default; conversion is idempotent (skips files whose .jpg sibling already exists and is fresh).
---

# HEIC → JPG conversion

## When to use

User asks to convert a directory of `.HEIC` (or `.heic`) files — typically iPhone photo exports — into `.jpg` siblings so other tools (web uploads, OCR, vision models, the math-packet-from-images skill) can consume them.

## Mental model

- For every `path/to/foo.HEIC`, produce `path/to/foo.jpg` next to it.
- **Keep originals.** Never delete the `.HEIC` unless the user explicitly asks.
- **Idempotent.** If `foo.jpg` already exists and is newer than `foo.HEIC`, skip.
- **Recursive by default** when given a directory.
- **Preserve case-insensitive matching**: `.HEIC`, `.heic`, `.Heic` all qualify; output extension is always lowercase `.jpg`.

## Tool: `sips` (built-in on macOS)

Use macOS's built-in `sips` — no dependencies, fast, preserves EXIF orientation. Do NOT use `magick`/`convert`/`heif-convert` unless `sips` is unavailable.

```bash
sips -s format jpeg -s formatOptions 90 "input.HEIC" --out "input.jpg"
```

- `-s format jpeg` → output JPEG
- `-s formatOptions 90` → quality 0–100 (90 is the default for this skill: sharp text, ~2-4MB)

## Workflow

1. **Locate HEIC files.** Use `find` with case-insensitive match:
   ```bash
   find "<DIR>" -type f -iname '*.heic'
   ```
   Quote the directory — iPhone export folders often have spaces.

2. **Report scope first.** Print count and a few example paths before converting. This gives the user a chance to scope down.

3. **Convert in a loop.** For each HEIC:
   - Compute the sibling `.jpg` path (replace extension, lowercase).
   - Skip if `.jpg` exists and `mtime(jpg) >= mtime(heic)`.
   - Run `sips ... --out "<jpg>"`.
   - On failure, print the file path and the error; continue with the rest.

4. **Summary at the end.** Converted N, skipped M (already fresh), failed K.

## Reference one-liner

For a directory passed by the user, this is the canonical command. Run it via the Bash tool:

```bash
DIR="<absolute path>"
find "$DIR" -type f -iname '*.heic' -print0 | while IFS= read -r -d '' f; do
  out="${f%.*}.jpg"
  if [ -f "$out" ] && [ "$out" -nt "$f" ]; then
    echo "skip  $f"
    continue
  fi
  if sips -s format jpeg -s formatOptions 90 "$f" --out "$out" >/dev/null; then
    echo "ok    $f"
  else
    echo "fail  $f"
  fi
done
```

The `${f%.*}.jpg` trick strips the last extension regardless of case, so `IMG.HEIC` → `IMG.jpg`.

## Things to watch for

- **Spaces in paths.** Always quote `"$f"` and `"$DIR"`. Use `-print0` + `read -d ''` for safety.
- **Mixed case extensions.** `-iname '*.heic'` catches `.HEIC`, `.heic`, `.Heic`. Output is always lowercase `.jpg`.
- **Don't recurse into hidden dirs** unless the user asks — but `find` does by default. If the user has `.git/` or similar with HEIC inside (rare), narrow with `-not -path '*/.*'`.
- **Don't delete originals** unless explicitly told. If asked, verify the `.jpg` exists and is non-empty *before* removing each `.HEIC`, one at a time.
- **EXIF orientation.** `sips` preserves it correctly. If you ever switch to `magick`, add `-auto-orient`.

## When sips isn't available

Fallbacks, in order:

1. `magick "$f" -quality 90 "$out"` (ImageMagick 7)
2. `convert "$f" -quality 90 "$out"` (ImageMagick 6)
3. `heif-convert -q 90 "$f" "$out"` (libheif)

## What this skill deliberately doesn't do

- No resizing, no recompression of existing JPGs, no EXIF stripping.
- No batch renaming. `IMG_8328.HEIC` → `IMG_8328.jpg`, period.
- No moving files into subfolders. Sibling output only.
