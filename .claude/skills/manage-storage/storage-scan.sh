#!/usr/bin/env bash
# storage-scan.sh — actionable macOS disk-usage breakdown with cleanup verdicts.
# Read-only. Deletes nothing. Prints top space hogs, classifies each, and
# estimates reclaimable space. Used by the manage-storage skill.
#
# Usage: storage-scan.sh [depth]   (depth defaults to scanning home + known hogs)

set -uo pipefail

HOME_DIR="${HOME}"
human() { du -sh "$@" 2>/dev/null; }

hr()  { printf '─%.0s' $(seq 1 72); echo; }
hdr() { echo; hr; echo "  $1"; hr; }

# Verdict legend:
#   SAFE    = regenerable cache / re-downloadable; clear freely
#   CONFIRM = may hold real data or be in active use; user decides
#   KEEP    = personal data or active config; don't touch
verdict() {
  case "$1" in
    SAFE)    printf '🟢 SAFE   ' ;;
    CONFIRM) printf '🟡 CONFIRM' ;;
    KEEP)    printf '🔵 KEEP   ' ;;
    HOT)     printf '🔴 HOT    ' ;;
  esac
}

# size_of <path> -> bytes (0 if missing)
size_bytes() { du -sk "$1" 2>/dev/null | awk '{print $1*1024}' || echo 0; }
fmt() { # bytes -> human
  awk -v b="$1" 'BEGIN{
    split("B KB MB GB TB",u); s=1;
    while(b>=1024 && s<5){b/=1024;s++}
    printf (s==1?"%d%s":"%.1f%s"), b, u[s]
  }'
}

hdr "DISK OVERVIEW"
diskutil info / 2>/dev/null | grep -iE 'container (total|free) space' || df -h /

hdr "TOP-LEVEL HOME (visible + hidden)"
{ du -sh "$HOME_DIR"/* 2>/dev/null; du -sh "$HOME_DIR"/.[^.]* 2>/dev/null; } | sort -rh | head -20

# --- Classified, actionable findings for known hog locations ---
hdr "ACTIONABLE FINDINGS"
printf '%-9s %10s  %s\n' "VERDICT" "SIZE" "WHAT / SUGGESTION"
hr

# Each row: path | verdict | description
report() {
  local path="$1" v="$2" desc="$3"
  [ -e "$path" ] || return 0
  local b; b=$(size_bytes "$path")
  [ "$b" -lt 52428800 ] && return 0   # skip < 50MB
  printf '%s %10s  %s\n' "$(verdict "$v")" "$(fmt "$b")" "$desc"
}

# Dev / VM / container hogs
report "$HOME_DIR/Library/Application Support/com.apple.container" HOT "Apple native container framework (snapshots+content) — if you use Docker not this, likely abandoned. 'container system start' then prune, or remove if unused"
report "$HOME_DIR/.tart/cache"        HOT     ".tart OCI image cache — re-downloadable. 'tart prune' or rm cache/OCIs/*"
report "$HOME_DIR/.tart/vms"          CONFIRM ".tart VMs — 'tart list' to see stale ones; 'tart delete <name>'"
report "$HOME_DIR/Library/Application Support/Claude/vm_bundles" CONFIRM "Claude Desktop sandbox VM bundle — re-created on demand; remove if you don't use Claude's local VM sandbox"
report "$HOME_DIR/Library/Developer"  CONFIRM "Xcode/sims — sim erase, clear DerivedData, drop old runtimes"
report "$HOME_DIR/.docker"            CONFIRM "Docker config (VM disk is Docker.raw — see skill for compaction)"

# Editor state DBs (Cursor/VSCode keep a giant + a stale backup)
report "$HOME_DIR/Library/Application Support/Cursor/User/globalStorage/state.vscdb.backup" SAFE "Cursor state DB BACKUP — stale duplicate of state.vscdb, safe to delete"
report "$HOME_DIR/Library/Application Support/Code/User/globalStorage/state.vscdb.backup"   SAFE "VSCode state DB BACKUP — stale duplicate, safe to delete"

# Package / build caches (regenerable)
report "$HOME_DIR/.npm"               SAFE    "npm cache — 'npm cache clean --force'"
report "$HOME_DIR/.cache"             SAFE    "misc tool caches — generally safe to clear"
report "$HOME_DIR/.gradle/caches"     SAFE    "Gradle cache — regenerates on next build"
report "$HOME_DIR/.nvm"               CONFIRM "old Node versions — 'nvm ls', remove unused"
report "$HOME_DIR/Library/Caches/pip" SAFE    "pip wheel cache — re-downloads"
report "$HOME_DIR/Library/Caches/Yarn" SAFE   "yarn cache — repopulates"

# LLM models (big, user-specific)
report "$HOME_DIR/.lmstudio"          CONFIRM "LM Studio models/extensions — delete unused models"
report "$HOME_DIR/.ollama/models"     CONFIRM "Ollama models — 'ollama list' then 'ollama rm <model>'"

# Browser caches
report "$HOME_DIR/Library/Caches/Google"  CONFIRM "Chrome cache — safe but re-downloads on browse"
report "$HOME_DIR/Library/Caches/Firefox" CONFIRM "Firefox cache — safe but re-downloads on browse"

# Personal data — never suggest cleaning these
report "$HOME_DIR/Desktop"            KEEP    "Desktop — personal data, DO NOT clean (off-limits)"
report "$HOME_DIR/Downloads"          CONFIRM "Downloads — review, delete what you no longer need"
report "$HOME_DIR/Pictures"           KEEP    "Photos — personal data"
report "$HOME_DIR/Documents"          KEEP    "Documents — personal data"

hdr "APPS — size + last-used (possibly unused)"
echo "Note: macOS no longer reliably records launch dates (kMDItemLastUsedDate is"
echo "usually empty). 'mtime' = bundle last modified (last update) as a proxy."
echo
printf '%8s  %-12s  %s\n' "SIZE" "LAST (proxy)" "APP"
for app in /Applications/*.app; do
  [ -d "$app" ] || continue
  used=$(mdls -name kMDItemLastUsedDate -raw "$app" 2>/dev/null)
  szk=$(du -sk "$app" 2>/dev/null | awk '{print $1}'); szm=$((szk/1024))
  [ "$szm" -lt 100 ] && continue   # only apps >= 100MB
  if [ "$used" = "(null)" ] || [ -z "$used" ]; then
    used="mtime $(stat -f '%Sm' -t '%Y-%m-%d' "$app" 2>/dev/null)"
  else
    used="used ${used%% *}"
  fi
  printf '%6sMB  %-12s  %s\n' "$szm" "$used" "$(basename "$app" .app)"
done | sort -rn | head -25
echo "Review apps you don't recognize/use. Uninstall via the app's own uninstaller"
echo "or drag to Trash + remove its ~/Library/Application Support/<app> data."

hdr "DOCKER (if running)"
if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  docker system df
  raw="$HOME_DIR/Library/Containers/com.docker.docker/Data/vms/0/data/Docker.raw"
  [ -e "$raw" ] && echo "Docker.raw on-disk: $(human "$raw" | cut -f1) (compact via Docker Desktop UI if >> system df total)"
else
  echo "docker not running"
fi

echo
echo "Legend: 🔴 HOT = biggest win  🟢 SAFE = clear freely  🟡 CONFIRM = you decide  🔵 KEEP = personal data"
echo "Nothing was deleted. To clean interactively:  dua ~/.tart ~/Library/Developer ~/Library/Caches"
