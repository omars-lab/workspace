---
name: mday-cascade
description: Insert, delete, or swap scenes in the Mother's Day picture book at /Users/omareid/Workspace/git/mothers-day, atomically updating scene md files (frontmatter, headings, image filename) and the Reveal.js deck (data-scene, data-image) in lockstep. Use whenever the user asks to add a new scene, remove a scene, reorder scenes, or shift scene numbers in this book — even if they don't say "cascade". Triggers on phrases like "add a scene", "insert a page", "remove scene N", "swap N and M", "renumber", "shift everything after N up by one", or any pivot that affects more than one scene file at a time. Doing this by hand is error-prone (renames must run high-to-low, frontmatter and headings must match the new number, the deck must point at the new path) so always use this skill instead of editing files manually.
---

# Mother's Day book — scene cascade

## What this is

The book lives at `/Users/omareid/Workspace/git/mothers-day`. Scenes are numbered `01-`, `02-`, etc. and each has:

- A markdown source: `scenes/NN-slug.md` (frontmatter + heading + image filename + couplet)
- A canonical illustration: `scenes/NN-slug.jpg` (sometimes plus alts: `NN-slug-alt.jpg`, `-alt2.jpg`)
- A `<section>` in `revealjs/index.html` with `data-scene="N"`, `data-image="../scenes/NN-slug.jpg"`, `data-title`, `data-couplet`

When a scene is inserted, deleted, or moved, **all of the above must change in lockstep** for that scene and every scene whose number shifts. Renames must run high-to-low to avoid filename collisions.

This is the single most error-prone operation in the project. Doing it manually has bitten us — frontmatter saying `scene: 5` while the file is `06-...`, or the deck pointing at a path that no longer exists.

## When to use

Use this for any change to the *set* of scenes:

- "add a new scene about X between scenes 7 and 8" → insert at 8
- "drop the food truck scene" → delete the matching scene
- "swap dancing and prayer" → swap two scene numbers

Do **not** use this for:

- Editing a couplet inside an existing scene (just edit the md and the deck's `data-couplet`)
- Regenerating an image for an existing scene (filename doesn't change)
- Renaming a scene's slug without changing its number (rare; do by hand)

## Operations

### Insert at position N

Adding a new scene at slot N, shifting current N..end up by 1.

1. **Read the current scene set.** `ls scenes/` to find the highest scene number, e.g. last is 16.
2. **Rename high-to-low.** For k from highest down to N: rename `scenes/<k>-slug.{md,jpg}` and any `<k>-slug-alt*.jpg` to `<k+1>-slug.{md,jpg}`. Always high-to-low — going low-to-high collides.
3. **Update frontmatter and headings** in every renamed md: `scene: <k>` → `scene: <k+1>`, the `image:` field if it included the number, and the `# Scene <k> — Title` heading.
4. **Create the new scene's md** at `scenes/<N>-<new-slug>.md` with full frontmatter (scene, title, time, location, image — image can be `null` if not yet generated).
5. **Update the deck.** In `revealjs/index.html`:
   - Bump `data-scene` and `data-image` for every shifted section
   - Insert a new `<section>` for the new scene at the right position
   - Confirm the section ordering in the file matches scene number order

### Delete scene N

Removing scene N, shifting N+1..end down by 1.

1. **Move the deleted scene's files to `scenes/_archive/`** rather than `rm`-ing them. The user's iteration history matters; archived scenes can be referenced later.
2. **Rename low-to-high.** For k from N+1 up to highest: rename `<k>-slug` to `<k-1>-slug`. (Low-to-high is correct for delete because we're shifting *down*.)
3. **Update frontmatter and headings** in every renamed md.
4. **Remove the deleted scene's `<section>`** from the deck and decrement everything that shifted.

### Swap scenes N and M

Swap two scenes in place — files keep their slugs, only the numbers change.

1. Rename `<N>-slugA.{md,jpg}` to a temp prefix (e.g. `_swap-slugA.{md,jpg}`).
2. Rename `<M>-slugB.{md,jpg}` to `<N>-slugB.{md,jpg}`.
3. Rename `_swap-slugA.{md,jpg}` to `<M>-slugA.{md,jpg}`.
4. Update frontmatter, headings, and image fields in both mds.
5. Reorder the two `<section>`s in the deck and update their `data-scene` and `data-image`.

## Working agreement

- **Always read the deck and one renamed md after the cascade** to verify the changes look right. Drift is silent — a wrong frontmatter number won't break the deck.
- **`scenes/_archive/` is sacred.** Never delete from it. It contains off-canon iterations (third child, aunt, baby — we have a strict 2-kids rule) that must not surface in the book.
- **Cast and visual rules are locked** by `CLAUDE.md` in the project root. Read it if you don't already have it loaded — it tells you what counts as on-canon.
- **The deck has *two* non-numbered scenes** that bracket the numbered ones: the cover, dedication, thank-you, and closing. Never renumber those; they don't have `data-scene` attributes.
- **Image-baked text is normal.** Many `.jpg`s still show the *old* couplet wording baked in from the original 4-line drafts. The current truth lives in the md; image regen is a separate (later) pass.

## After every cascade

Output a short summary in this shape:

```
Cascade complete: <operation>
- Renamed N files
- Updated N md frontmatter/headings
- Updated N deck sections
Pending: <anything the user still needs to do — pick a couplet, regenerate an image, etc.>
```

This way the user knows what's locked and what's still loose.
