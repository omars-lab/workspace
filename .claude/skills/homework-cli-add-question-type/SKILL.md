---
name: homework-cli-add-question-type
description: Add a new problem type or visual block type to the homework-cli repo and keep the showcase packet (a living catalog of every type) up to date. Use when extending the schema, adding a new Flowable, or whenever a math-packet-from-images run produces a new block type that isn't yet represented in the showcase.
---

# Add Question Type to homework-cli

## Purpose

The homework-cli repo grows by accreting visual block types and problem types
(L-shape grid, pictograph, distributive-property MC, etc.). Each new type
must land in **four places at once** or the system desyncs:

1. The Pydantic schema (`schema.py`)
2. The renderer (`render.py` Flowable + `_build_visual` dispatch)
3. The shuffle/substitution layer (`shuffle._sub_choice` if there are
   `*_from` hooks)
4. The skill catalog (`math-packet-from-images/SKILL.md`)

…and a fifth that's easy to forget — the **showcase packet** that proves
every type renders. This skill owns the showcase plus the four-way sync.

## When to use

- User says "add a new block type" / "add a new problem type" / "extend
  the schema for X."
- A `math-packet-from-images` run hit the "no existing block fits" case
  and you've decided to add a new type.
- The showcase packet is missing a type that exists in the schema (drift
  detection: every block type in `schema.py` should have a section in
  `packets/showcase.yaml`).
- You changed an existing block's options and want to verify the
  showcase still renders cleanly.

This skill belongs to the homework-cli repo at
`/Users/omareid/Workspace/git/homework-cli`.

## Inputs you need

1. The new type's name (e.g. `pie_chart`, `box_plot`, `composite_grid`).
2. What it represents — show me a source image or describe the figure.
3. Whether it's a **block type** (visual; usable as `prompt_block` and/or
   `Choice`) or a **problem type** (top-level problem with its own
   prompt + answer schema).

If you don't have these, ask before proceeding.

## Workflow

### Step 1 — Justify the new type

Read `~/.claude/skills/math-packet-from-images/SKILL.md` and
`/Users/omareid/Workspace/git/homework-cli/CLAUDE.md` and confirm:

- No existing block can express this figure (run through the catalog
  in the math-packet-from-images skill).
- The new type is general enough to be reused — not a one-off for the
  current packet. If it's truly one-off, prefer rendering as an image
  asset or adding a special-case to an existing block.

If unsure, surface the gap to the user and stop. Do **not** add a type
on speculation.

### Step 2 — Schema model

Add a Pydantic model to `src/homework_cli/schema.py`:

```python
class FooChoice(BaseModel):
    type: Literal["foo"]
    # required fields …
    # optional fields with defaults …
    # generator hooks (always one *_from per data field):
    bar_from: str | None = None
```

Conventions:
- `type` is the singular, snake_case discriminator.
- Every data field that a generator might want to drive needs a
  matching `<field>_from: str | None = None` hook.
- Defaults must be set so the model can validate when only `*_from` is
  provided — e.g. `cols: int = 1` rather than required.
- Add the new model to:
  - The `Choice` union (so it can be used as an answer choice).
  - The `prompt_block` discriminated union on `MultipleChoice`,
    `MultiSelect`, and `FreeResponse`.
  - The `InnerBlock` union (so it can nest inside a `group`).

### Step 3 — Renderer Flowable

Add a Platypus Flowable to `src/homework_cli/render.py`:

```python
class Foo(Flowable):
    def __init__(self, ..., cell: float = 14):
        super().__init__()
        # store fields, compute self.width / self.height

    def wrap(self, *_):
        return self.width, self.height

    def draw(self):
        c = self.canv
        # use canvas primitives (rect, line, drawCentredString, …)
```

Then register in `_build_visual`:

```python
if isinstance(block, FooChoice):
    return Foo(block.field, block.field, ...)
```

If the new type is a row of identical visuals (like `shapes` is a row
of tile-shape variants), pass `gap` and compute total width as
`n * size + (n-1) * gap`.

### Step 4 — Shuffle/substitution

Edit `src/homework_cli/shuffle.py` `_sub_choice` and add a branch:

```python
if isinstance(choice, FooChoice):
    upd = {}
    if choice.bar_from and choice.bar_from in ctx:
        upd["bar"] = <coerce ctx[choice.bar_from] to the right type>
    return choice.model_copy(update=upd) if upd else choice
```

This is the easiest step to forget. Without it, `bar_from` silently
does nothing and the figure renders with the YAML-default value
across every variant.

### Step 5 — Catalog update

Append a row to the visual-block catalog table in
`~/.claude/skills/math-packet-from-images/SKILL.md`:

```markdown
| `foo` | <one-line "use when"> | `field1`, `field2`, … | `field1_from`, … |
```

Use the same wording style as existing rows.

### Step 6 — Showcase packet

Open `packets/showcase.yaml` (the living catalog). Add a section that
exercises the new type:

- A **block type** gets a free-response problem whose `prompt_block` is
  the new block, plus (when meaningful) a multiple-choice problem
  whose `choices` are instances of the block. Each example should
  exercise the most common parameter values; if the block has both a
  static and a `*_from` mode, show both.
- A **problem type** gets one example with realistic prompt + answer.

Conventions inside `showcase.yaml`:
- Section comment header: `# ===== <type> =====`
- ID convention: `id` = `"<type>-<n>"` (string IDs are fine, e.g.
  `id: "grid-1"`, `id: "grid-2"`). Keeps IDs stable when types are
  added/reordered.
- Per-problem comment: one line on what aspect this example demonstrates
  (e.g. `# composite L-shape via cells_from + divider + labels`).
- Keep examples **minimal** — the goal is "every type renders,"
  not "every parameter combination in production."

### Step 7 — Validate, build, ask about PDF

Always run validate + build:

```bash
docker build -f /tmp/Dockerfile.layer -t homework-cli:local .
./bin/homework validate packets/showcase.yaml
./bin/homework build packets/showcase.yaml -o out/showcase.pdf --seed 1
```

Then **ask the user**:

> "Showcase rebuilt. Open the PDF to spot-check?"

If yes → `open out/showcase.pdf`. If no → just report the path.

The user opt-in matters because the showcase is rebuilt frequently
during type development and force-opening every time becomes noise.

### Step 8 — Sync check (drift detection)

Before reporting success, run a one-line sanity check. The set of
`type: Literal["…"]` values across `Choice` / `prompt_block` /
`InnerBlock` unions should be a subset of the section headers in
`packets/showcase.yaml`. If you spot a type that exists in schema but
*not* in showcase (drift from past changes), flag it to the user as
"showcase missing: <list>" and offer to add minimal examples.

```bash
grep -oE 'type: Literal\["[a-z_0-9]+"\]' src/homework_cli/schema.py | sort -u
grep -E '^# =====' packets/showcase.yaml | sort -u
```

### Step 9 — Report

Tell the user:
- Files modified (schema, render, shuffle, catalog, showcase).
- New type name + one-line summary.
- Whether the showcase PDF was regenerated and its path.
- Any drift detected in Step 8.

## Anti-patterns

- ❌ Adding to schema/render but skipping shuffle — `*_from` hooks
  silently do nothing.
- ❌ Adding a Flowable but forgetting to register in `_build_visual`.
- ❌ Adding to the catalog table but not the showcase packet.
- ❌ "I'll add the showcase example later" — *now* is later. Skipping
  it means the next contributor (or future-you) has no proof the type
  works end-to-end.
- ❌ Force-opening the PDF without asking — noisy during iteration.
- ❌ Adding a one-off type for a single packet without justifying
  re-use. Prefer rendering as a static image or extending an existing
  block first.

## Reference

- Schema: `/Users/omareid/Workspace/git/homework-cli/src/homework_cli/schema.py`
- Renderer: `/Users/omareid/Workspace/git/homework-cli/src/homework_cli/render.py`
- Shuffle: `/Users/omareid/Workspace/git/homework-cli/src/homework_cli/shuffle.py`
- Catalog skill: `~/.claude/skills/math-packet-from-images/SKILL.md`
- Showcase packet: `/Users/omareid/Workspace/git/homework-cli/packets/showcase.yaml`
- CLAUDE.md ("Adding a new visual block — checklist") — same gist,
  cross-link from there.
