# Global rules (every repo on this machine)

Short, and every rule traces to a technique mined from real sessions
(`social-presence-hub/social/technique-candidates.md`). Repo CLAUDE.md files add to this; they
do not repeat it.

## When to stop and ask

Use AskUserQuestion at a judgment call, not for permission to proceed. A judgment call is one
where different answers lead to materially different work: a scope change, a choice between
approaches, anything that touches shared or published state, approving a candidate or decision.
Give 2 to 4 options, recommended one first, each with what it costs. Never ask "shall I
continue", "is the plan ready", or anything a careful colleague would just decide.

When the choice is over something with a shape (a layout, a wording, a diagram, a config), render
the options first and let the person decide from the rendered comparison, not a wall of prose:
put each option in the AskUserQuestion `preview`, or build the artifact, before asking. Once the
call is made, write the decision and its reason where the work is tracked (the plan, the backlog,
a decision line), so the next session inherits the choice instead of re-litigating it.

## Memory

Save confirmations, not only corrections. "Yes, keep doing that" is feedback worth a memory
file as much as "no, do it this way"; without the confirmations the memory is a list of
mistakes and the approaches that were right have to be rediscovered. Type `feedback`, with the
why.

## Delegation

Fork (subagent_type `fork`) for a side-quest whose tool output will not be needed again in the
main thread: research, a batch scan, a review. Start a fresh agent only when the conversation
context should not be inherited. Never re-run a search you delegated.

## Skills

A skill that does not fire when it should: read its frontmatter `description` first. That
line is the dispatch prompt; an empty or vague one means the skill never auto-triggers. Fix the
description before touching the body. A skill that needs a rubric keeps it in a file next to
`SKILL.md` and reads it at run time, so the rubric can sharpen without the skill changing.

## UI bugs

Look at the actual render before reasoning from source. A screenshot or a browser tab settles
in seconds what reading CSS and component code only guesses at.

## Spot-check what OCR mangles, with your own eyes

OCR fails silently and precisely on the hardest glyphs — transliteration diacritics (ū vs ü, ḥ, ʿ),
ligatures, small-caps — and returns near-nothing on image pages (maps, cover art, illuminated
plates), all at high confidence. A match-rate or confidence score cannot catch this; only looking
can. When a pipeline OCRs pages, open a sample of the actual page images yourself (read the PNG) and
compare glyph-for-glyph against the extracted text — always including the pages OCR struggles with
most (diacritic-dense prose, image/plate pages, column boundaries), never only clean body text.
Write down what you saw. This is how you learn whether the OCR noise reaches the output or is
confined to a secondary channel, and it catches errors the primary channel introduces too (e.g. AX
text dropping spaces at italic boundaries) that no automated score flags.

## Git in shared working trees

More than one session is often open in the same checkout. Before any commit run
`git branch --show-current`. Stage files by name; another session's modified or untracked
files are not yours to stage, restore, or delete. Never `git add -A`, never `git restore .`,
never range cherry-pick (`A..B`). A second concurrent session gets its own worktree
(`git worktree add ../<repo>-<name> <branch>`).

## Checkpoint before trying new things

Before a change that could lose work — a rewrite, a risky refactor, swapping out a working approach
for a new one — commit the current good state first, so there is a clean point to return to. If the
repo is not yet a git repo, `git init` and make that first checkpoint before experimenting. Keep
generated or sensitive artifacts (extracted content, build output, virtualenvs) gitignored so a
checkpoint never commits them. A checkpoint is cheap; re-deriving lost work is not.

## Document the pivots

When an issue forces a change of approach — a signal turns out unreliable, an assumption breaks, a
design has to be reworked — write it up in `docs/issues/<slug>.md` in the repo (not only in memory):
what was tried, what the evidence showed, why the approach changed, and what replaced it. One file
per issue. This is the durable trail a future session (or a reviewer) reads to understand why the
code looks the way it does, so a dead end is never re-explored. Memory notes are for cross-session
recall; `docs/issues/` is the in-repo record that ships with the code.

## Node

Repos with a `.nvmrc` mean it. Check it before running scripts; bare `node` here is v18 and
fails on modern syntax with unrelated-looking errors. `nvm use`, or
`export PATH="$HOME/.nvm/versions/node/v20.20.2/bin:$PATH"`.

## Local equivalents of automated checks

When a repo has CI or hooks, each check has a `make` target that runs the same command, and CI
calls the target rather than duplicating the command. If a check passes locally and fails
remotely, fix the drift, not the symptom.

## Observability for long-running scripts

A script left running and monitored must emit structured, greppable logs, not silence. Every long
loop (a live capture, a batch, a sweep) logs to a file with, on each line: a UTC timestamp, the
`pid`, and a machine-parseable `ev=<event> key=value` shape (space-free keys/values; free text in a
quoted `msg="..."`). Emit a heartbeat around any call that can block — one line *before* the risky
call and one *after* — so a stall is bracketed and `grep "ev=turn" log | tail -1` shows exactly
where it froze. Monitor by grepping that log, never by guessing from file mtimes or `ps`. Any
subprocess that can hang (screencapture, osascript, a network call) gets a timeout that logs
`ev=*_timeout` and recovers, so one blocked call cannot freeze the run for minutes.
