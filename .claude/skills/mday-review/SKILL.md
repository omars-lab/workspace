---
name: mday-review
description: Holistic review of the Mother's Day picture book at /Users/omareid/Workspace/git/mothers-day. Reads every couplet in order and judges the book as one continuous poem. Two modes — (A) Diagnostic review flags broken lines, voice drift, structural blur, missing concrete detail, and arc problems; (B) Post-fix wholistic read describes how the book reads now after a batch of edits, citing arc, voice, concreteness, opener/closer, and any structural shifts. Use Mode A when the user asks "review the book", "does this make sense?", "any gaps?", "is this ready?", "do a pass". Use Mode B when the user asks "how does the whole story read now?", "read it through", "how does it feel as a whole?", or after mday-couplet has just locked changes to multiple scenes. Also offer this skill proactively after a batch of couplet edits or scene insertions, since drift is silent — individual couplets can each pass mday-couplet's house rules while the *book* still has problems. Do not use this for single-couplet drafting (that's mday-couplet) or scene insertion (that's mday-cascade).
---

# Mother's Day book — holistic review

## What this is

Each couplet in this book is drafted in isolation through `mday-couplet`. The house rules there (kid voice, no em-dashes, name what's in the picture, rhyme when natural) keep individual couplets clean. But a book is not a list of independent couplets — it's a sequence Mom will read top to bottom in five minutes.

This skill exists because **drift is silent**:

- Two adjacent scenes can both pass the house rules and still feel like the same scene twice.
- One couplet can be in adult-poet voice while every other one is kid-voice, and you won't notice unless you read them all in a row.
- A scene can be technically fine but say nothing specific to its picture — and you'll only notice when you ask "wait, where is the *food truck* in scene 9?"
- The book's arc (want Mom → get Mom → imitate Mom → end with Mom) can erode as scenes are inserted, without any single insert breaking it.

The user has explicitly asked for this kind of holistic check. Do it like a writer reading a galley proof, not like a linter.

## When to use

- **Direct ask:** "review the book", "does this make sense as a whole?", "do a pass on the whole thing", "any gaps?", "read it through and tell me what's off".
- **Proactive offer:** After 3+ couplets get edited in one session, or after `mday-cascade` inserts/removes scenes, or after a batch of `mday-couplet` rounds. End the response with: "Want me to do a full read-through and flag anything that's off across the whole book?"
- **Before image regen passes:** If the user is about to regenerate all the illustrations (which bakes in the couplets), this is the last chance to catch text issues. Suggest it.
- **Before printing / gifting:** Same logic — last sanity check before the words become permanent.

Do **not** use this skill for single-couplet drafting. If the user is asking "options for scene N", that's `mday-couplet`'s job.

## How to do it

### 1. Pull every couplet in scene order

Read the deck (`revealjs/index.html`) — it has all 19 couplets inline as `data-couplet` attributes, ordered. Don't read 19 separate md files; the deck is the consolidated view.

Lay them out in your response as a numbered list, scene-by-scene, **with titles**, so the user can see the same view you're judging.

### 2. Read it as one poem, top to bottom

Don't grade them one at a time. Read the whole thing through *once* without analyzing — get a vibe for the flow. Then read it a second time looking for specific problems below.

### 3. Flag these specific issues

These are the failure modes that have actually happened in this project (or that I'd expect to happen given the project's voice). Look for them in this order:

**Broken lines.** A line that doesn't scan when read aloud, or where word order is forced for a rhyme that doesn't actually land. *Symptom:* you'd stumble reading it. *Example:* "We pack ours too, just like Mom we do" — "Mom we do" is forced; shades/do is nothing.

**Voice drift.** A couplet that reads like an adult narrator, not a 5-year-old. *Symptom:* vocabulary like "the cure", "divine", "wherever we roam" — words a kid wouldn't say. The narrator across the book is Yara/Lana; if a couplet sounds like it's quoting a poet, flag it.

**Structural blur.** Two or more adjacent couplets that share the same syntactic mold ("Mom does X / we do X too"). One pair is fine; back-to-back is repetitive. *Watch especially* the imitation triplet (currently scenes 11-12-13) — these are *supposed* to share a mold by design, so the rule is: at least one of the three should break the pattern to keep them from blurring.

**Missing concreteness.** A couplet that could describe any scene because nothing in it is in the picture. *Test:* if you covered the page number, could you tell which page this is? If not, it's too thin. *Example:* "Mom knows the way. We just hold her hand." could be a trail, a parking lot, a hallway — nothing names the trail.

**Mom-as-rhyme-word missed.** The house rule is Mom is usually the word the kid would naturally land on. If a couplet rhymes two non-Mom words and Mom doesn't appear, that's a mild flag — fine if there's a reason, worth questioning if not.

**Em-dashes in couplets.** Always wrong. Use ellipses. (This rule is couplets only; em-dashes elsewhere in the project are fine.)

**Arc breaks.** Read the titles in order against the arc beats in `CLAUDE.md`. Did inserting/removing a scene break the rhythm of *want Mom → get Mom → imitate Mom → end with Mom*? Did the imitation triplet (glasses → vanity → prayer, escalating outer-to-inner) get interrupted?

**Opener / closer energy.** The first couplet should *invite* the reader in; the last couplet should *close* the book. If either reads like a placeholder caption, flag it.

**4-line couplets.** The book defaults to 2 lines. A 4-line couplet should be flagged on review — not necessarily wrong, but the user has to opt in. Currently scene 17 (Tickle Attack) is the only intentional 4-line. If a second one shows up, ask whether it's intentional.

**Sandbagged abstractions.** Hallmark phrases: "with all our hearts", "loving guide", "shines bright", "tastes of love", "the brightest of days". If any have crept in, flag.

### 4. Write the review

Structure it as three sections:

1. **What works** — 3-5 bullets. Be specific about *why* (which couplets, which transitions). Not generic praise.
2. **What I'd flag** — numbered list, ordered by severity (broken > voice drift > structural blur > thin > nice-to-have). For each, name the scene number, quote the line, say what's wrong, suggest direction (not full rewrite — that's `mday-couplet`'s job).
3. **What I'd do** — separate the *broken* (must fix) from the *stylistic* (nice to have). Recommend a specific next-step order. Don't give the user a 12-item to-do; pick the 2-3 highest-impact fixes.

Be honest. The user has explicitly said "Hallmark abstractions" and "generic awe" are anti-patterns; if you find them, say so plainly. Praising a weak couplet to be nice is worse than naming the issue — you'll just have to revisit it when they regen images and the bad line is now permanent in the picture.

### 5. Stop

Do not edit any couplets in this skill. Reviewing is separate from drafting. If the user wants to fix a flagged issue, they'll invoke `mday-couplet` for that scene next. Offer to drive that loop, but don't unilaterally rewrite.

## Two modes of this skill

There are two distinct read-throughs this skill performs. Both lay out the full sequence first, but they answer different questions.

### Mode A — Diagnostic review (default)

The user is asking "what's wrong?" Run the failure-flagging pass above (broken lines, voice drift, structural blur, thin couplets, arc breaks, opener/closer energy). Output the three sections: What works / What I'd flag / What I'd do.

Triggers: "review the book", "any gaps?", "is this ready?", "do a pass".

### Mode B — Post-fix wholistic read

The user has just landed a batch of edits and wants to know how the whole book reads *now*. This is **not** a failure hunt. It's a positive read of the book as one continuous poem — does the arc still hold, does the voice stay consistent, does concreteness pass the cover-the-title test, does the opener invite and the closer close, did any structural beat (like the imitation triplet) shift in a way worth noting.

Triggers: "how does the whole story read now?", "read it through", "how does it feel as a whole?", and any read after `mday-couplet` has just locked changes to multiple scenes in one session.

Output structure:
1. **The full sequence** laid out scene-by-scene with titles (same as Mode A — it's the user's view).
2. **How it reads now** — 4-6 short paragraphs (not bullets), each making one positive claim about the book and grounding it in specific scenes:
   - The arc holds (or doesn't): trace beats by scene number.
   - The voice is consistent: confirm no adult-poet drift survived.
   - Concreteness check: cover the titles and try to place each page from the words alone — list the concrete objects the words name.
   - The opener invites / the closer lands.
   - Any structural shift worth noting (e.g., a triplet became a quartet because of insertions — say whether that's better, worse, or neutral, and recommend whether to leave it).
3. **Ready / not ready** — one line at the end. Don't manufacture problems; if it reads well, say so plainly.

Mode B is honest praise where earned, not generic. Each claim must cite a scene number or a specific line. "The voice is consistent" is worthless without "every couplet now sounds like a 5-year-old narrating" backed by examples.

## Worked example — Mode B output

Real output from a review of this book on 2026-05-03, after a batch of edits to scenes 1, 5, 7, 8, 19. Use this as the standard for what a Mode B response looks like.

> **The arc holds.** *Want Mom (1-2) → get Mom (3-4) → care from Mom (5-6) → out into her world (7-9) → orbit and imitate Mom (10-13) → silliness and waiting (14-16) → climax of love (17-18) → coda (19).* Each transition has a reason; nothing's filler.
>
> **The voice is consistent.** Every couplet now sounds like a 5-year-old narrating. No adult-poet lines left. The two cookies-cookies / spot-spot internal echoes (5, 8) are deliberate kid-voice repetition, not strain.
>
> **Concreteness is solid.** I just covered the titles and read each couplet — I could place every page from the words alone. *Coffee, cookies, eggs, keys, basket, sandwiches, glasses, queen-dress, lipstick, prayer-hands, gigglier, toothpaste, gift-heart, two-cups-of-tea.* Mom will see the picture in the words before she sees the picture.
>
> **The closer lands.** "Mom and Dad… and us, dreaming nearby" pulls the whole book together — they wanted Mom on page 1, and on page 19 they're with her even in sleep.
>
> **The opener now invites.** Birds + sleep is concrete, the kid voice is set on line 1.
>
> **One small note:** the imitation triplet shifted to scenes 10-11-12-13 (glasses → queen-dress → lipstick → prayer) because of insertions. That's a *quartet* now, escalating outer-to-inner: vision → outfit → face → faith. It still works — arguably even better, since the dress beat is the hinge between "looking out" and "looking in." Don't change it.
>
> **Ready to print** when the images are done.

Note what this example does: cites scene numbers in every claim, performs the cover-the-title test out loud, names specific concrete objects, surfaces a structural shift (triplet → quartet) and *evaluates* it rather than just flagging it, and ends with a clear ready/not-ready verdict.

## Working agreement

- **Read the deck, not 19 md files.** The deck is the consolidated view; it's faster and matches what Mom will see.
- **Always lay out the whole sequence in your response** before flagging. The user might disagree with your reading and that's faster to work with if you've shown your input.
- **Severity matters.** A broken line that doesn't scan is *not* the same as a couplet that's slightly thin. Don't flatten the list; the user needs to know what's actually broken vs. what's just a polish opportunity.
- **Trust the kid voice as the spine.** When in doubt about whether something is "off", read it aloud as if a 5-year-old were saying it. If you'd stumble or it sounds wrong in that voice, flag it.
- **`CLAUDE.md` is the arc reference.** Re-read it if the arc beats aren't fresh.
