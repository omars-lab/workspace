# Plan: Safely free up disk space with Mac CLI tools

## Context

The user's Mac is critically low on disk space and wants a **brew-installable CLI** to help free it up **safely** (no auto-deleting "cleaner" apps that nuke files apps depend on).

Live diagnosis of this machine (arm64, macOS 26.3.1):

- **Real free space: 7.3 GB / 494 GB** (`diskutil info /`) — genuinely tight.
- **APFS local snapshots:** only 3 OS-update snapshots — small, system-managed, *leave them alone*. Time Machine is NOT hoarding space, so the common "purgeable snapshot" culprit does not apply here.
- **The actual space hogs are concrete and safe to address:**
  - `~/Library/Developer` — **28 GB**: CoreSimulator 13G, Xcode 9.2G, Toolchains 5.9G
  - `~/Library/Caches` — **16 GB**: Google/Chrome 4.1G, Firefox 3.0G, ms-playwright 1.7G, pip 1.4G, VSCode ShipIt 997M, JetBrains 861M, aws 778M, Yarn 559M, Homebrew 544M
  - `~/Downloads` — **1.3 GB**
  - Homebrew cache — **544 MB**

Intended outcome: install a fast read-only analyzer + a safe interactive deleter, run a few known-safe reclaim commands, then guide the user through reviewing the rest themselves.

## Decisions (confirmed with user)

- **Tools:** `dust` (fast read-only tree overview) + `dua` (interactive; marks items into a list and reviews BEFORE committing the delete — safest cleanup UX). Both Rust, fast on arm64.
- **Scope:** Safe automated wins + guided manual. Run only known-safe, regenerable-cache cleanups automatically; use the tools for everything else interactively.

## Why dust + dua over alternatives

- `dust`: instant visual tree with size bars, **read-only** — zero deletion risk, perfect for "where did it go."
- `dua interactive`: navigate, mark with space, review the marked list, then commit. Unlike `ncdu` (deletes each item immediately on `d`), dua batches + confirms, matching the "safe" requirement.
- Rejected: CleanMyMac-style cleaners (can delete app-critical files); `ncdu` alone (per-item immediate delete, no batch review).

## Implementation steps

### 1. Install the tools
```bash
brew install dust dua-cli
```
(`dua-cli` is the formula name; the binary is `dua`.)

### 2. Get the lay of the land (read-only)
```bash
dust -d 2 ~/Library          # tree overview, depth 2
dua ~/Library/Developer ~/Library/Caches   # interactive browse of the two big dirs
```

### 3. Safe automated reclaim (regenerable only — each is re-created on demand)
Run these, reviewing output as we go:
```bash
# Homebrew old versions + download cache (~544M+). Preview first:
brew cleanup -n
brew cleanup

# Xcode: delete simulators for OS versions no longer installed (safe; big win on the 13G CoreSimulator)
xcrun simctl delete unavailable

# Regenerable language/tool caches (re-downloaded on next use):
rm -rf ~/Library/Caches/pip          # 1.4G — pip re-downloads wheels as needed
rm -rf ~/Library/Caches/ms-playwright # 1.7G — only if not actively running playwright; re-install via `playwright install`
rm -rf ~/Library/Caches/Yarn         # 559M — yarn repopulates
```
NOTE: before each `rm`, confirm the dir is a cache (not config/data) and that no related process is running. These four are all safe regenerable caches.

### 4. Guided manual review (user-driven, via the tools)
Walk the user through, using `dua` for safe marked-then-confirmed deletion:
- `~/Library/Developer/Xcode/DerivedData` and `Archives` — build artifacts, safe to clear (rebuild regenerates).
- `~/Library/Developer/Xcode/iOS DeviceSupport` — old device-support files; keep only current iOS versions.
- `~/Library/Caches/Google`, `Firefox`, `Mozilla` — browser caches; safe but will re-download on browsing. User decides.
- `~/Downloads` — user reviews and removes what they no longer need.
- Toolchains (5.9G) — only remove if the user knows which extra Swift toolchains are unused (NOT automated).

### 5. Re-check results
```bash
diskutil info / | grep -i 'free'
df -h /
```

## Critical "do NOT touch" notes (safety)

- Do **not** delete APFS snapshots here — they're tiny OS-update snapshots, not the problem.
- Do **not** run any third-party "cleaner."
- Do **not** `rm` anything under `~/Library/Application Support` or app config dirs — those are data, not caches.
- Always `brew cleanup -n` (dry run) before the real `brew cleanup`.

## Verification

1. After step 1: `which dust dua` → both resolve.
2. After step 3: re-run `du -sh ~/Library/Caches ~/Library/Developer` and compare to baseline (16G / 28G) to quantify reclaim.
3. Final: `diskutil info / | grep -i free` should show free space materially above the starting 7.3 GB (expected reclaim from automated steps alone ≈ 5–8 GB; more after guided manual review).

## Sources

- [ncdu / dua / dust / gdu comparison — dalanmiller, X-CMD, AlternativeTo](https://github.com/Byron/dua-cli)
- [Auditing free drive space on macOS — TidBITS](https://tidbits.com/2023/02/24/auditing-free-drive-space-where-have-all-the-gigabytes-gone/)
- [Clearing purgeable space & APFS snapshots — MacPaw](https://macpaw.com/how-to/purgeable-space-on-macos)
