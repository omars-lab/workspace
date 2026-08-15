---
name: mday-couplet
description: Draft 5-7 numbered couplet options for a scene in the Mother's Day picture book at /Users/omareid/Workspace/git/mothers-day, in the kid-narrator voice the project uses. Use this skill whenever the user asks for couplet options, alternates, rhymes, or rewordings for any scene in this book — phrases like "give me options for scene N", "rewrite the food truck couplet", "find better rhymes", "this one's too generic", "more options", "what else could it be". Also use when proposing a couplet for a brand-new scene that was just added. Do not use for editing prose elsewhere in the project (mds outside the couplet block, README, CLAUDE.md). The user iterates one scene at a time and wants to *pick* a number, not have one chosen for them, so always present options and a recommendation rather than committing unilaterally.
---

# Mother's Day book — couplet drafting

## What this is

The book is 16 illustrated pages, told from the kids' (Yara's and Lana's) point of view. Each page has a 2-line rhyming couplet (occasionally 4 lines for an emotional beat). Couplets are the **soul of the book** — they're what Mom will actually read. The illustrations are gorgeous but couplets carry the voice.

Couplet drafting is iterative. The user does **not** want one polished couplet committed silently. They want to see options, weigh them, and pick. This skill exists to make that loop fast and consistent.

## House rules (these aren't suggestions)

These are pulled from `CLAUDE.md` in the project root and from the user's repeated corrections during drafting. Read `CLAUDE.md` for the full mental model if you haven't.

**Voice:**
- The narrator is the *kid*, not the parent. Use words a 5-year-old would actually say. "Mom" not "mother". "Yum yum" is fine. "With all our hearts" is not.
- Name what's *in the picture*. Eggs, glasses, lipstick, prayer rug, toothpaste, food truck. Concrete beats abstract every time.
- One emotion per page. Don't pack joy + nostalgia + gratitude into two lines. Pick one.
- Mom is usually the rhyme word the kid would land on. Build the couplet around her.

**Form:**
- 2 lines, rarely 4. If proposing 4, flag it explicitly — the user has to opt in.
- Rhyme when it lands naturally. Slant rhyme is fine. Don't strain — a forced rhyme is worse than no rhyme.
- **No em-dashes (`—`) in couplets.** Use ellipses (`…`) for pauses. The user has corrected this multiple times. (Em-dashes elsewhere in the project are fine — this rule is couplets only.)
- Short. Each line should fit on one card without wrapping awkwardly at `font-size: 0.7em` in the deck.

**Anti-patterns to avoid (the user has flagged these specifically):**
- Hallmark abstractions: "loving guide", "with all our hearts", "shines bright"
- Generic awe: "Mom is the best", "we love you so much" — too flat
- Strained rhymes that warp meaning: don't rhyme `cup` if there's no cup in the picture
- Two emotions stuffed into two lines

## How to draft

When the user asks for couplet options for scene N:

1. **Read the scene's md** at `scenes/<N>-<slug>.md`. The `**Visual:**` block tells you what's in the picture; the `**Couplet:**` block (if any) is the current state.
2. **Read `CLAUDE.md`** if you haven't this session, to refresh the arc beat for that scene (e.g., scene 8 is the imitation triplet — playful, not somber).
3. **Generate 5-7 options.** Vary along these axes so the user has real choices, not minor rewordings:
   - Rhyme target (Mom, room, day, hand, smile, etc.)
   - Mood (silly vs tender vs proud vs awed)
   - Concrete object the line lands on (eggs vs the stove vs the smell)
   - First-line vs second-line emphasis (does the surprise come early or late?)
4. **Number them 1-7 in a list.** Use the deck's voice: short, kid-narrator, no em-dashes, ellipses for pauses. Format each as a 2-line block (or 4 if the scene calls for it).
5. **Recommend one with one sentence on why.** Then optionally a runner-up. The user usually wants your taste, but reserves the right to override — make the call clearly so they have something to react to.
6. **Stop and wait.** Do not write to the md or the deck until the user picks a number (or asks for another round).

## Example shape

```
Scene 8 — Beirut Food Truck. Visual: red food truck, cook hands Mom a sandwich, kids reach in. Beat: heritage / "tastes like home".

Options:
1.  Mom orders for us, we wait in line.
    Lebanon on a plate… and it's all mine.

2.  The bread is warm, the spices smell like Mom.
    Home travels with us, even from Beirut.

3.  Mom says "shawarma" with a smile.
    We say it back, mouths full and happy.

4.  ...

My pick: #1 — concrete (line, plate), the kid voice ("all mine") lands, and "Mom"/"line" is a real rhyme not a slant. Runner-up: #3 — quotes the kid's actual delight, less wide but more vivid.

Want #1, or another round?
```

## When the user picks

After they pick a number, write the chosen couplet into **both**:

1. The scene md's `**Couplet:**` block at `scenes/<N>-<slug>.md`
2. The deck's `data-couplet=` attribute for that scene in `revealjs/index.html`

Until the deck is rewired to read couplets from the mds, both must be edited together. Drift between them is a real bug — the deck shows what Mom will see; the md is what we use to discuss.

## When to push back

If the visual and the user's requested mood don't match (e.g., they ask for a tender couplet on a chaos scene), say so in one sentence and offer both options anyway. Don't override silently.
