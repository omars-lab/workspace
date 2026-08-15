---
name: mday-image-batch
description: Drive the image-generation loop for the Mother's Day picture book at /Users/omareid/Workspace/git/mothers-day, one scene at a time. Composes a full image prompt per scene (locked cast + visual + couplet-text-on-page), copies it to the clipboard via pbcopy so the user can paste into Nano Banana / Gemini / whichever image tool they prefer, then pauses with AskUserQuestion (Approve / Recopy / Regenerate-with-tweak / Skip / Stop). Persists progress in scenes/.image-status.json so the loop is resumable across sessions. Use when the user says "generate the images", "regenerate all images", "image regen pass", "let's do the images", "next image", "image for scene N", "do the missing images", or "do the outdated ones". Also offer this skill proactively once all couplets are locked, since each existing jpg in the project bakes the older 4-line draft into the page and needs to be redone. Do NOT use this skill for couplet drafting (that's mday-couplet) or scene cascades (that's mday-cascade); this skill assumes the couplets are already locked.
---

# Mother's Day book — image generation loop

## What this is

Every page in the book is a single illustration with the couplet *rendered as text on the page*. That means whenever a couplet changes, the image is stale — the old wording is literally baked in. As of the last edit pass, **all 20 scenes either have no image yet or carry an outdated couplet**. This skill drives the regeneration loop: one scene, one prompt on the clipboard, pause for the human to paste-and-save, confirm, next.

The user generates images by hand in a tool like **Nano Banana** (Google's image model UI) or similar. There is no API call from this skill — the skill's job is to **compose the prompt and hand it off cleanly**, then track which scenes are done.

## Source of truth for style and characters

**Do not describe the style in prose. Do not describe the characters in prose.**

The canonical character likeness, hijab/glasses detail, color palette, line quality, and everything else "what does this book look like" lives in the **AI Studio session** linked in `README.md` (`https://aistudio.google.com/prompts/1CEge5gMiTnK3PNF1P5IAgRi5Z2zYcnrE`). That session has the character reference images and the prior prompts; if the user keeps generating in that thread, the model carries the look forward automatically.

Existing canonical jpgs in `scenes/` are the visual ground truth. Archived takes in `scenes/_archive/` show what's *off-canon* (third child, wrong character count, etc.) and exist as negative examples.

A prose cast block written by Claude will *drift* from the actual reference images. Don't try.

## The setup question (asked once per batch)

Before generating prompts, **ask the user via AskUserQuestion** what their generation setup is. This determines how much context the prompt needs to carry. Store the answer in `.image-status.json` so it's reused for the whole batch.

The question:

> "Where are you generating the images? This determines how much context the prompt needs to include."
>
> Options:
> - **AI Studio (existing thread)** — minimal prompt (just scene visual + couplet text-on-page). The thread carries character refs + style.
> - **AI Studio (fresh thread)** — moderate prompt (visual + text-on-page + a short pointer to attach the canonical character refs from `scenes/01-sunrise-wakeup.jpg` etc.).
> - **Nano Banana / Gemini app** — moderate prompt, plus reminder to attach 1-2 reference jpgs.
> - **Other** — full prompt with a custom theme preamble. Asks the user to paste the preamble once; it gets stored and reused.

Also ask **"Any theme preamble you want prepended to every prompt?"** — free-text, optional. If they paste one, store it; otherwise store `null` and the skill keeps prompts minimal.

This setup is one-time per batch. Don't re-ask between scenes.

## The prompt template (driven by setup answer)

Every prompt is composed of three blocks, in this order. Which blocks are included depends on the setup answer.

**Block 1 — Theme preamble** (only if the user provided one in setup; otherwise omit entirely)

The user's free-text preamble, verbatim. Could be empty.

**Block 2 — Wardrobe** (always included — looked up from CLAUDE.md by scene number)

The book has a per-segment wardrobe spec in `CLAUDE.md` under `## Wardrobe`. Look up which segment the current scene falls into and paste *that segment's bullet block* verbatim. Segments:

- **Morning pajamas:** scenes 1, 2, 3, 4, 5
- **Day outfit:** scenes 6, 7, 8, 9, 10, 11, 12
- **Prayer overlay:** scene 12 only — append the prayer overlay note *in addition to* the day outfit (the jilbab is worn over the day outfit)
- **Evening pajamas:** scenes 13, 14, 15, 16, 17, 18, 19, 20

Format the block as:

```
CHARACTER IDENTITY (locked features — do not vary):
- Mom — Lebanese, beige hijab. Sunglasses pushed up on her hijab during the day
  (off in evening pajama scenes). Reading glasses only for story time (scene 17).
- Dad — bearded, wears glasses. The beard and glasses are defining features and
  must appear in EVERY scene Dad is in — including pajama scenes (morning AND
  evening). Dad does not take off his glasses for bed in this book. If you find
  yourself rendering Dad without glasses, you are wrong; add them back.
- Yara — older sister. Dark hair worn in a high bun.
- Lana — younger sister. Dark hair in a ponytail with a red bow.

HEADCOUNT (hard constraint — count the figures before rendering):
The family is exactly four people: 2 adults (Mom, Dad) + 2 children (Yara, Lana).
No third child. No aunt, no grandparent, no friend, no neighbor, no extra adult.
If the scene visual mentions only some of the four (e.g., just Mom + the kids),
render only those people — do NOT add others to fill the frame. If extras like
a food-truck cook or shopkeeper appear in the visual, they are clearly marked
as such in the visual block; treat everyone else by default as canonical family.

WARDROBE (this scene):
- Mom — [bullet from CLAUDE.md wardrobe section]
- Dad — [bullet from CLAUDE.md wardrobe section]
- Yara — [bullet from CLAUDE.md wardrobe section]
- Lana — [bullet from CLAUDE.md wardrobe section]

AGES & PROPORTIONS:
- Yara is ~8 (early-elementary kid proportions).
- Lana is ~3 (toddler proportions; visibly smaller than Yara, head slightly larger relative to body).
- In any two-shot, Yara should look noticeably bigger than Lana. Do not render as same-size twins.
```

**Why two blocks (identity + wardrobe).** Wardrobe changes by segment (PJs → day outfit → PJs). Identity does not. Splitting them prevents the segment-specific wardrobe block from accidentally erasing things like Dad's beard and glasses, which need to appear *every* page he's in.

If a per-scene md *overrides* wardrobe (e.g., scene 11 has Mom in a fancy long dress for the dress-up beat, scene 13 has the jilbab), the scene's `**Visual:**` block already says so. The wardrobe block in the prompt is the *default*; the visual block is the *override*. Both go in. The reader (the image model) understands "wardrobe is the day's outfit; this scene depicts a different outfit because the visual says so."

**Block 3 — Scene visual** (always included)

```
SCENE [N] — [Title]

[Visual block from scenes/NN-slug.md, verbatim — do not paraphrase]
```

**Block 4 — Page layout** (always included — this is structural to the book, not stylistic)

This block is the *single biggest source of cross-page inconsistency* if left vague. Pin down the typography precisely so all 19 pages feel like one book, not 19 different illustrators' takes.

```
PAGE LAYOUT (consistent across the entire book — do not vary):
- Page proportions: standard picture-book portrait, roughly 4:5.
- Illustration occupies the upper ~75% of the page.
- A warm off-white text strip runs across the bottom ~25% of the page.
  The strip is a flat, untextured warm cream (#fdf6ec / #fff8ec range) —
  no paper texture, no decorative border, no drop shadow.

TYPOGRAPHY (must be identical on every page — match prior approved scenes in this thread):
- Reserve a dedicated text band along the bottom ~18–20% of the canvas. The
  illustration ends above this band; no characters or busy detail extend into it.
- Band background MUST be soft cream / warm pale ivory around #f3e9d2.
  Identical across every page — match the cream band used in prior approved
  scenes in this thread. NOT white, NOT pink, NOT tan, NOT dark. Cream only.
- The band has a soft horizontal gradient at its top edge fading from the
  illustration above into the cream — same gentle fade across pages.
- The couplet is rendered as TWO PHYSICAL LINES stacked vertically:
    Line 1 on top (centered).
    Line 2 directly below Line 1 (centered, ~1.3× line spacing below).
  The line break between line 1 and line 2 is a HARD line break — do NOT run
  them onto a single visual line, do NOT wrap them as one sentence.
  (For a 4-line couplet: same rule applies, four physical lines stacked.)
- Typeface: a warm classical serif (Palatino, Garamond, or Bookerly family).
  Same face across every page. No display fonts, no script fonts, no italics.
- Font color: warm dark brown ink (#3a2a1a range), never pure black.
- Font size: roughly 4–5% of the image height per line. Both lines the same size.
- Alignment: each line centered horizontally; the lines centered to each other
  with equal padding above and below the text block within the strip.
- No drop caps, no flourishes, no quotation marks added around the text,
  no decorative dividers, no all-caps.
- No text overlapping the illustration above the strip.

The cream strip + serif + warm brown ink combo is the visual signature that
ties all pages together. Treat it like a logo — same every time.
```

**Block 5 — Composition spec** (included only if the scene md declares one)

If the scene md has a `**Composition:**` block in its frontmatter or body, paste it verbatim here. This is for non-default layouts: split panels, diagonal diptychs, insets, before/after pairs. If no Composition block exists, omit Block 5 entirely — the illustration is a single panel.

Example of what a Composition block in an md might say:

```
COMPOSITION:
Diagonal split-panel diptych. Upper-left half: Mom at a full-length mirror
in her fancy long dress, the kid behind her watching with wide eyes.
Lower-right half: the same kid sitting on the floor playing with a Barbie
wearing a matching dress. The two halves are joined by a clean diagonal
seam, not a hard border.
```

**Block 6 — Text on page** (always included)

The single most common failure on this book is the model rendering the couplet as ONE long visual line on the cream strip instead of TWO stacked lines. Verbal instructions ("two physical lines", "hard line break") have proven insufficient on their own — the model keeps merging them when there's horizontal room. Use **positional grounding**: tell the model exactly where on the canvas each line goes, by vertical position. That's a structural constraint, not a stylistic one, and the model honors it more reliably.

Four layered defenses:

1. **Positional grounding** — each line has an explicit vertical position on the canvas (e.g., "Line 1 at ~83% from the top, Line 2 at ~91% from the top"). Two distinct y-coordinates makes one-line rendering geometrically impossible.
2. **The `Line N:` prefix** — keeps each line syntactically distinct in the prompt.
3. **Match-prior-scene anchor** — points the model at a scene from the same thread that already rendered correctly.
4. **Negative example** — explicit "DO NOT render as a single flowing sentence."

```
TEXT ON PAGE — render this couplet on the bottom cream strip, exactly as
written, preserving the ellipsis character (…) and punctuation. Do not
paraphrase, do not add or remove lines.

LAYOUT REQUIREMENT — THE TEXT STRIP IS A TWO-ROW STRUCTURE:
The cream strip at the bottom is internally divided into TWO HORIZONTAL
STACKED ROWS of equal height, like two stripes:

   ┌─────────────────────────────────────────────┐
   │   [Line 1 of couplet — centered]            │  upper row (~83% down)
   ├─────────────────────────────────────────────┤  (invisible divider)
   │   [Line 2 of couplet — centered]            │  lower row (~91% down)
   └─────────────────────────────────────────────┘

- Upper row of the strip = Line 1 of the couplet ONLY, centered
  horizontally, centered vertically within the upper half of the strip.
  Approximately 83% down the full canvas height.
- Lower row of the strip = Line 2 of the couplet ONLY, centered
  horizontally, centered vertically within the lower half of the strip.
  Approximately 91% down the full canvas height.
- Clear vertical gap (~1.3× line spacing) between the two rows.

DO NOT place Line 1 and Line 2 side-by-side on the same row.
DO NOT concatenate them into a single sentence and render as one line.
DO NOT let Line 1 wrap and Line 2 start on the same physical row as the
wrap continuation.

Even if both lines together would fit on a single row with horizontal
room to spare, that is WRONG. The strip's geometry is two-row, period.

Match the two-line layout from prior approved scenes (06, 09, 13).

The "Line 1:" / "Line 2:" labels below are instructional markers ONLY —
do NOT render the labels on the illustration. Render only the text
AFTER each colon.

Line 1: [first line of couplet from scenes/NN-slug.md, byte-for-byte]
Line 2: [second line of couplet from scenes/NN-slug.md, byte-for-byte]
```

For 4-line couplets, extend to four lines, evenly spaced vertically across the strip (e.g., ~80% / ~84% / ~88% / ~92% down). The positional grounding still does the work: four distinct y-coordinates makes one-line rendering geometrically impossible.

**Block 7 — Reference reminder** (only for `AI Studio (fresh thread)` and `Nano Banana / Gemini app` setups)

```
Attach reference images from scenes/01-sunrise-wakeup.jpg and one other
canonical scene jpg for character likeness. Two children only — Yara and
Lana. No third child.
```

That's it. No prose style description. No prose character description. The references and the AI Studio thread carry the visual identity. **Layout (Block 4) is not optional** — every page must have the bottom text strip; that's what makes 19 disparate illustrations feel like one book.

## How to drive the loop

### 1. Audit first (always)

Before generating anything, run an audit pass and show the user the table. This is the same audit done in conversation today:

For every scene 1-20:
- Does `scenes/NN-slug.jpg` exist?
- If yes, does the couplet baked in match the *current* couplet in the md / deck?

Mark each scene as:
- **missing** — no jpg
- **outdated** — jpg exists but couplet has changed since render
- **current** — jpg matches locked couplet

Realistically you can't *read* the text out of the jpg programmatically. Use this heuristic: if the md or the deck has a note like *"image still shows the original four-line couplet"* or *"image still shows the longer earlier draft baked in"*, mark outdated. If the md was created after a `mday-cascade` swap, mark missing or outdated. **When uncertain, mark outdated and let the user override.** Stale > false-current.

Print the table. Ask which subset to run: `all`, `missing only`, `outdated only`, `scenes 5,7,11`, or `from N`. Default is `all`.

### 2. Initialize / load status file

Status lives at `scenes/.image-status.json`:

```json
{
  "updated_at": "2026-05-03T14:00:00Z",
  "style_override": null,
  "scenes": {
    "1": {"status": "approved", "approved_at": "2026-05-03T14:05:00Z"},
    "2": {"status": "pending"},
    "5": {"status": "skipped", "note": "wants to redo visual first"}
  }
}
```

If the file exists, load it and skip already-approved scenes (unless the user asks to redo). If not, create it.

### 3. The per-scene loop

For each scene in the chosen subset, in order:

1. **Read the scene md** (`scenes/NN-slug.md`). Pull the visual block and the couplet exactly. If the md has no couplet locked yet (`*(to draft)*`), abort the scene and tell the user — couplet must be locked before image.
2. **Compose the full prompt** using the template above.
3. **Copy to clipboard:** pipe the prompt to `pbcopy`. Confirm by reading back the byte count.
4. **Tell the user, succinctly:**
   ```
   Scene N — "Title"
   Prompt is on your clipboard. (about X chars)
   Paste into the gen tool, generate the image, then download it
   anywhere convenient (Downloads, Desktop, etc.). Don't worry about
   the filename — when you Approve, I'll ask where the file is and
   move/rename it to scenes/NN-slug.jpg for you.
   ```
5. **Pause with AskUserQuestion.** Options exactly these, in this order:
   - **Approve** — image generated and downloaded. Skill then asks: *"What's the path to the downloaded file?"* (free-text — common defaults: `~/Downloads/<filename>`). Skill runs `mv "<path>" scenes/NN-slug.jpg` (archiving any existing canonical jpg first via `mv scenes/NN-slug.jpg scenes/_archive/NN-slug-<timestamp>.jpg`), confirms the move succeeded, marks approved, advances.
   - **Recopy** — clipboard got clobbered, paste again. Re-runs `pbcopy` with the same prompt; loops back to step 4 without advancing.
   - **Regenerate** — same prompt, want another take. Stays on this scene; user pastes again.
   - **Tweak** — adjust the prompt before recopying. Ask what to change in one short follow-up, edit the prompt, re-pbcopy, loop back to step 4.
   - **Change theme** — update the batch-level setup (switched tools, want a different preamble). Re-runs the setup question, stores the new answer, recomposes the current prompt, re-pbcopies.
   - **Skip** — leave this scene for later. Mark skipped, advance.
   - **Stop** — exit the loop, save status. Print a short summary of what's done / pending.

   **Approve flow detail.** When the user picks Approve, **default to the latest image file in `~/Downloads/`** — do not ask for a path unless the latest-Downloads heuristic fails or the user explicitly says the file is elsewhere. Resolve the latest with a glob across common image extensions (png/jpg/jpeg/webp/heic), sorted by mtime, taking the newest. If zero images match in `~/Downloads/`, *then* ask. If multiple were created in the last few minutes, pick the newest and tell the user which one — they can correct.

   Before moving: if `scenes/NN-slug.jpg` already exists, **archive it — never delete**. Use `mv scenes/NN-slug.jpg scenes/_archive/NN-slug-<unix-timestamp>.jpg`. Every prior take is preserved with a timestamped filename so the user can roll back or compare. Then `mv "<download-path>" scenes/NN-slug.jpg` (use `mv` even for `.png`/`.webp` source — the canonical filename is always `.jpg`; the extension on disk just becomes the saved bytes, which is fine for the deck and for the print pipeline). Verify the move with `ls -lh scenes/NN-slug.jpg` and report the new size, so the user knows it landed.

   **Hard rule on archives:** never `rm` a canonical jpg. Always `mv` it into `_archive/` with a timestamp suffix. The same applies to alt files the user may want to retire — move, don't delete. Disk space is not a concern; recoverability is.

   Glob to use:
   ```
   ls -t ~/Downloads/*.{png,jpg,jpeg,webp,heic} 2>/dev/null | head -1
   ```
   With zsh's NOMATCH, wrap in `setopt -s NULL_GLOB 2>/dev/null || true` or use bash explicitly. The user is on zsh, so the safe form is:
   ```
   bash -c 'shopt -s nullglob; ls -t ~/Downloads/*.{png,jpg,jpeg,webp,heic} 2>/dev/null | head -1'
   ```
6. **Persist status** after every state change. Don't batch writes — if the loop crashes, the user shouldn't lose progress.

### 4. Handing off

When the loop ends (Stop, end of subset, or all done), print a short summary:

```
Done this run: scenes 1, 2, 5
Skipped: scene 7 (visual needs revisit)
Pending: scenes 11, 14, 17, 18

Resume any time with: "continue the image batch" or "do scene 11 next".
```

## Working agreement

- **HARD RULE: pause after every pbcopy.** After copying a scene's prompt to the clipboard, **always** invoke AskUserQuestion before doing anything else. Do not advance to the next scene, do not compose the next prompt, do not call any other tool. The pause is the entire point of the loop — without it, the user can't paste, generate, and download. If you find yourself about to call `pbcopy` for scene N+1 without having received an Approve answer for scene N, stop and ask.
- **HARD RULE: never auto-advance on Approve.** Approve triggers the download-path question. Only after the file has been moved to `scenes/NN-slug.jpg` and the move is verified (via `ls`) do you compose the next scene's prompt.
- **One scene at a time.** Do not pre-stage multiple prompts on the clipboard. The clipboard is the handoff; only one prompt should be live at a time.
- **The clipboard is fragile.** Users copy other things during the loop (filenames, URLs). Always offer Recopy as the first option after Approve. Don't assume the prompt is still there.
- **Couplet text is sacred.** The whole reason the regen pass exists is that text drifts when the image bakes it in. When composing the prompt, copy the couplet from the md *byte-for-byte* (including the ellipsis character `…`, not three dots `...`). If the md uses `…`, the prompt must too.
- **Visual block is the user's words.** Don't paraphrase the visual block from the md when composing the prompt. The user has already curated those words to describe the picture; passing them through verbatim is faster and more accurate.
- **Save path is canonical.** Always tell the user to save to `scenes/NN-slug.jpg`. Do not invent variants like `-v2.jpg` — overwrite the canonical, archive the old via `mv` to `_archive/` if the user wants to keep the prior take.
- **Don't read images to verify.** This skill cannot OCR a generated image to check the rendered text matches the couplet. The human is the verification step. The Approve/Regenerate/Tweak loop is *the* QA mechanism.
- **No silent failures.** If `pbcopy` fails (very rare on macOS), say so — don't ask the user to "approve" a prompt that never reached the clipboard.

## When to invoke

- User says: "generate the images", "regenerate all images", "let's do the images", "image regen pass", "do the missing images", "do scene N's image", "next image".
- Proactive offer: when `mday-review` (Mode A or B) reports the book is "ready to print" pending images, offer to drive this loop.
- Proactive offer: after `mday-couplet` locks a couplet for a scene whose existing image bakes a different wording, mention "the image for scene N is now stale — want me to regenerate it via mday-image-batch?".

## When NOT to invoke

- Couplet drafting (`mday-couplet`).
- Scene insertion / renumbering (`mday-cascade`).
- Single-scene prompt composition without the loop — if the user just wants the prompt for one scene to paste somewhere unusual, compose it inline rather than spinning up the full loop and status file.
