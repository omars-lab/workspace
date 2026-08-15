---
name: manage-storage
description: Diagnose and safely free up disk space on macOS. Use when the user says "free up space", "disk is full", "low disk space", "what's taking up space", "clean up my Mac", or asks to prune Docker / clear caches / clean Xcode. Read-only diagnosis first; deletions are tiered by safety and risky ones always require explicit confirmation. Never uses third-party "cleaner" apps.
---

# Manage storage (macOS)

## When to use

User wants to understand where disk space went and reclaim some, safely. Triggers: "free up space", "disk full", "low on storage", "what's eating my disk", "clean caches", "prune docker", "clean up Xcode".

## Core principles

1. **Diagnose before deleting.** Always measure first with read-only tools. Show the user where space is going before removing anything.
2. **Tier every deletion by safety.** Three tiers below. Tier 1 you may run after showing the dry-run. Tier 2 explain, then run with a heads-up. **Tier 3 ALWAYS requires explicit user confirmation** — these can destroy data.
3. **Caches regenerate; data does not.** Only auto-clear things that re-create themselves on next use. Never touch `~/Library/Application Support`, app config, Documents, or anything under a project dir.
3b. **Prefer `trash` over `rm`.** For anything that isn't a pure regenerable cache — app uninstalls, data dirs, models, VMs, "CONFIRM"-tier items — use the built-in `trash <path>` (macOS 15+; moves to `~/.Trash`, recoverable) instead of `rm -rf`. Reserve `rm -rf` for clearly-regenerable caches where recovery is pointless. Remind the user the space frees only after **emptying the Trash** (`du -sh ~/.Trash` shows what's pending).
4. **No third-party cleaners.** CleanMyMac-style apps delete files apps depend on. Use the CLI tools below only.
5. **Snapshots are usually not the problem.** Check, but don't delete APFS snapshots unless the user has a real Time Machine local-snapshot buildup and asks.

## Big wins (check these first — highest GB-per-effort)

Ranked by typical reclaim on a dev Mac. The GUI storage bar hides almost all of these (they live in `~/Library` or hidden dirs and get lumped into "Documents").

1. **Docker `Docker.raw`** (`~/Library/Containers/com.docker.docker/.../Docker.raw`) — can be 60–80 GB while using only ~10 GB. Won't shrink on its own. Compact via **Docker Desktop → Settings → Resources → Disk usage → Clean up** (GUI). Often the single biggest win.
2. **Apple native container framework** (`~/Library/Application Support/com.apple.container`) — macOS 26's built-in Docker alternative (snapshots + content). If the user runs Docker instead, this is often abandoned (its `container system` service may not even be running). Can be 15–20 GB.
3. **Tart VMs** (`~/.tart`) — `cache/OCIs` (re-downloadable base images, SAFE) + `vms` (VM disks). 30–60 GB common. `tart list`, `tart delete <name>`.
4. **Claude Desktop VM bundle** (`~/Library/Application Support/Claude/vm_bundles`) — ~10 GB sandbox VM; re-created on demand.
5. **Xcode** — CoreSimulator devices (erase/delete old runtimes), DerivedData, iOS/watchOS DeviceSupport. 20–40 GB.
6. **Editor state DBs** — Cursor/VSCode keep `globalStorage/state.vscdb` AND a same-size `state.vscdb.backup`. The `.backup` is a stale duplicate (often several GB) — SAFE to delete.
7. **LLM models** — `~/.ollama/models`, `~/.lmstudio` (note: LM Studio's `extensions/backends` is the engine, NOT models). `ollama rm <model>`.
8. **Package caches** — `~/.npm` (`npm cache clean --force`), `~/.cache`, `~/.gradle/caches`, `~/Library/Caches/{pip,Yarn}`.
9. **Unused Applications** — see the scanner's APPS section; uninstall ones you don't use (+ their Application Support data).

## Diagnosis checklist (what to inspect every scan)

Run `storage-scan.sh` — it covers all of these — but the checklist is the mental model:

- [ ] Real free space: `diskutil info / | grep -i free` (NOT just Finder/Settings).
- [ ] Top-level home, **visible + hidden**: `du -sh ~/* ~/.[^.]* | sort -rh`.
- [ ] `~/Library/Containers` → Docker (`Docker.raw` actual vs `docker system df`).
- [ ] `~/Library/Application Support` → com.apple.container, Claude vm_bundles, Cursor/Code globalStorage, Neo4j, big app data.
- [ ] `~/Library/Developer` → Xcode sims / DerivedData / DeviceSupport.
- [ ] `~/Library/Caches` → browser, pip, yarn, JetBrains, playwright.
- [ ] Hidden dev dirs → `~/.tart`, `~/.npm`, `~/.ollama`, `~/.lmstudio`, `~/.cache`, `~/.gradle`, `~/.nvm`.
- [ ] Docker internals → images (surgical, not `prune -a`), build cache, unused volumes (= live DB data, CONFIRM).
- [ ] APFS snapshots (informational): `tmutil listlocalsnapshots /`.
- [ ] Apps by size + last-used (scanner APPS section) → flag unused.
- [ ] **Never** flag off-limits dirs (Desktop, Pictures, Documents, Movies, Music) for cleanup.

## Tools

Read-only analyzers (install via `brew install dust dua-cli` if missing):

- **`dust -d 2 <dir>`** — fast tree view with size bars. Pure read-only. First thing to run.
- **`dua <dir>...`** — interactive: navigate, mark with space, **review the marked list, then commit**. Safest interactive deleter (batches + confirms, unlike `ncdu` which deletes per-item immediately).

Built-in diagnosis (no install):
```bash
diskutil info / | grep -i 'free space'   # real free space (incl. purgeable)
df -h /
du -sh ~/Library/Caches ~/Library/Developer ~/Downloads 2>/dev/null
```

## Workflow

### 1. Diagnose (read-only — always do this first)

**Run the bundled scanner** for an actionable, classified breakdown — it finds top hogs across visible AND hidden home dirs, tags each with a verdict (🔴 HOT / 🟢 SAFE / 🟡 CONFIRM / 🔵 KEEP) and a cleanup suggestion, and reports Docker + `Docker.raw`. Deletes nothing.
```bash
"$CLAUDE_PLUGIN_ROOT/storage-scan.sh"   # or: .claude/skills/manage-storage/storage-scan.sh
```
The System Settings storage bar is too coarse (lumps almost everything into "Documents" and never finishes "Calculating") — always prefer the scanner. Hidden dirs (`~/.tart`, `~/.npm`, `~/.lmstudio`, `~/.ollama`, `~/.cache`) are frequent hidden hogs the GUI never surfaces.

Manual fallback if the script isn't available:
```bash
diskutil info / | grep -i 'free space'
{ du -sh ~/* 2>/dev/null; du -sh ~/.[^.]* 2>/dev/null; } | sort -rh | head -20
du -sh ~/Library/Caches/* ~/Library/Developer/* 2>/dev/null | sort -rh | head
```
Check snapshots (informational): `tmutil listlocalsnapshots /`. `dust -d 2 ~/Library` gives a visual tree. Report the top hogs to the user before touching anything.

### 2. Tier 1 — safe automated reclaim (regenerable, low risk)
Show output as you go. Each item re-creates itself on demand.
```bash
brew cleanup -n      # ALWAYS dry-run first
brew cleanup         # old formula versions, logs, download cache

xcrun simctl delete unavailable   # simulators for OS versions no longer installed

# regenerable language/tool caches (re-downloaded on next use):
rm -rf ~/Library/Caches/pip
rm -rf ~/Library/Caches/Yarn
rm -rf ~/Library/Caches/ms-playwright   # only if no playwright process running; `pgrep -fl playwright` first. Re-install via `playwright install`
npm cache clean --force                 # ~/.npm download cache
```
Before any `rm`: confirm it's a cache (not config/data) and no related process is running.

**Tart VMs (`~/.tart`) — often the single biggest hog on dev machines.** Tart runs macOS/Linux VMs on Apple Silicon (CI, isolated build envs). Two parts:
- `~/.tart/cache/OCIs` — downloaded base images, **re-pullable → SAFE** to clear.
- `~/.tart/vms` — actual VM disks (multi-GB each). `tart list` shows name + last-accessed; delete stale ones with `tart delete <name>` (CONFIRM — it's a VM the user built).

**LLM model stores (CONFIRM — user-specific, big):**
- Ollama: `ollama list` → `ollama rm <model>` for unused models.
- LM Studio: `~/.lmstudio` — delete unused downloaded models in-app or by folder.

### 3. Tier 2 — Docker prune (safe subset; explain first)
Check what's reclaimable:
```bash
docker system df
```
**Safe (no data loss) — run after telling the user:**
```bash
docker builder prune -f        # build cache
docker image prune -f          # DANGLING (untagged) images only
docker container prune -f      # STOPPED containers only — confirm none are intentionally stopped
```
**Tier 3 (see below) for `-a` and `--volumes`.**

**Gotcha — the Docker VM disk can be full while the Mac has free space.** Docker Desktop on macOS runs in a Linux VM backed by `~/Library/Containers/com.docker.docker/Data/vms/0/data/Docker.raw`. If `docker rmi` fails with `no space left on device`, the *VM's internal* disk is full (not your Mac). Free internal space first with `docker builder prune -af` (build cache is the safest internal reclaim), which usually gives enough room to then delete images.

**Prefer surgical removal over `docker image prune -a`.** `prune -a` is blunt and the auto-mode classifier blocks it (Tier 3). Instead, compute which images no container references and remove those by ID:
```bash
# image IDs referenced by ANY container (running OR stopped):
docker inspect --format '{{.Image}}' $(docker ps -aq) | sort -u
# compare against `docker images --no-trunc -q`; rmi only the IDs NOT in that set
```
Note: a failed `rmi` can untag an image (removing the tag it could write) but leave the layers — these then show as `<untagged>`/dangling and can be removed by ID once space is freed.

**After deleting, `Docker.raw` does NOT shrink on its own.** Freed space lives *inside* the VM; the host `.raw` stays at its high-water mark (often tens of GB). To reclaim it on the Mac, the user must compact via **Docker Desktop → Settings → Resources → "Clean up / disk usage"** (a GUI action — do not attempt from CLI). Surface this to the user as the big remaining win when `Docker.raw` (`du -sh` it) is far larger than `docker system df` total.

### 4. Tier 3 — DESTRUCTIVE, require explicit confirmation
Never run these without the user explicitly saying yes. Each can delete real data.
```bash
docker image prune -a -f       # removes ALL images not used by a running container — will re-pull/rebuild
docker volume prune -f         # deletes UNUSED named volumes — DATABASE DATA can live here
docker system prune -a --volumes  # nuclear: everything above at once

rm -rf ~/Library/Developer/Xcode/DerivedData    # build artifacts (regenerate on rebuild) — usually fine but confirm
rm -rf ~/Library/Developer/Xcode/Archives       # SHIPPED APP ARCHIVES — may be irreplaceable, confirm hard
# old iOS DeviceSupport — keep current versions:
#   ~/Library/Developer/Xcode/iOS DeviceSupport
# extra Swift Toolchains — only remove ones the user confirms unused
```
**Docker volumes — "unused" ≠ "safe to delete".** `docker volume ls` shows volumes not mounted by a *currently running* container as unused, but for stopped/`down` compose stacks those named `*_data` volumes hold real DB state (postgres/neo4j/qdrant/etc.) you'll want on restart. Never `volume prune` blindly. Identify in-use vs unused by name, then:
- Anonymous-hash volumes (64-char hex names) are usually throwaway — safe to remove.
- Named `*_data` volumes — confirm the stack is truly dead before removing; deletion is permanent data loss.

For browser caches (`~/Library/Caches/Google`, `Firefox`, `Mozilla`) and `~/Downloads`: don't auto-delete. Point the user at `dua` to review and remove interactively.

## SOP — cleanly uninstall an app

Dragging an app to Trash leaves GB of data behind in `~/Library`. To fully remove an app and its footprint:

1. **Quit the app first.** `pgrep -x "<AppName>"` — abort if running.
2. **Find the bundle ID** (leftovers are named by it, not the app name — e.g. Cursor → `com.todesktop.230313mzl4w4u92`):
   ```bash
   osascript -e 'id of app "<AppName>"'    # or: defaults read /Applications/<AppName>.app/Contents/Info CFBundleIdentifier
   ```
3. **Locate the full footprint** (app + all support/cache/pref dirs):
   ```bash
   APP="<AppName>"; BID="<bundle.id>"
   du -sh "/Applications/$APP.app" \
     "$HOME/Library/Application Support/$APP" \
     "$HOME/Library/Caches/$APP" "$HOME/Library/Caches/$BID"* \
     "$HOME/Library/Preferences/$BID.plist" \
     "$HOME/Library/HTTPStorages/$BID"* \
     "$HOME/Library/Saved Application State/$BID.savedState" \
     "$HOME/Library/Logs/$APP" "$HOME/.$APP" 2>/dev/null
   ```
4. **Trash (not rm) everything found** so it's recoverable:
   ```bash
   trash "/Applications/$APP.app" "$HOME/Library/Application Support/$APP" ...
   ```
   If `trash` hits "Directory not empty" (a same-named item already in Trash), move with a unique suffix: `mv "<path>" "$HOME/.Trash/<name>-$(date +%s)"`.
5. **Confirm gone**, then tell the user to **empty Trash** to actually reclaim the space (`du -sh ~/.Trash`).

For a reusable GUI/CLI tool that auto-discovers leftovers: **Pearcleaner** (`brew install --cask pearcleaner`). The built-in `trash` SOP above needs no install and is fully recoverable.

### 5. Report
Re-run the step-1 diagnosis, compare to baseline, and state how much was freed (`before → after`).

## Off-limits — never clean or suggest cleaning

- `~/Desktop` — personal data (paperwork, family, documents). The scanner marks it KEEP. Even if it's large, do NOT propose deleting or organizing it as part of cleanup.
- `~/Pictures`, `~/Documents`, `~/Movies`, `~/Music`, iCloud/Dropbox-synced dirs — personal data.

## Safety checklist (never violate)

- [ ] Ran read-only diagnosis and showed the user before deleting.
- [ ] `brew cleanup -n` before `brew cleanup`.
- [ ] No `rm` under Application Support, config dirs, Documents, or project dirs.
- [ ] Tier 3 commands only after explicit user "yes".
- [ ] `docker volume prune` / `--volumes` treated as data-destroying — confirmed which volumes hold real data first.
- [ ] No third-party cleaner apps.
- [ ] Didn't delete APFS snapshots unless user explicitly asked.

## What this skill deliberately doesn't do

- No third-party cleaner apps, no "one-click" deletion of everything.
- No deleting user Documents, Photos, app data, or config.
- No touching system files outside the user's `~/Library` caches and dev artifacts.
- No automatic APFS snapshot or Time Machine deletion.
