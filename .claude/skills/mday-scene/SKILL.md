---
name: mday-scene
description: Operate on a single scene in the Mother's Day picture book at /Users/omareid/Workspace/git/mothers-day. Use whenever the user wants to look at, inspect, summarize, regenerate the md for, or generate an image-gen prompt for a specific numbered scene — phrases like "show me scene 8", "what's in scene 12", "regenerate the md for scene 4", "give me an image prompt for the dancing scene", "what's the visual for X". Also use when the user pastes a generated illustration and asks if it matches the on-canon cast (Mom in beige hijab, Dad with beard+glasses+green shirt, Yara with high bun, Lana with red-bow ponytail, two kids only). For multi-scene operations (renumber, insert, delete), use mday-cascade instead. For drafting couplet alternatives, use mday-couplet instead.
---

# Mother's Day book — single-scene operations

## What this is

The book has 16 numbered scenes. This skill is for anything that operates on **one** scene — reading it, regenerating the md from a fresh template, or producing an image-generation prompt with cast and style locked in.

For multi-scene operations (insert, delete, swap, renumber), use **mday-cascade**.
For drafting new couplet wording, use **mday-couplet**.

## The locked cast (every image, every page)

Read `CLAUDE.md` in the project root for the full mental model. Critical rules to bake into every image prompt:

- **Mom**: beige hijab; sunglasses pushed up on her head most of the day; reading glasses only at story time; no glasses in the final scene.
- **Dad**: bearded, glasses, green shirt.
- **Yara**: older sister, dark hair in a high bun, white tee.
- **Lana**: younger sister, dark hair in a ponytail with a red bow, white tee.
- **Two children only.** Never depict a third child or an aunt — those are off-canon. Off-canon iterations live in `scenes/_archive/` and must not be surfaced.

## Operations

### Inspect scene N

Read `scenes/<N>-<slug>.md` and report:

- Scene number and title
- Time and location from frontmatter
- Characters in the scene
- Visual block (verbatim — this is what the illustration should show)
- Current couplet (verbatim)
- Image status: which `.jpg` files exist, whether the canonical image still bakes in an old longer couplet (very common — flag it), whether there are alts worth knowing about

If the user asks "what's in scene N", a 4-5 line summary is enough — don't dump the whole md unless asked.

### Regenerate the md

If the md got out of sync (wrong scene number in frontmatter, wrong image filename, missing couplet), rewrite it from this template:

```markdown
---
scene: <N>
title: <Title>
time: <Time of day>
location: <Where>
image: <NN-slug.jpg or null>
---

# Scene <N> — <Title>

**Characters:** <comma-separated cast>

**Visual:** <one paragraph describing what's in the picture, named objects, lighting, character poses>

**Couplet:**

> <line 1>
> <line 2>
```

Add a `**Status:**` or `**Alt takes available:**` block at the bottom only if relevant.

### Generate image prompt

When the user asks for an image-generation prompt for scene N, produce a single block they can paste into their image tool. Structure it as:

1. **Cast block** (always identical — paste the locked descriptions verbatim from above; never abbreviate or paraphrase).
2. **Scene block** — the visual paragraph from the md.
3. **Style block** — warm picture-book illustration, soft lighting, Palatino-friendly palette (warm cream, accent terracotta `#c1543a`), no text overlay (the deck adds the couplet on the front of the card).
4. **Constraints block** — "exactly two children: Yara and Lana. No aunt, no third child, no baby. Mom wears a beige hijab in every frame except the prayer scene where she wears a light jilbab."
5. **Composition note** — anything specific to this scene (single panel vs split, point of view, focal character).

The cast block is the single most important part. Most off-canon renders happen because the cast wasn't restated for the model. Restate it every time.

### Verify a generated image is on-canon

If the user shares an image and asks whether it fits, check:

- Exactly two children
- Mom: beige hijab? sunglasses position correct for time of day?
- Dad: beard + glasses + green shirt?
- Yara: high bun? Lana: ponytail with red bow?
- Setting matches the visual block?
- No text baked into the image other than what the visual block called for (food truck signage, etc.)

If it fails any of these, say so plainly and suggest what to retry. If it passes, suggest archiving any prior renders for this scene as `-altN.jpg` rather than overwriting.

## Working agreement

- **Scene mds are the source of truth for couplets**, not the deck and not the images. The deck is currently a mirror; many images have stale baked-in text.
- **Don't edit the couplet here.** If the wording needs to change, that's mday-couplet's job (it presents options to the user before committing). This skill assumes the couplet is already settled.
- **Never recommend deleting from `scenes/_archive/`.** That folder is the project's memory of what didn't work.
