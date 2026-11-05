# Global rules (every repo on this machine)

Short, and every rule traces to a technique mined from real sessions
(`social-presence-hub/social/technique-candidates.md`). Repo CLAUDE.md files add to this; they
do not repeat it.

## Speak plainly

Everything a person reads is written in plain everyday words. That covers chat replies, AskUserQuestion
questions and their options, PR titles and bodies, commit messages and backlog lines. Write it so
someone who missed the last three sessions could act on it.

- **No house shorthand.** Say what the thing is, not its internal name:
  - "the page the store owner opens from the link", not "the share overlay";
  - "the starforgesystems review from Oct 11", not "run 143";
  - "mark that finding as not an issue", not "triage seq 19".

  A ledger id (`#471`) or a file path can sit alongside the explanation, but never replaces it.
- **One idea per sentence, the point first.** Lead with what happened or what you need, then
  give the detail.
- **Options read like choices, not specs.** Each AskUserQuestion option says in plain words what
  happens if you pick it. The pros/cons/implications rule below still applies, in plain words.
- **When one of our terms can't be avoided,** explain it in a few words the first time.

(Omar, 2026-10-12: "lots of jargon". This came after Omar had to ask what a question about sharing a
store report meant, because it was written in internal shorthand. The 2026-09-21 rule below says
the same thing, but it sat inside the wiki section and read as wiki-only.)

## Two modes: compiler for the graph, author for the wiki

Match the machinery to what you are building, and say it in plain words either way.

- **Graph = compiler mode.** Facts and provenance that must typecheck. Gates, invariants,
  refusals earn their place here, because a wrong fact ships silently and someone downstream
  pays for it.
- **Wiki = author mode.** You are writing a knowledge base — pulling the concepts and ideas
  into the right folders and interlinking them, so it reads like a notebook, not a database.
  The work *is* the writing and the links. Do not wrap prose in citation, projection, gate or
  board plumbing; that is compiler mode on the wrong surface, and it is the over-engineering to
  cut.

Across both: **kill the jargon** (see "Speak plainly" above). No "vacuously green", no
"projection re-derivation". And keep the
**top goal** in front: the useful, interlinked knowledge base that feeds prospect decks, not the
machinery around it. When a task drifts into plumbing that does not move the top goal, stop and
get back to the goal. (Omar, 2026-09-21: "compiler mode for graph building, author mode for
wiki"; "simplify your lingo, kill the jargon, and focus on the top goal" — after a wiki page got
over-built into citation/gate/graph-projection machinery.)

## When to stop and ask

Use AskUserQuestion at a judgment call, not for permission to proceed. A judgment call is one
where different answers lead to materially different work: a scope change, a choice between
approaches, anything that touches shared or published state, approving a candidate or decision.
Give 2 to 4 options, recommended one first. Never ask "shall I continue", "is the plan ready",
or anything a careful colleague would just decide.

**Every option carries its pros, its cons, and its implications — never just a label and a cost.**
(Omar, 2026-09-21: "pros/cons, implications, etc — this should be a tenet on presenting
options/decisions.") For each option say what it buys you (pros), what it costs or risks (cons),
and what it commits you to or rules out downstream (implications — the next decision it forces,
the door it closes, who it affects). A one-line label with a bare cost is not a decision aid; the
person is choosing between *consequences*, so lay the consequences side by side — a rendered
comparison (a small table, or each option's `preview`), not a wall of prose. Say which you
recommend and why, in one line. This holds for a quick in-chat AskUserQuestion as much as for a
checked-in decision record.

When the choice is over something with a shape (a layout, a wording, a diagram, a config), render
the options first and let the person decide from the rendered comparison, not a wall of prose:
put each option in the AskUserQuestion `preview`, or build the artifact, before asking. Once the
call is made, write the decision and its reason where the work is tracked (the plan, the backlog,
a decision line), so the next session inherits the choice instead of re-litigating it.

**Bias to action over asking. Reserve AskUserQuestion for the genuinely pivotal, one-way-door
call** — the choice that is expensive or irreversible to undo (a *large or irreversible* spend, a
scope fork, touching shared/published state, a decision that sets direction). Low-spend/high-ROI
spend is **not** one of these — see the next section. For everything else, DON'T ask: make the
reasonable assumption, state it, do the work, and produce something reviewable — a render, a diff,
a draft — then get quick feedback on the artifact. Editing a local config, drafting wording,
re-running a render: all cheap and reversible, so just do them and show the result rather than
asking to proceed. A two-way door (easy to reverse) is never worth a question. Track the
assumptions you made inline so the review is honest, and let the reviewable output — not a prior
round of questions — be where correction happens. Perfect coverage of every branch via questions
is the anti-pattern; a fast reviewable draft with its assumptions named is the target.

## Spend is not the gate; ROI is

**Low-spend / high-ROI work is auto-approved. Do it — do not ask, and do not offer it as a
decision.** A handful of documents on a $0 local model or a few cents of API is not a choice to
surface; presenting an auto-approved spend as an option, or ranking a no-spend make-work task
above it to dodge a bill, is itself the anti-pattern. Nobody has to say "go" for cheap, valuable
work — just ship it and show the result. Only a genuinely *large* run earns a priced heads-up
before it runs (state the magnitude, then proceed), and only a specific *method/feasibility*
constraint the user set (e.g. "no full-corpus sweep") is actually off the table.

**Spend must never drive priority.** Rank work by what moves the top goal, highest ROI first;
whether a task costs money is not a factor that moves it up or down. Do not prefer a task because
it is free, and do not defer one because it is paid — pick by ROI, then spend whatever that task
needs. (Omar, 2026-09-13 "spend is authorized" as a standing default; 2026-09-22 "why are we
spend resistent? who told you to avoid spend? all low spend high roi are auto approved on my end"
— after I framed a cheap new-prospect extraction as needing a spend GO and ranked make-work
above it.)

## Backlog order: ship by feature ROI

When continuing through a backlog with no order the user imposed, take items in **feature ROI
order** — value delivered per unit of effort and risk, highest first. A quick win that completes a
partially-built feature outranks a large, risky, net-new surface even when the latter's total value
is higher; small reversible polish outranks a one-way-door rewrite. Don't ask which to take next
(that's "shall I continue" in disguise) — state the ROI ranking in one line, do the top item, ship
it, and move to the next. Check in only when a genuine priority fork appears: a one-way door, a
scope change, or spend. (Omar, 2026-09-20: "continue in feature ROI priority order" — make it the
default, not a question.)

**ROI over cheap work.** Quick items feel like progress because they close fast, but a count of
closed items is not the goal. Before picking, look at the whole picture: what is still open, by
kind, and what the goal actually needs. Then take the work that moves the goal most per unit of
effort, even when it is slower than the item at the top of the list. Cheap fixes fill the gaps
around that work; they are never the whole session while the goal-moving work waits. When the same
kind of item keeps coming back, fix the kind once (in the generator, the source, the template) or
close it with a stated reason, rather than clearing it one at a time forever. (Omar, 2026-09-26:
"roi over cheap work should be a tenet" — after wiki-health ticks closed ~22 cheap link and label
findings each while 431 data gaps, 60% of the open total and the facts decks need, sat untouched.)

## Memory

Save confirmations, not only corrections. "Yes, keep doing that" is feedback worth a memory
file as much as "no, do it this way"; without the confirmations the memory is a list of
mistakes and the approaches that were right have to be rediscovered. Type `feedback`, with the
why.

## Delegation

Fork (subagent_type `fork`) for a side-quest whose tool output will not be needed again in the
main thread: research, a batch scan, a review. Start a fresh agent only when the conversation
context should not be inherited. Never re-run a search you delegated.

**Research that decides something: two researchers, then a checker.** When the answer to an open
question will change what gets built or printed, and it comes from outside sources (web research,
a survey of how others do it), do not trust one pass:

1. **Two researchers, independent.** Start two *fresh* agents (not forks — a fork shares your
   framing) on the same question with the same facts, in parallel, each in its own worktree. Each
   writes its raw findings (sources, and whether each page was actually fetched or only seen as a
   snippet) and its own design doc, and commits both on its own branch and PR. Neither reads the
   other's files.
2. **One checker, after both finish.** A third agent reads both docs, re-opens the sources behind
   the load-bearing claims, marks where the two agree, where they disagree (and which side the
   source supports), and what only one found. It writes the consolidated doc, which becomes the
   one to act on, and the two research docs stay as the record it was built from.

Agreement between two independent passes is evidence; a claim only one found, or that rests on a
snippet, is flagged rather than dropped or trusted. (Omar, 2026-09-26: "this pattern of 2 research
plus one review consolidation agent should be a pattern we document" — first used for the
coaster print-quality research: pinholes, a wide peg border, pegs too tight.)

## Skills

A skill that does not fire when it should: read its frontmatter `description` first. That
line is the dispatch prompt; an empty or vague one means the skill never auto-triggers. Fix the
description before touching the body. A skill that needs a rubric keeps it in a file next to
`SKILL.md` and reads it at run time, so the rubric can sharpen without the skill changing.

**A skill's scripts live in its own folder.** Put each script in `.claude/skills/<skill>/scripts/`,
not a shared top-level `scripts/`, and give SKILL.md a "Scripts — when to use each" table (script,
what it does, when to reach for it, the exact command), updated in the same change as the script.
Only helpers several skills share stay in `scripts/` / `scripts/lib/`; skill scripts import them by
walking up to the repo root. Hooks and Make targets call the script at its skill path. (Omar,
2026-10-03: "remember this script approach as a standard way of dealing with scripts and
incorporating them into skills" — after the nature-guide scripts moved into their skill folder.)

## Dogfood what we publish

When a blog page hands readers a tool (a gist, a Homebrew formula, setup steps), Omar's own
machines install and run it **the same way the page tells readers to**: the same download, the
same commands, the same version. Once the public path exists, there is no private shortcut, such
as a `make` target that copies the script out of our repo. If the reader's steps break for us,
they are broken for readers, so fix the public steps and the page, not our install. Before a page
with setup steps goes live, run those steps word for word ourselves. (Omar, 2026-10-30: "make sure
our reminders are installed same way blog audience installs it" — the cache reminder was
installed from the repo with `make cache-nudge-install` while the page told readers to download a
gist.)

## UI bugs

Look at the actual render before reasoning from source. A screenshot or a browser tab settles
in seconds what reading CSS and component code only guesses at.

## Manual computer use: drive the GUI when the harness can't

Some steps have no scripted path — a first-run "trust this vault" dialog, an app's vault
switcher, a native file picker. When the CLI/eval harness can't reach one, drive the GUI by
hand, but disciplined:

- **Front the app, then act.** `osascript -e 'tell application "Obsidian" to activate'`.
  Keystrokes via `osascript -e 'tell application "System Events" to key code 53'` (Escape) /
  `key code 36` (Return); coordinate clicks via `/opt/homebrew/bin/cliclick c:X,Y`. Electron
  web-content buttons are **not** native AX — `click (button whose name contains …)` fails on
  them, so use cliclick coordinates, not AXPress.
- **Screenshot before AND after every click — never blind-press.** `screencapture -o -x
  <png>`, read the PNG, locate the target, click, screenshot again to confirm. This is the
  "look at the actual render" rule applied to your own hands: a button may have moved, or a
  prompt may be overlaying your target.
- **Convert display coords to screen points.** `screencapture` writes a Retina PNG (e.g.
  3024×1964) but cliclick wants screen points (1512×982, a 2× display). When you read a shot
  rendered at 2000px wide, `screen_point = displayed_coord × 0.756` (= coord × screenPtsWide /
  2000). Get this factor right once per display or every click lands off-target.
- **macOS TCC prompts hijack focus.** An `osascript` that controls *another* app (Finder
  bounds, System Events on a new target) can pop a one-time "X wants to control Y" dialog that
  overlays your target and eats the click. The before/after screenshots catch it; dismiss it
  ("Don't Allow" is fine), then retry the real click.
- **Isolated app instances have their own config.** A harness app launched with a custom
  `--user-data-dir` reads its *own* registry there (Obsidian: `<user-data-dir>/obsidian.json`),
  not your normal one. To open or switch to a vault it doesn't know, add it there (path + ts +
  `open:true`) — and the registry is cached in memory, so **quit and relaunch** for the edit to
  take.

(Omar, 2026-09-22: "add to claude md and capture technique in relevant skill when facing these
manual computer use issues, add examples" — after proving the version stepper against the real
git-tracked docs vault meant registering the vault in the harness Obsidian's isolated
`obsidian.json`, relaunching, and clicking through the first-run trust dialog via cliclick,
dismissing a TCC overlay on the way. That real-vault run also caught a git cwd/pathspec bug the
synthetic `.dev-vault` had masked — the payoff of verifying against real state, not a fixture.)

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

**One working worktree per repo per session, reused.** Once a PR merges, start the next branch
in the same worktree (`git switch -c <next> origin/<main>`) instead of adding another; add a
second only for work running at the same time. When a PR merges, remove its worktree and local
branch in the same step, unless a session is still using it. Standing worktrees other sessions
use (e.g. 3d-models' `-pm`, `-master-ro`) are left alone. (Omar, 2026-09-26: "why are we
creating so many?" — after 8 merged worktrees had piled up across 3d-models and bikar, one per
PR, none removed.)

**Work every conflict by hand.** A merge, rebase or cherry-pick conflict is resolved by opening
the file, reading both sides, keeping both intents and re-running the gates — then `git add` that
file by name and continue. Never `-X ours`/`-X theirs`, `-s ours`, `checkout --ours`/`--theirs`,
`merge-file --ours`/`--theirs` or a `merge=ours` driver: each discards one side's work silently,
usually the other session's, and nothing downstream notices. Never regenerate or overwrite a
conflicted file, and never close-and-recreate a PR to dodge a conflict; when a force-push is
denied, a fresh branch off main is fine, but the conflict itself is still worked by hand on it.
The `guardrail-manager` plugin's `block-git-ours-theirs` hook denies the flags; the rest is on
you. (bikar #205→#206, 2026-09-17: both PRs added to the same doc section — both kept.)

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

## Fix what's broken even if it's not ours

When work is blocked by something broken that you didn't cause — a flaky test, a leaky check, a
gate that trips on the environment rather than the change — fix the actual breakage; don't route
around it with `--no-verify`, a skip, or a bypass. A gate exists to catch real regressions; every
bypass erodes it and leaves the same trap for the next session. "Not in scope" and "not my bug" are
reasons to keep the fix small and well-documented (`docs/issues/<slug>.md`), not reasons to skip it.
A pre-existing environmental failure is still a failure someone has to own — own it. The bar for a
bypass is high: the user explicitly says to, or the fix is genuinely another team's to make and you
say so out loud rather than silently stepping past the gate.

## Run one simple command, not a compound one

Every invocation should be a single, allow-listable command, because one that is not on the
allow list stops the session for a prompt — and three habits make a command un-listable, all
avoidable:

- **`cd` then run.** The shell's working directory is already the repo root; `cd /path && …`
  is redundant *and* the `&&` makes the whole line a fresh string that never matches the list
  (and `cd` in a compound can prompt on its own). Run the tool by its path from where you are.
- **Gratuitous pipes and redirects.** `… 2>&1 | tail -20` makes every call unique. Let the tool
  print and read its output; pipe only to filter a genuine firehose, knowing it forfeits the
  match.
- **Heredoc throwaway scripts.** `cat > /tmp/x.py <<'PY' … PY && python /tmp/x.py` is a second
  copy of something a real tool should do — a new command every time and a rule kept in two
  places. When you reach for an inline script to inspect, render or measure, that is the signal
  to push the variation into the tool as a **parameter** — a path, a scope, a flag — so the call
  site stays one stable command: `tools/wiki_render.py --scope <slug> --out <dir>` beats a
  heredoc that opens the store and calls `write()` itself.

This is invariants 7 and 8 applied to the shell: the difference goes into the tool as data, and
the call site is small, obvious and reusable. A true one-off is fine — say so and expect the
prompt; just don't let one-offs be the default shape of the work.

## Checks about the repo ask at session start; reminders about the session stay at Stop

A check whose answer is about the **state of the repo or the machine** (an index behind the files
on disk, a token expiring, a missing conf) runs in a SessionStart hook. When it finds something,
the hook prints an instruction to ask the person up front with AskUserQuestion: fix it this
session, or not this session, each option with what it costs and what stays stale. The decision
is made before any work leans on the stale thing, and the person hears about it once. A reminder
whose trigger is **what this session did** (touched a ledger, pushed without a retro note, ended a
stretch of work) stays a Stop hook, because only the transcript can say it. A hook that prints
nothing when all is well must print something different when it could not run: a silent hook is
indistinguishable from a passing one, and the hub's index check was silent for weeks because a
symlinked path broke its script. Run every new hook once through each path it is reached by.
(Omar, 2026-11-03: "can we shift this hook to a session start hook ... nudges us to use ask
question tool at start of session if we detect things are stale"; "this should be the general
pattern".)

## Observability for long-running scripts

A script left running and monitored must emit structured, greppable logs, not silence. Every long
loop (a live capture, a batch, a sweep) logs to a file with, on each line: a UTC timestamp, the
`pid`, and a machine-parseable `ev=<event> key=value` shape (space-free keys/values; free text in a
quoted `msg="..."`). Emit a heartbeat around any call that can block — one line *before* the risky
call and one *after* — so a stall is bracketed and `grep "ev=turn" log | tail -1` shows exactly
where it froze. Monitor by grepping that log, never by guessing from file mtimes or `ps`. Any
subprocess that can hang (screencapture, osascript, a network call) gets a timeout that logs
`ev=*_timeout` and recovers, so one blocked call cannot freeze the run for minutes.

**Watching the run, from the session.** When you start something that runs for minutes (a deploy,
a publish, a batch of browser visits, a Scout review), pick one way to hear back, and don't poll:

- **It ends on its own:** start it with Bash `run_in_background`. The session is told when it exits,
  so don't sleep, re-read its output or tail the log while waiting.
- **You need to hear about a point partway through** (a row reaching a state, the first error, a
  stall): use the Monitor tool with an until-loop that greps the run's `ev=` log for the line that
  matters, for example `until grep -q "ev=row_state .*status=review_finished" out/x.log; do sleep 30; done`.
  Always add a give-up line too (`ev=error`, `ev=*_timeout`, or no new line for N minutes), so a
  dead run doesn't keep you waiting.
- **Something outside the Mac that nothing reports back** (CI, a remote queue): ScheduleWakeup,
  spaced to how fast it really changes.

Say in one line which one you started and what will end it. (Omar, 2026-11-02: "do we need a skill
to properly create the monitor?" — the log shape was written down, how to watch it was not.)
