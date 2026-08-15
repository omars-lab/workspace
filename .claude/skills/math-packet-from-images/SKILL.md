---
name: math-packet-from-images
description: Convert a directory of math-problem screenshots/photos into a parametrized homework-cli YAML packet, reusing existing problem types and only adding new ones when absolutely necessary, while preserving difficulty and per-problem theme.
---

# Math Packet From Images

## Purpose

Given a directory of screenshots or photos of math problems (e.g.
`samples/staar-practice-math/`), produce a homework-cli YAML packet at
`packets/<name>.yaml` whose problems mirror the source 1-to-1 in **order,
theme, and difficulty**, but with **parametrized numbers** so each generated
test gets fresh values from the same templates.

This skill belongs to the homework-cli repo at
`/Users/omareid/Workspace/git/homework-cli`. It assumes that repo's schema,
generators, and renderer.

## When to use

- User points at a folder of math problem images and asks to "make a packet"
  / "templated yaml" / "replicate this test".
- User wants additional variants of an existing paper test.

## Inputs you need

1. The image directory (e.g. `samples/<dataset>/`).
2. The grade level (ask if not obvious from the images).
3. Desired output yaml path (default: `packets/<dirname>-templated.yaml`).

## Hard rules

### R1 — Choices must be visually/textually distinct, always

Every answer choice in a single problem must render to something different from every other choice. This applies to text, numeric values, AND visual tiles (shape blocks, solids, fraction bars, etc.).

**Even when the source paper shows 3 "identical" rhombuses to test a property:**
- Vary their `size` so each tile has different dimensions.
- Vary their orientation when you can (`triangle_up` vs `triangle_right`).
- Use shape aliases (`rhombus` ↔ `diamond` are the same; don't pretend they differ).
- Never duplicate a choice with the same renderer + same params.

The framework enforces this at build time via `_assert_unique_choices`. Do **not** add escape hatches to bypass the check — duplicates are pedagogically wrong (the student picks "the one that looks different" rather than identifies the property), and the build-time enforcement is a safety net we want to keep.

If you find yourself wanting an `allow_duplicate_choices` flag, stop and vary the choices instead.

### R2 — Layout fidelity: mirror the source's page geometry

The source paper test isn't just a list of problems — it has *layout intent*. Three problems in a side-by-side row, a vocabulary word bank shared across the next three problems, two figures shown in a grouped pair: those are not decoration, they're how the page is meant to be read. **Replicate the layout, not just the problems.**

Build a packet that looks structurally like the source:

- **Side-by-side problem rows** → use `packet.row_groups: [[4, 5, 6], [7, 8]]` to render those IDs as columns within one row.
- **Shared word banks / formula sheets / instruction blocks** → use `packet.intro_blocks` (rendered above the first problem so all problems below can reference it).
- **Per-problem visual + prompt + choices stack** → use `prompt_block` (visual rendered between prompt text and choices) instead of cramming the visual into the prompt string.
- **Pairs of labeled figures (e.g. "Rectangle A" + "Rectangle B")** → use `prompt_block` of `type: group` with two child blocks side-by-side.
- **Choices that are themselves figures** → use visual block types as choices (`type: shapes`, `type: grid`, etc.), not text descriptions of the figures.
- **"Circle the words" / "circle all that apply"** → `multi_select` with `show_count: false` and `show_letters: false` (no A/B/C glyphs and no "Select N correct answers" hint, because the source doesn't show those).
- **Vocabulary fill-ins with a visible word bank** → don't put the answer in the prompt; render the word bank as an `intro_block: word_bank` and let the answer be a free-response.

A correct list of problems with the wrong page geometry is still a wrong packet. Step 1.5 below is the dedicated layout pass — don't skip it.

## Defaults (don't ask, just do)

These were burned in after the Yara Math run. Apply automatically; only ask when something is ambiguous beyond these defaults.

### D1 — Image quality: transcribe what's legible, flag uncertainties

Photos of paper tests are often tilted, glare-streaked, or blurry. **Do not block on perfect transcription.** Read each image, transcribe what is clearly legible, and for anything uncertain:

- Add a `# UNCERTAIN: <what you couldn't read>` YAML comment above the affected problem.
- Make a best-effort guess for the missing piece and mark it `# GUESS: ...` so the user can verify on review.
- Never invent a problem wholesale. If you can't read enough to know what kind of problem it is, leave it as a static `free_response` with a `# UNREADABLE — please retype prompt` comment and the original image filename.

Only ask the user to retype or rephotograph if **most** of the page is unreadable.

### D2 — Geometry / vocabulary-heavy packets: static mirror, flag clearly

Some packets don't fit the parametric model — they're built around fixed vocabulary, shape identification, or composition puzzles where the visual *is* the question. Examples:

- "____ figures have the same size and shape." (answer: congruent — fixed term)
- "Circle all words that describe this quadrilateral." (answer depends on which fixed shape is drawn)
- "Combine two pattern blocks to make this figure." (composition puzzle, no clean parametric form)

**Default behavior:** produce a *static mirror* — same problems, same shapes, same answers, no parametrization. The packet is still useful as a clean printable copy.

**You must flag this clearly:**
1. Add a top-level YAML comment block at the start of the packet:
   ```yaml
   # ──────────────────────────────────────────────────────────────
   # STATIC MIRROR — this packet is NOT parametrized.
   # Reason: <one-line reason, e.g. "geometry vocabulary + shape ID, no clean numeric variation">
   # Each variant seed produces the same PDF.
   # ──────────────────────────────────────────────────────────────
   ```
2. In the user-facing report (Step 7), lead with: **"Static mirror — no variants."** Explain which problems blocked parametrization.
3. Per-problem comments: `# STATIC: <reason>` above each non-parametric problem so a future reader understands the choice.

**Partial parametrization is fine.** If 8 of 12 problems can be parametrized and 4 can't, do that — mark the 4 with `# STATIC:` comments and skip the top-level static-mirror banner. The banner is only for *fully* static packets.

**Decision rule:** if more than ~half the problems are vocabulary fill-ins, fixed-shape identification, or composition puzzles, default to static mirror for the whole packet. Don't half-parametrize a packet that's mostly static — it's confusing to review.

## Workflow

### Step 1 — Inventory the images

List the dir and read each image **in sorted (chronological) order** so the
problem order matches the source paper.

```bash
ls samples/<dir>/ | sort
```

For each image use the `Read` tool to view it. Note:
- Problem number (or assign sequential 1..N if not numbered).
- Problem type (see catalog below).
- Whether it has a visual element (number line, table, shapes, image).
- The exact phrasing/theme (fruit stand, movie tickets, garden, etc.).
- The numeric quantities used and the correct answer.

### Step 1.5 — Layout pass (page geometry)

After you've inventoried the problems but **before** you start writing the YAML, do a dedicated layout pass over the source pages. Most page-geometry mistakes (problems stacked when source has 3 columns, vocab fill-ins missing the shared word bank, "circle all that apply" wearing A/B/C glyphs the source doesn't have) come from skipping this step and going straight from "what's the answer" to writing YAML.

For each source page, write down (in scratch notes or a YAML comment):

1. **Page-level structure**
   - Is there a vocabulary box, formula sheet, or instruction block at the top that's *shared* across multiple problems below it? Note which problem IDs reference it.
   - Are there section headers that group problems (e.g. "Concepts and Skills" / "Test Prep")? They don't render in our packets, but knowing the boundaries helps you spot when a row of side-by-side problems begins/ends.

2. **Per-row arrangement**
   - For each strip of vertical space on the page, how many problems share that row?
     - 1 → normal stacked rendering, nothing special.
     - 2 → side-by-side pair (e.g. congruence comparison: P7|P8).
     - 3 → three-column row (e.g. multi-select shape questions: P4|P5|P6).
   - Record these as `row_groups: [[<ids>], [<ids>], ...]` in the `packet:` meta block. The renderer will lay them out as a Table row.

3. **Per-problem stack** (within each problem's own block)
   - Where is the visual relative to the prompt text and choices?
     - Visual *between* prompt and choices → `prompt_block`.
     - Visual *to the right* of the prompt → still `prompt_block` (the renderer centers it on its own line; right-alignment isn't supported and rarely matters for legibility).
     - Visual *as each choice* → choices are visual block types, not strings.
   - Are choices lettered (A/B/C/D circles) in the source? If yes, default. If no — most often "circle all that apply" — set `show_letters: false`.
   - Is there a "Select N correct answers" hint in the source? If no, set `show_count: false`.
   - Does the source label sub-figures with text ("Rectangle A", "2 ft")? Use `grid.labels` or text inside a `group` block.

4. **Page breaks**
   - Note approximately how many problems fit per page in the source (usually 4-6 for paper tests, 2-3 for our PDFs because we render larger).
   - If the source has 12 problems on 2 pages and our packet renders 1-2 per page, that's expected — don't try to match page count.
   - But: if the source pairs two problems on the same row that *must* be compared visually (e.g. "is figure A congruent to figure B?"), the row pair must stay together — use `row_groups`.

5. **Static-mirror call**
   - Re-evaluate D2 (geometry/vocabulary heavy) given what you saw. If the layout pass surfaced lots of "the visual *is* the question" problems, lean toward static mirror.

Output: a short layout-plan note (5-10 lines) with `row_groups`, `intro_blocks`, and any `show_count: false` / `show_letters: false` flags you need. **The YAML you write next must match this plan.**

### Step 2 — Classify each problem against the existing type catalog

The repo already supports these problem types — **always reuse first**:

| Schema type | Use when |
|---|---|
| `multiple_choice` | 4–8 answer options, one correct |
| `multi_select` | "Select N correct answers" |
| `free_response` | Open-ended numeric answer with work area |

`multiple_choice` and `multi_select` accept a `prompt_block` (visual that
appears between the prompt text and the answer choices). Choices may also
be visual blocks instead of strings.

Visual block types (usable as `prompt_block` and, where it makes sense, as
choices):

| Block `type` | Use when | Key fields | `*_from` hooks |
|---|---|---|---|
| `table` | Static data table (tally, schedule, money) | `headers`, `rows` | `rows_from` |
| `shapes` | Row of geometric tiles | `shapes: [square, triangle, …]` | — |
| `clock` | Analog clock face | `hour`, `minute` | `hour_from`, `minute_from` |
| `fraction_bar` | Single bar split into N cells, K shaded | `parts`, `shaded` | `parts_from`, `shaded_from` |
| `fraction_number_line` | 0-to-1 line split into N parts with point at K/N | `parts`, `point` | `parts_from`, `point_from` |
| `number_line` | Integer number line w/ optional dots and arc-style jumps | `range`, `dots`, `arrows`, `step` | `dots_from`, `arrows_from`, `range_from` |
| `dot_plot` | Categorical dot plot | `title`, `labels`, `counts` | `counts_from` |
| `bar_chart` | Vertical bar chart | `title`, `labels`, `values`, `y_max` | `values_from` |
| `pictograph` | Rows of icons w/ `per_symbol` legend (supports halves) | `title`, `labels`, `counts`, `per_symbol` | `counts_from` |
| `grid` | Unit grid; supports plain rectangles, L/T/staircase composites via `cells: [[x,y], …]`, dashed `divider`, overlay `labels: [{x, y, text}]` for "4 ft" / "Rectangle A" annotations, and equal-area-different-shape puzzles via `groups: [[[x,y],…], …]` (each inner list = a distinct light fill color) | `cols`, `rows`, `shaded`, `cells`, `divider`, `labels`, `groups`, `cell_size` | `cols_from`, `rows_from`, `shaded_from`, `cells_from`, `divider_from`, `groups_from` |
| `shapes` | Row of geometric tiles | `shapes`, `size`, `gap`, `fill` (set `fill: false` for outline-only, default in geometry packets) | — |
| `solid_3d` | Wireframe 3D solids | `kinds: [rect_prism, tri_prism, cube, cylinder, cone, sphere]` | — |
| `group` | Composite: multiple visuals side-by-side (e.g. bar+pictograph, RectA+RectB pair) | `blocks: [<block>, <block>, …]` | (recursive) |
| `word_bank` | Yellow-header vocabulary box, used as an `intro_block` so several problems can share one | `title`, `terms` | — |

**Layout primitives** (live on `packet:` meta, not on individual problems):

| Field | Use when | Notes |
|---|---|---|
| `packet.row_groups: [[id, id, …], …]` | Source shows N problems side-by-side as columns in one row | Each inner list becomes one Table row; problems render as columns of equal width |
| `packet.intro_blocks: [<block>, …]` | Shared content above the first problem (vocabulary box, formula sheet, instructions) | Accepts `word_bank`, `table`, `shapes`. Rendered once at the top of the packet |
| `multi_select.show_count: false` | Source doesn't show "Select N correct answers" | Hides the hint |
| `multi_select.show_letters: false` | Source uses bullets/no letters (e.g. "circle the words") | Renders choices as a flush-left list, no A/B/C glyphs |
| `free_response.prompt_block` | A free-response problem has its own figure (e.g. "find the area of *this* L-shape") | Same union as MC's `prompt_block` |

**Only propose adding a new type if the image truly cannot be expressed with
the above.** If you must, stop and tell the user exactly what's missing
(schema field, renderer Flowable, generator helper) before editing code.

### Step 3 — Design each problem's generator (difficulty preservation)

Read `docs/difficulty-patterns.md` from the homework-cli repo for the
**pick-answer-first** principle and difficulty ranges per grade. The rules
that matter:

1. **Pick the answer first**, then derive the inputs so the math is clean.
   Don't randomize inputs and hope the answer is whole.
2. **Match the source's number ranges** — if the source uses 2-digit × 1-digit
   multiplication, your generator must too. Don't drift to 3-digit.
3. **Distractor families** must mirror the source's wrong-answer style:
   off-by-one, wrong-operation, swap-operands, area-vs-perimeter, etc.
4. **Keep the theme word-for-word** — fruit stand stays fruit stand, garden
   stays garden. Only the *numbers and names* vary.
5. **Same answer count and same answer position pool** as source. The shuffle
   step will randomize which letter the correct answer ends up at.

Available generator features (see `src/homework_cli/generate.py`):
- `vars`: `int`, `float`, `choice`, `int_list` (no cross-references between vars — derive dependent values in `compute` instead)
- `compute`: arithmetic + helpers `pack, concat, rect_cells, time_str,
  time_add, compare, abs, min, max, round_to, digit, len, sum, freq,
  shift_freq, list_join`
  - `rect_cells(x0, y0, w, h)` returns the list of `[x, y]` cells for a
    rectangle, for use with `grid.cells_from`.
  - `concat(list_a, list_b, …)` concatenates lists — pair with
    `rect_cells` to build composite L-shapes:
    `concat(rect_cells(0,0,bw,bh), rect_cells(0,bh,tw,th))`.
- `require`: list of boolean expressions that MUST be true after vars +
  compute are resolved. Build fails if any assertion is false.
  ```yaml
  require:
    - "total % groups == 0"   # ensures whole-number division
    - "per_group >= 2"        # keeps the answer reasonable
  ```
- Substitution `{{var}}` works in `prompt`, string `choices`, and
  table cells/headers.
- For visual prompts/choices that depend on generated data, point a
  block's `*_from` field at a generator var name (e.g. `parts_from`,
  `arrows_from`, `shaded_from`). The shuffle layer pulls the live value
  from the context dict — never stringifies it.

**Difficulty patterns learned the hard way** (see also
`docs/difficulty-patterns.md`):

1. **Pick the answer first.** Generate the *result* in a clean range, then
   work backward to the inputs. Randomizing inputs first produces ugly
   fractions, off-grid values, and invalid distractors.
2. **Snap to the visual's grid.** If a `number_line` has `step: 25`, every
   value drawn on it (`start`, `mid`, `end`, `lo`, `hi`) must be a
   multiple of 25 — wrap raw vars with `round_to(x, 25)`.
3. **Clamp to keep fractions proper.** When a generator picks a numerator
   for a fraction, clamp it to `parts - 1` so you never produce K/K (and
   distractors don't collapse to the answer).
4. **Distractors must be unique.** The framework enforces this at build
   time — if two choices render identically the build fails. But design
   for it: ensure no two `{{...}}` expressions can collapse to the same
   value. Common collision: `1/{{point}}` vs `1/{{parts}}` when
   `point == parts`.
5. **Division of discrete things must yield whole numbers.** When
   dividing people, objects, animals — anything that can't be fractional
   — always pick the answer first and multiply back, or add a `require:`
   line like `"total % groups == 0"`. Never rely on integer ranges
   happening to align. The framework enforces `require:` every seed.
5. **Pack tuples through `pack()`.** When a `*_from` field needs a
   list/tuple (e.g. `arrows_from`, `shaded_from`, `range_from`), build it
   in `compute` with `pack(a, b)` or `pack(pack(s,e), pack(s2,e2))`. The
   safe-eval has no list-literal support.
6. **Floats: round at compute time.** Compute results auto-round to 6
   decimals, but for display in prompts wrap values in your own helpers
   to avoid `2.0999996 lb`-style artifacts.

### Step 4 — Write the YAML

Skeleton:
```yaml
packet:
  title: "<Grade> Math Practice (Generated)"
  student_name_field: true
  problems_per_page: 2
  shuffle:
    problems: false   # preserve source order for side-by-side comparison
    choices: true

problems:
  - type: multiple_choice
    id: 1
    generator:
      grade: 3
      vars: { a: { int: [10, 99] }, b: { int: [10, 99] } }
      compute:
        sum: "a + b"
        wrong1: "a + b + 10"
        wrong2: "a + b - 1"
        wrong3: "a - b"
    prompt: "..."
    choices: ["{{wrong1}}", "{{sum}}", "{{wrong2}}", "{{wrong3}}"]
    answer: B
  # ... one entry per source image, in order
```

Conventions:
- `id` = source problem number.
- Add a `# Pn — short description` comment above each problem.
- For static problems (vocabulary, answer-letter-tied-to-shape, etc.), keep
  them static and add a comment explaining why.
- For partially templatable problems, template what you safely can and
  document the limitation in a YAML comment.

### Step 5 — Validate and render

```bash
./bin/homework validate packets/<name>.yaml
make templated PACKET=packets/<name>.yaml   # if a target exists
# otherwise:
./bin/homework build packets/<name>.yaml -o out/<name>.pdf --seed 42 --answer-key
open out/<name>.pdf
```

If validate or render fails, fix the YAML; never silently delete a problem.

### Step 6 — Spot-check rendered output

Open the PDF and verify:
- Problem count matches source.
- Each problem renders with its visual (table/shapes/number line if any).
- Answer key heading reads correctly.
- For 2–3 sampled problems, mentally re-derive the answer with the
  generated numbers and confirm it matches the listed correct letter.

### Step 6.5 — Layout review (mandatory second pass)

Open the source images and the generated PDF side by side. For each page in the source, walk down the page and ask:

1. **Row groups.** Are the same problems side-by-side in the rendered PDF as in the source? If the source has P4|P5|P6 in three columns and your packet stacks them, fix `row_groups`.
2. **Word bank / intro blocks.** If the source shows a vocabulary box at the top of the page, is one rendered above the first problem in your PDF? If not, add `intro_blocks: [{type: word_bank, …}]`.
3. **Visuals on the right problems.** For every problem that had a figure in the source, does the rendered problem also have one? Empty work-area boxes where there should be a shape or grid are silent regressions.
4. **Choice glyphs.** "Circle the words" / "circle all that apply" problems should not have A/B/C circles in the rendered PDF if the source doesn't. Set `show_letters: false`.
5. **"Select N" hint.** If you see `Select N correct answers.` in the rendered PDF but the source doesn't show that hint, set `show_count: false`.
6. **Pair figures.** Two-figure problems (P9 in Module 16 had Rectangle A and Rectangle B) should render as a side-by-side group, not a single figure. Use `prompt_block: {type: group, blocks: […]}`.
7. **Distinct visual choices.** Per R1, every visual choice must look different — even if the source paper appears to show "three identical rhombuses," you must vary `size` / orientation / variant so each tile renders distinctly.
8. **Outer borders on plain grids.** A plain rectangle grid (`cols × rows`, no `cells`) needs its outer boundary visible. If you see a faint grey outline only, the renderer is missing the heavy border — flag it and add the fix in `Grid.draw`.

If any of these fail, **fix the YAML and rebuild before reporting to the user.** Don't ship a packet that's missing layout it should have.

### Step 7 — Report

Tell the user:
- YAML path written.
- PDF path generated.
- Count of problems templated vs. left static (with reasons).
- Any new schema/renderer/helper additions you'd recommend (do **not**
  implement them unless the user asks — flag them as proposals).

## Anti-patterns

- ❌ Inventing a new problem type when an existing one fits.
- ❌ Drifting difficulty (e.g. source uses sums to 100, you use sums to 1000).
- ❌ Randomizing inputs without picking the answer first → ugly fractions.
- ❌ Dividing discrete things (people, objects) without a `require:` guard
  or pick-answer-first pattern → non-integer answers at some seeds.
- ❌ Re-themeing the word problem ("fruit stand" → "library books").
- ❌ Skipping problems silently. If you can't template one, keep it static
  and say so.
- ❌ Editing repo source (`schema.py`, `render.py`, etc.) without telling
  the user the gap first.

## Reference: existing helpers

- Difficulty patterns doc: `docs/difficulty-patterns.md`
- Schema models: `src/homework_cli/schema.py`
- Generator helpers: `src/homework_cli/generate.py`
- Existing templated example: `packets/3rd-math-templated.yaml`
