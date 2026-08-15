# Skills

Project skills for this repo. Claude Code reads `SKILL.md` straight out of
`.claude/skills/<name>/` when it is working here — there is no install step and
no build step. The `Makefile` in this directory exists only to package a skill
for somewhere that *cannot* read this repo (uploading to claude.ai); it is not
part of how these skills run.

Two distribution paths, and the choice between them is about reach:

| | lives in | reaches |
|---|---|---|
| **Project skill** (here) | `.claude/skills/` | sessions working in this repo |
| **Plugin skill** | a marketplace repo, e.g. `oeid-claude-plugin-marketplace` | every repo, once the plugin is enabled |

A skill that keeps getting wanted from other repos has outgrown this directory
and should move to a marketplace plugin.

## What's here

**Engineering practice**

| skill | what it does |
|---|---|
| `git-commit` | Read the changes, judge their quality, split what should be split, and write the message — with confirmation before committing. |
| `review-code` | Parallel review across security, readability, simplicity, testing, documentation, and customer impact. |
| `documenting-tech-designs` | How to document a component's design. |
| `condense-skill` | Squeeze a verbose skill down without losing the knowledge in it. |
| `thinking-partner` | Ten guides for helping someone think — refining ideas and goals, articulating value, planning, prioritizing, risk, root cause, testing GenAI output. |

**Mother's Day picture book** (`~/Workspace/git/mothers-day`)

| skill | what it does |
|---|---|
| `mday-scene` | One scene: inspect, regenerate its md, build an image prompt, check an illustration against the locked cast. |
| `mday-couplet` | Draft 5–7 numbered couplet options in the kid-narrator voice; the user picks a number. |
| `mday-cascade` | Insert, delete or swap scenes, moving files, frontmatter, headings and the deck in lockstep. |
| `mday-image-batch` | The image-generation loop, one scene at a time, resumable across sessions. |
| `mday-review` | Read the whole book as one poem, because drift is silent between individually-fine couplets. |

**homework-cli**

| skill | what it does |
|---|---|
| `math-packet-from-images` | Screenshots of math problems into a parametrized YAML packet, reusing existing problem types. |
| `homework-cli-add-question-type` | Add a problem or visual block type and update the showcase packet in the same pass. |

**Standalone utilities**

| skill | what it does |
|---|---|
| `discover-places` | What businesses are near an address, and whether one has filed to open there — no API keys. |
| `manage-storage` | macOS disk space: read-only diagnosis first, deletions tiered by safety. |
| `heic-to-jpg` | iPhone photos into jpg siblings, recursively and idempotently. |
| `visual-site-review` | Look at the rendered page, critique it, then look again to confirm the fix. |

## Writing one

One directory per skill, holding a `SKILL.md` that opens with YAML frontmatter:

```markdown
---
name: heic-to-jpg
description: Convert .HEIC images to sibling .jpg files in place, recursively.
  Use when the user asks to "convert HEIC to JPG", "make jpg copies of HEIC
  photos", or points at a directory of iPhone photos that downstream tools
  can't read. Originals are preserved by default.
---

# HEIC → JPG conversion
...
```

The **description is the routing signal** — it is what Claude sees when deciding
whether to load the skill at all, so it has to say *when to use this*, in the
words someone would actually type, not just what the skill is about. The longer
descriptions here (`mday-cascade`, `mday-review`) are long on purpose: they name
the phrasings that should trigger them and the neighbouring skills that should
not.

Supporting files sit beside `SKILL.md` in the same directory and are pulled in
on demand rather than up front:

```
discover-places/
  SKILL.md
  references/portals.md      # looked up when a specific portal is needed
  scripts/discover.py        # run, not read
  BLOG.md
```

That split is why a 7 KB `SKILL.md` can front 30 KB of material without paying
for it every session.

## Packaging (optional)

```bash
make list            # the skills in this directory
make dist-<skill>    # dist/<skill>.zip, for uploading to claude.ai
make all             # every skill
make clean
```

`dist/` is gitignored. Nothing in this repo consumes the zips — skip this
entirely unless you are handing a skill to something outside the repo.
